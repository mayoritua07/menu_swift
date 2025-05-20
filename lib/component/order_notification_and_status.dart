import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swift_menu/component/shimmer_image.dart';
import 'package:swift_menu/model/order_status_parameters.dart';

final orderStatusParameters = {
  "pending": pendingOrderStatusParameters,
  "in progress": inProgressOrderStatusParameters,
  "completed": completedOrderStatusParameters,
  "cancelled": cancelledOrderStatusParameters
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

  final String? imageUrl;
  final String title;
  final String orderID;
  final DateTime orderDateAndTime;
  final String orderStatus;

  String get displayOrderTime {
    final now = DateTime.now();
    final orderDate = DateTime(
        orderDateAndTime.year, orderDateAndTime.month, orderDateAndTime.day);
    final todayDate = DateTime(now.year, now.month, now.day);

    final orderDuration = now.difference(orderDateAndTime);

    final days = todayDate.difference(orderDate).inDays;

    if (days < 12) {
      if (days > 0) {
        return "${days}d ago";
      } else if (orderDuration.inHours > 0) {
        return "${orderDuration.inHours}h ago";
      } else if (orderDuration.inMinutes > 0) {
        return "${orderDuration.inMinutes}m ago";
      } else if (orderDuration.inSeconds > 0) {
        return "${orderDuration.inSeconds}s ago";
      }
    }
    return DateFormat.yMd().format(orderDateAndTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 231, 228, 228),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                child: imageUrl == null
                    ? null
                    : ShimmerImage(
                        imageUrl!,
                        fit: BoxFit.cover,
                      )),
            title: Text(
              title[0].toUpperCase() +
                  title
                      .substring(
                        1,
                      )
                      .toLowerCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            subtitle: Text("Order $orderID"),
            trailing: Text(displayOrderTime),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 90),
            child: OrderStatus(orderStatus: orderStatus),
          ),
        ],
      ),
    );
  }
}
