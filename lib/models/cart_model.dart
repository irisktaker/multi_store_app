import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_class.dart';
import 'package:multi_store_app/providers/wish_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    Key? key,
    required this.product,
    required this.cart,
  }) : super(key: key);

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 120,
                child: Image.network(
                  product.imagesUrl[0],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.price.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                product.quantity == 1
                                    ? IconButton(
                                        onPressed: () {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CupertinoActionSheet(
                                              title: const Text('Remove item'),
                                              message: const Text(
                                                'Are you sure to remove this item?',
                                              ),
                                              actions: <
                                                  CupertinoActionSheetAction>[
                                                CupertinoActionSheetAction(
                                                  child: const Text(
                                                    'Move to wish list.',
                                                  ),
                                                  onPressed: () async {
                                                    context
                                                                .read<Wish>()
                                                                .getWishItems
                                                                .firstWhereOrNull(
                                                                    (element) =>
                                                                        element
                                                                            .documentId ==
                                                                        product
                                                                            .documentId) !=
                                                            null
                                                        ? context
                                                            .read<Cart>()
                                                            .removeItem(product)
                                                        : await context
                                                            .read<Wish>()
                                                            .addWishItem(
                                                              product.name,
                                                              product
                                                                  .documentId,
                                                              product
                                                                  .supplierId,
                                                              product.price,
                                                              product.quantity,
                                                              product.inStock,
                                                              product.imagesUrl,
                                                            );

                                                    context
                                                        .read<Cart>()
                                                        .removeItem(product);

                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoActionSheetAction(
                                                  child: const Text(
                                                    'Delete item.',
                                                  ),
                                                  onPressed: () {
                                                    cart.removeItem(product);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                              cancelButton: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Cancel.',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever,
                                          size: 18,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          cart.decrement(product);
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.minus,
                                          size: 18,
                                        ),
                                      ),
                                Text(
                                  product.quantity.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Acme',
                                      color: product.quantity == product.inStock
                                          ? Colors.red
                                          : Colors.grey.shade700),
                                ),
                                IconButton(
                                  onPressed: product.quantity == product.inStock
                                      ? null
                                      : () {
                                          cart.increment(product);
                                        },
                                  icon: const Icon(
                                    FontAwesomeIcons.plus,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
