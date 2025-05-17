import 'package:swift_menu/model/order_item_model.dart';

class Order {
  final String? id;

  final String customerName;
  final String tableTag;
  final List<OrderItem> orderItems;
  final DateTime orderTime;
  final String status;
  final String businessId;

  Order({
    this.id,
    required this.customerName,
    required this.tableTag,
    this.orderItems = const [],
    DateTime? orderTime,
    this.status = "pending",
    required this.businessId,
  }) : orderTime = orderTime ?? DateTime.now();

  double get price {
    return orderItems.fold(0, (sum, orderItem) => sum + orderItem.totalPrice);
  }

  Map<String, dynamic> toJson() {
    // return {
    //   'customer_name': customerName,
    //   'table_tag': tableTag,
    //   'items': orderItems.map((item) => item.toJson()).toList(),
    //   'order_time': orderTime.toIso8601String(),
    //   'status': status,
    //   'business_id': businessId,
    //   'total_price': price,
    // };

    return {
      'name': customerName,
      'table_tag': tableTag,
      'items': orderItems.map((item) => item.toJson()).toList(),
      'business_id': businessId,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json, businessID) {
    return Order(
      id: json['order_id'],
      customerName: json['name'],
      tableTag: json['table_tag'],
      orderItems: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      orderTime: DateTime.parse(json['created_at']),
      status: json['status'],
      businessId: businessID,
    );
  }
}
