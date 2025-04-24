class OrderItem {
  final String name;
  final String price;
  int quantity;

  OrderItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  double get totalPrice {
    final numericPrice = double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    return numericPrice * quantity;
  }
}