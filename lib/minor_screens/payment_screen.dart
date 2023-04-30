import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/widgets/app_bar_widget.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CollectionReference customer =
      FirebaseFirestore.instance.collection('customers');

  int selectedValue = 1;
  late String orderId;

  bool process = false;

  void showProgress() {
    setState(() {
      process = true;
    });
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(
      max: 100,
      msg: 'Please wait ...',
      progressBgColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;

    return FutureBuilder<DocumentSnapshot>(
      future: customer.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child:
                Center(child: CircularProgressIndicator(color: Colors.purple)),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Material(
            color: Colors.grey.shade200,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey.shade200,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.grey.shade200,
                  leading: const AppBarBackButton(),
                  title: const AppBarTitle(title: 'Payment'),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    60,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "${totalPaid.toStringAsFixed(2)} USD",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Order total",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${totalPrice.toStringAsFixed(2)} USD",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Shopping cost",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '10.00' + ("USD"),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              RadioListTile(
                                value: 1,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text("Cash On Delivery"),
                                subtitle: const Text("Pay Cash At Home"),
                              ),
                              RadioListTile(
                                value: 2,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text("Pay Via Visa / MasterCard"),
                                subtitle: Row(
                                  children: const [
                                    Icon(
                                      Icons.payment,
                                      color: Colors.blue,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Icon(
                                        FontAwesomeIcons.ccVisa,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.ccMastercard,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                              RadioListTile(
                                value: 3,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text("Pay Via PayPal"),
                                subtitle: const Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Icon(
                                    FontAwesomeIcons.paypal,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: Container(
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: YellowButton(
                      label: 'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                      widthRatio: 1,
                      onPressed: () {
                        if (selectedValue == 1) {
                          if (kDebugMode) {
                            print('cash on delivery');
                          }

                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.30,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Pay At Home ${totalPaid.toStringAsFixed(2)} \$",
                                        style: const TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: YellowButton(
                                          label:
                                              'Confirm ${totalPaid.toStringAsFixed(2)}',
                                          onPressed: process
                                              ? null
                                              : () async {
                                                  showProgress();

                                                  // create a collection reference for orders
                                                  for (var item in context
                                                      .read<Cart>()
                                                      .getCartItems) {
                                                    CollectionReference
                                                        ordersRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'orders');

                                                    // generate a random id for each order
                                                    orderId = const Uuid().v4();
                                                    await ordersRef
                                                        .doc(orderId)
                                                        .set(
                                                      {
                                                        'customer_id':
                                                            data['customer_id'],
                                                        'address':
                                                            data['address'],
                                                        'email': data['email'],
                                                        'name': data['name'],
                                                        'phone': data['phone'],
                                                        'profileimage': data[
                                                            'profileimage'],
                                                        // ..

                                                        'supplier_id':
                                                            item.supplierId,
                                                        'product_id':
                                                            item.documentId,
                                                        'order_name': item.name,
                                                        'order_image': item
                                                            .imagesUrl.first,
                                                        'order_quantity':
                                                            item.quantity,
                                                        'order_price':
                                                            item.price *
                                                                item.quantity,

                                                        //..
                                                        'order_id': orderId,
                                                        'delivery_state':
                                                            'preparing',
                                                        'order_date':
                                                            DateTime.now(),
                                                        'delivery_date': '',
                                                        'payment_status':
                                                            'cash on delivery',
                                                        'order_review': false,
                                                      },
                                                    ).whenComplete(() async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .runTransaction(
                                                        (transaction) async {
                                                          // Create a reference to the document the transaction will use
                                                          DocumentReference
                                                              documentReference =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'products')
                                                                  .doc(item
                                                                      .documentId);

                                                          DocumentSnapshot
                                                              documentSnapshot =
                                                              await transaction.get(
                                                                  documentReference);

                                                          transaction.update(
                                                            documentReference,
                                                            {
                                                              'quantity': documentSnapshot[
                                                                      'quantity'] -
                                                                  item.quantity,
                                                            },
                                                          );
                                                        },
                                                      );
                                                    });
                                                  }

                                                  await Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  100))
                                                      .whenComplete(() {
                                                    context
                                                        .read<Cart>()
                                                        .clearList();
                                                    Navigator.popUntil(
                                                        context,
                                                        ModalRoute.withName(
                                                            '/customer_home'));
                                                  });

                                                  setState(() {
                                                    process = false;
                                                  });
                                                },
                                          widthRatio: 0.85,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (selectedValue == 2) {
                          if (kDebugMode) {
                            print('pay via visa / mastercard');
                          }
                        } else if (selectedValue == 3) {
                          if (kDebugMode) {
                            print('pay via paypal');
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Container(),
        );
      },
    );
  }
}
