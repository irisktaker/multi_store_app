import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../widgets/auth_widgets.dart';

// final TextEditingController _nameController = TextEditingController();
// final TextEditingController _emailController = TextEditingController();
// final TextEditingController _passwordController = TextEditingController();

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late String name;
  late String email;
  late String password;
  late String profileImage;
  late String _uid;
  bool passwordVisible = false;
  bool processing = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickedImageError;

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 95,
      );

      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      if (kDebugMode) {
        print(_pickedImageError);
      }
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 95,
      );

      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      if (kDebugMode) {
        print(_pickedImageError);
      }
    }
  }

  void signUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          // print('image picked');
          // print('valid');
          // print('name: $name, email: $email, password: $password');

          // to create a new user in firebase
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          //..

          // upload customer information to firebase fire_storage
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('customer-images/$email.jpg');

          await ref.putFile(File(_imageFile!.path));

          _uid = FirebaseAuth.instance.currentUser!.uid;

          profileImage = await ref.getDownloadURL();
          //..
          // create a collection reference or instance of cloud_fire_store
          // coz we need to take all data and send them to cloud_fire_store
          await customers.doc(_uid).set({
            'name': name,
            'email': email,
            'profileimage': profileImage,
            'phone': '',
            'address': '',
            'customer_id': _uid,
          });
          //..

          // this is to reset all values after sign up
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });

          // nav to next screen
          await Future.delayed(const Duration(milliseconds: 100)).whenComplete(
            () => Navigator.pushReplacementNamed(context, '/customer_login'),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The password provided is too weak.');

            setState(() {
              processing = false;
            });
          } else if (e.code == 'email-already-in-use') {
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The account already exist for that email');

            setState(() {
              processing = false;
            });
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
          setState(() {
            processing = false;
          });
        }
      } else {
        MyMessageHandler.showSnackBar(_scaffoldKey, 'please pick an image');
        setState(() {
          processing = false;
        });
      }

      // setState(() {
      //   name = _nameController.text;
      //   email = _emailController.text;
      //   password = _passwordController.text;
      // });
    } else {
      // print('not valid');
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
      setState(() {
        processing = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     duration: Duration(seconds: 2),
      //     backgroundColor: Colors.yellow,
      //     content: Text(
      //       'please fill all fields',
      //       textAlign: TextAlign.center,
      //       style: TextStyle(
      //         fontSize: 18,
      //         color: Colors.black,
      //       ),
      //     ),
      //   ),
      // );
    }
  }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: 'Sign Up',
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(
                                      _imageFile!.path,
                                    )),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // print('pick image from camera');
                                    _pickImageFromCamera();
                                  },
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // print('pick image from gallery');
                                    _pickImageFromGallery();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter your full name";
                            }
                            return null;
                          },
                          // controller: _nameController,
                          onChanged: (value) {
                            name = value;
                            // print('n: $name');
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormFieldDecoration.copyWith(
                            labelText: "Full Name",
                            hintText: "Enter yur full name",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter your email";
                            } else if (!value.isValidEmail()) {
                              return "invalid email";
                            } else if (value.isValidEmail()) {
                              return null;
                            }
                            return null;
                          },
                          // controller: _emailController,
                          onChanged: (value) {
                            email = value;
                            // print('e: $email');
                          },
                          decoration: textFormFieldDecoration.copyWith(
                            labelText: "Email Address",
                            hintText: "Enter yur full email",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter your password";
                            }
                            return null;
                          },
                          // controller: _passwordController,
                          onChanged: (value) {
                            password = value;
                            // print('p: $password');
                          },
                          obscureText: passwordVisible,
                          decoration: textFormFieldDecoration.copyWith(
                            labelText: "Password",
                            hintText: "Enter yur full password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                      ),
                      HaveAccount(
                        haveAccount: 'already have account? ',
                        actionLabel: 'Log In',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, "/customer_login");
                        },
                      ),
                      processing
                          ? const CircularProgressIndicator(
                              color: Colors.purple)
                          : AuthMainButton(
                              mainButtonLabel: 'Sign Up',
                              onPressed: () {
                                signUp();
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
