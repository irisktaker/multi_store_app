import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/app_bar_widget.dart';

import 'visit_store.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBarTitle(title: 'Stores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('suppliers').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisitStore(
                            suppliersId: snapshot.data!.docs[index]
                                ['supplier_id'],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Image.asset('images/inapp/store.jpg'),
                            ),
                            Positioned(
                              bottom: 28,
                              left: 10,
                              child: SizedBox(
                                height: 48,
                                width: 100,
                                child: Image.network(
                                  snapshot.data!.docs[index]['store_logo'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          snapshot.data!.docs[index]['store_name']
                              .toString()
                              .toLowerCase(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontFamily: 'AkayaTelivigala',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return const Center(
              child: Text('No Stores'),
            );
          },
        ),
      ),
    );
  }
}
