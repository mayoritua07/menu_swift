class OrderItem {
  final String name;
  final String id;
  final String price;
  final String imageUrl;
  int quantity;

  OrderItem({
    required this.name,
    required this.id,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  double get totalPrice {
    final numericPrice =
        double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    return numericPrice * quantity;
  }

  Map<String, dynamic> toJson() {
    // return {
    //   'name': name,
    //   'id': id,
    //   'price': price,
    //   'quantity': quantity,
    // };

    return {
      'item_name': name,
      'item_id': id,
      'price': double.parse(price),
      'quantity': quantity,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        name: json['name'] ?? json['item_name'] ?? '',
        id: json['id'] ?? json['item_id'] ?? '',
        price: json['price'] ?? json['unit_price_at_order']?.toString() ?? '0',
        quantity: json['quantity'] is int
            ? json['quantity']
            : int.tryParse(json['quantity'] ?? '1') ?? 1,
        imageUrl: json['img_url']);
  }
}
