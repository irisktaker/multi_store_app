import 'package:flutter/foundation.dart';
import 'package:multi_store_app/providers/product_class.dart';

class Wish extends ChangeNotifier {
  final List<Product> _list = [];

  // getter
  List<Product> get getWishItems {
    return _list;
  }

  int get count {
    return _list.length;
  }

  Future<void> addWishItem(
    String name,
    documentId,
    supplierId,
    double price,
    int quantity,
    int inStock,
    List imagesUrl,
  ) async {
    final product = Product(
      name: name,
      documentId: documentId,
      supplierId: supplierId,
      price: price,
      quantity: quantity,
      inStock: inStock,
      imagesUrl: imagesUrl,
    );

    _list.add(product);
    notifyListeners();
  }


  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishList() {
    _list.clear();
    notifyListeners();
  }

  void removeThis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}
