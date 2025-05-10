import 'package:swift_menu/model/order_item_model.dart';

class Order {
  const Order({this.orderItems = const []});

  final List<OrderItem> orderItems;

  double get price {
    return orderItems.fold(0, (sum, orderItem) => sum + orderItem.totalPrice);
  }
}
