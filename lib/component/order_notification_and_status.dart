import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swift_menu/model/order_status_parameters.dart';

final orderStatusParameters = {
  "pending": pendingOrderStatusParameters,
  "processing": processingOrderStatusParameters,
  "completed": completedOrderStatusParameters
};

class OrderStatus extends StatelessWidget {
  const OrderStatus({super.key, required this.orderStatus});

  final String orderStatus;

  @override
  Widget build(BuildContext context) {
    final OrderStatusParameters? params =
        orderStatusParameters[orderStatus.toLowerCase()];
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 3,
      ),
      width: 130,
      decoration: BoxDecoration(
          color: params?.bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: params?.borderColor ?? Colors.grey)),
      child: Text(
        "${orderStatus[0].toUpperCase()}${orderStatus.substring(1).toLowerCase()}",
        style: TextStyle(
            color: params?.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class OrderNotification extends StatelessWidget {
  const OrderNotification(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.orderID,
      required this.orderDateAndTime,
      required this.orderStatus});

  final String imageUrl;
  final String title;
  final String orderID;
  final DateTime orderDateAndTime;
  final String orderStatus;

  String get displayOrderTime {
    final orderDuration = DateTime.now().difference(orderDateAndTime);
    if (orderDuration.inDays < 12) {
      if (orderDuration.inDays > 0) {
        return "${orderDuration.inDays}d ago";
      } else if (orderDuration.inHours > 0) {
        return "${orderDuration.inHours}h ago";
      } else if (orderDuration.inMinutes > 0) {
        return "${orderDuration.inHours}m ago";
      } else if (orderDuration.inSeconds > 0) {
        return "${orderDuration.inSeconds}m ago";
      }
    }
    return DateFormat.yMd().format(orderDateAndTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ClipOval(
              child: Image.asset(
                width: 70,
                height: 70,
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            subtitle: Text("Order $orderID"),
            trailing: Text(displayOrderTime),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 100),
            child: OrderStatus(orderStatus: orderStatus),
          ),
        ],
      ),
    );
  }
}
