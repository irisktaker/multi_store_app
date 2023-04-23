class Product {
  String name, documentId, supplierId;
  double price;
  int quantity = 1;
  int inStock = 100;
  List imagesUrl;

  Product({
    required this.name,
    required this.documentId,
    required this.supplierId,
    required this.price,
    required this.quantity,
    required this.inStock,
    required this.imagesUrl,
  });

  void increase() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }
}
