import 'package:flutter/foundation.dart';
import 'package:multi_store_app/providers/product_class.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];

  // getter
  List<Product> get getCartItems {
    return _list;
  }

  int get count {
    return _list.length;
  }

  double get totalPrice {
    var total = 0.0;
    for (var item in _list) {
      total += item.price * item.quantity;
    }

    return total;
  }

  void addItem(
    String name,
    documentId,
    supplierId,
    double price,
    int quantity,
    int inStock,
    List imagesUrl,
  ) {
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

  void increment(Product product) {
    product.increase();
    notifyListeners();
  }

  void decrement(Product product) {
    product.decrease();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearList() {
    _list.clear();
    notifyListeners();
  }
}
