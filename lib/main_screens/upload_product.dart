import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/utilities/categories_list.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String proName;
  late String proDesc;
  late String proId;
  bool processing = false;

  String mainCategoryValue = 'select category';
  String subcategoryValue = 'subcategory';
  List<String> subcategoryList = [];

  final ImagePicker _picker = ImagePicker();
  List<XFile> imagesFileList = [];
  List<String> imageUrlList = [];
  dynamic _pickedImageError;

  void pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );

      setState(() {
        imagesFileList = pickedImages;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Widget previewImages() {
    return ListView.builder(
      itemCount: imagesFileList.length,
      itemBuilder: (context, index) {
        return Image.file(
          File(imagesFileList[index].path),
        );
      },
    );
  }

  void selectMainCategory(String? value) {
    if (value == 'select category') {
      subcategoryList = [];
    } else if (value == 'men') {
      subcategoryList = men;
    } else if (value == 'women') {
      subcategoryList = women;
    } else if (value == 'electronics') {
      subcategoryList = electronics;
    } else if (value == 'accessories') {
      subcategoryList = accessories;
    } else if (value == 'shoes') {
      subcategoryList = shoes;
    } else if (value == 'home & garden') {
      subcategoryList = homeandgarden;
    } else if (value == 'beauty') {
      subcategoryList = beauty;
    } else if (value == 'kids') {
      subcategoryList = kids;
    } else if (value == 'bags') {
      subcategoryList = bags;
    }

    print(value);
    setState(() {
      mainCategoryValue = value.toString();
      subcategoryValue = 'subcategory';
    });
  }

  Future<void> uploadImages() async {
    if (mainCategoryValue != 'select category' &&
        subcategoryValue != 'subcategory') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        if (imagesFileList.isNotEmpty) {
          try {
            setState(() {
              processing = true;
            });
            for (var image in imagesFileList) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imageUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e.toString());
          }
        } else {
          MyMessageHandler.showSnackBar(
            _scaffoldKey,
            'please pick images.',
          );
        }
      } else {
        MyMessageHandler.showSnackBar(
          _scaffoldKey,
          'please fill all felids',
        );
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please select categories.');
    }
  }

  Future<void> uploadData() async {
    if (imageUrlList.isNotEmpty) {
// create collection
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('products');

      proId = const Uuid().v4();
      await productRef.doc(proId).set({
        'main-category': mainCategoryValue,
        'sub-category': subcategoryValue,
        'price': price,
        'quantity': quantity,
        'product-name': proName,
        'product-description': proDesc,
        'supplier-id': FirebaseAuth.instance.currentUser!.uid,
        'product-images': imageUrlList,
        'discount': 0,
        'product-id': proId,
      }).whenComplete(() {
        setState(() {
          imagesFileList = [];
          subcategoryList = [];
          imageUrlList = [];
          mainCategoryValue = 'select category';
          processing = false;
        });
        _formKey.currentState!.reset();
      });
    } else {
      print('no images');
    }
  }

  void uploadProduct() async {
    uploadImages().whenComplete(() => uploadData());
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Stack(
                      // children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.50,
                        width: MediaQuery.of(context).size.width * 0.50,
                        color: Colors.blueGrey.shade100,
                        child: imagesFileList.isNotEmpty
                            ? previewImages()
                            : const Center(
                                child: Text(
                                  'You have not\n\npicked images yet!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      ),
                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      //   child: Visibility(
                      //     visible: imagesFileList.isEmpty,
                      //     replacement: IconButton(
                      //         onPressed: () {
                      //           setState(() {
                      //             imagesFileList.clear();
                      //           });
                      //         },
                      //         icon: const Icon(
                      //           Icons.delete,
                      //         )),
                      //     child: Container(),
                      //   ),
                      // ),
                      // ],
                      // ),

                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.45,
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  '* select main category.',
                                  style: TextStyle(color: Colors.red),
                                ),
                                DropdownButton(
                                  iconSize: 40,
                                  iconEnabledColor: Colors.red,
                                  dropdownColor: Colors.yellow.shade300,
                                  menuMaxHeight: 500,
                                  items: maincateg
                                      /* [
                                'men',
                                'women',
                                'shoes',
                                'bags',
                              ]*/
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    );
                                  }).toList(),
                                  /*  const [
                                DropdownMenuItem(
                                  child: Text(
                                    'men',
                                  ),
                                  value: 'men',
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    'women',
                                  ),
                                  value: 'women',
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    'electronics',
                                  ),
                                  value: 'electronics',
                                ),
                              ],*/
                                  value: mainCategoryValue,
                                  onChanged: (String? value) {
                                    selectMainCategory(value);
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  '* select category.',
                                  style: TextStyle(color: Colors.red),
                                ),
                                DropdownButton(
                                  iconSize: 40,
                                  iconEnabledColor: Colors.red,
                                  dropdownColor: Colors.yellow.shade300,
                                  iconDisabledColor: Colors.black,
                                  menuMaxHeight: 500,
                                  disabledHint:
                                      const Text('select subcategory'),
                                  items: subcategoryList
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    );
                                  }).toList(),
                                  value: subcategoryValue,
                                  onChanged: (value) {
                                    print(value);

                                    setState(() {
                                      subcategoryValue = value.toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter a price.';
                          } else if (value.isValidPrice() != true) {
                            return 'please enter a valid price';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          price = double.parse(value!);
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Price',
                          hintText: 'price .. \$',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please add quantity.';
                          } else if (value.isValidQuantity() != true) {
                            return 'please add valid quantity';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          quantity = int.parse(value!);
                        },
                        keyboardType: TextInputType.number,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Quantity',
                          hintText: 'add quantity',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter a product name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          proName = value!;
                        },
                        maxLength: 100,
                        maxLines: 3,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Product Name',
                          hintText: 'enter product name',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter a product description.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          proDesc = value!;
                        },
                        maxLength: 800,
                        maxLines: 5,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Product Description',
                          hintText: 'enter product description',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                onPressed: imagesFileList.isEmpty
                    ? () {
                        pickProductImages();
                      }
                    : () {
                        setState(() {
                          imagesFileList.clear();
                        });
                      },
                backgroundColor: Colors.yellow,
                child: imagesFileList.isEmpty
                    ? const Icon(
                        Icons.photo_library,
                        color: Colors.black,
                      )
                    : const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
              ),
            ),
            FloatingActionButton(
              onPressed: processing
                  ? null
                  : () {
                      uploadProduct();
                    },
              backgroundColor: Colors.yellow,
              child: processing
                  ? const CircularProgressIndicator(
                      color: Colors.purpleAccent,
                    )
                  : const Icon(
                      Icons.upload,
                      color: Colors.black,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'price',
  hintText: 'price .. \$',
  labelStyle: const TextStyle(
    color: Colors.purple,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.yellow),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.blueAccent,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
);

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    // return RegExp(r'^\d+(,\d{3})*(\.\d{1,2})?$').hasMatch(this);

    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}
