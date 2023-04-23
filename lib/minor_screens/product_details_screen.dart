import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/main_screens/visit_store.dart';
import 'package:multi_store_app/models/products_model.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/wish_provider.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badges;

import 'full_screen_view.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic productList;
  const ProductDetailsScreen({Key? key, required this.productList})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.productList['product-images'];

  late final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where(
        'main-category',
        isEqualTo: widget.productList['main-category'],
      )
      .where(
        'sub-category',
        isEqualTo: widget.productList['sub-category'],
      )
      .snapshots();

  @override
  Widget build(BuildContext context) {
    var existingWishlistItems =
        context.read<Wish>().getWishItems.firstWhereOrNull(
              (product) =>
                  product.documentId == widget.productList["product-id"],
            );

    var existingCartListItems =
        context.read<Cart>().getCartItems.firstWhereOrNull(
              (product) =>
                  product.documentId == widget.productList['product-id'],
            );

    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenView(imagesList: imagesList),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            itemCount: imagesList.length,
                            itemBuilder: (context, index) {
                              return Image(
                                image: NetworkImage(
                                  imagesList[index],
                                ),
                              );
                            },
                            pagination: const SwiperPagination(
                              builder: SwiperPagination.fraction,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productList['product-name'],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'USD ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.productList['price']
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                existingWishlistItems != null
                                    ? context.read<Wish>().removeThis(
                                          widget.productList['product-id'],
                                        )
                                    : context.read<Wish>().addWishItem(
                                          widget.productList['product-name'],
                                          widget.productList['product-id'],
                                          widget.productList['supplier-id'],
                                          widget.productList['price'],
                                          1,
                                          widget.productList['quantity'],
                                          widget.productList['product-images'],
                                        );
                              },
                              icon: context
                                          .watch<Wish>()
                                          .getWishItems
                                          .firstWhereOrNull(
                                            (product) =>
                                                product.documentId ==
                                                widget
                                                    .productList["product-id"],
                                          ) !=
                                      null
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_border_outlined,
                                      color: Colors.red,
                                    ),
                            ),
                          ],
                        ),
                        Text(
                          widget.productList['quantity'].toString() +
                              (' pieces available in stock'),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const ProductDetailsHeader(
                          label: '  Item Description  ',
                        ),
                        Text(
                          widget.productList['product-description'],
                          textScaleFactor: 1.1,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const ProductDetailsHeader(
                          label: ' Recommended Items ',
                        ),
                        Container(
                          color: Colors.blueGrey.shade50,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _productsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text("Something went wrong"));
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                  staggeredTileBuilder: (context) =>
                                      const StaggeredTile.fit(1),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VisitStore(
                                suppliersId: widget.productList['supplier-id'],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.store),
                      ),
                      const SizedBox(width: 15),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CartScreen(canPop: true),
                            ),
                          );
                        },
                        icon: badges.Badge(
                            badgeStyle: const badges.BadgeStyle(
                              badgeColor: Colors.yellow,
                              // padding: EdgeInsets.all(2),
                            ),
                            showBadge:
                                context.read<Cart>().getCartItems.isNotEmpty,
                            badgeContent: Text(
                              context
                                  .watch<Cart>()
                                  .getCartItems
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            child: const Icon(Icons.shopping_cart)),
                      ),
                    ],
                  ),
                  YellowButton(
                    label: existingCartListItems != null
                        ? 'Added to cart'.toUpperCase()
                        : 'ADD TO CART',
                    onPressed: () {
                      existingCartListItems != null
                          ? MyMessageHandler.showSnackBar(
                              _scaffoldKey,
                              "This item is already in cart.",
                            )
                          : context.read<Cart>().addItem(
                                widget.productList['product-name'],
                                widget.productList['product-id'],
                                widget.productList['supplier-id'],
                                widget.productList['price'],
                                1,
                                widget.productList['quantity'],
                                widget.productList['product-images'],
                              );
                    },
                    widthRatio: 0.5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsHeader extends StatelessWidget {
  final String label;
  const ProductDetailsHeader({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.yellow.shade900,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
