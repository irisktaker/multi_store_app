import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/models/products_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class MenGalleryScreen extends StatefulWidget {
  const MenGalleryScreen({Key? key}) : super(key: key);

  @override
  State<MenGalleryScreen> createState() => _MenGalleryScreenState();
}

class _MenGalleryScreenState extends State<MenGalleryScreen> {
  @override
  Widget build(BuildContext context) {
    // final Stream<QuerySnapshot> _productsStream =
    // FirebaseFirestore.instance.collection('products').snapshots();

    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where(
          'main-category',
          isEqualTo: 'men',
        )
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "This category\n\nhas no items yet.",
              style: TextStyle(
                fontSize: 26,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontFamily: 'Acme',
                letterSpacing: 1.5,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: StaggeredGridView.countBuilder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ProductModel(
                products: snapshot.data!.docs[index],
              );
            },
            staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
          ),
        );

        // return ListView(
        //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //     Map<String, dynamic> data =
        //         document.data()! as Map<String, dynamic>;
        //     return ListTile(
        //       leading: Image(image: NetworkImage(data['product-images'][0])),
        //       title: Text(data['product-name']),
        //       subtitle: Text(data['price'].toString()),
        //     );
        //   }).toList(),
        // );
      },
    );
  }
}
