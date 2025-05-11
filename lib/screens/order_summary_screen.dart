import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swift_menu/component/order_notification_and_status.dart';
import 'package:swift_menu/constants/colors.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen(
      {super.key,
      required this.title,
      required this.orderID,
      required this.orderDateAndTime,
      required this.orderStatus,
      required this.quantity,
      required this.price});

  final String title;
  final String orderID;
  final DateTime orderDateAndTime;
  final String orderStatus;
  final int quantity;
  final int price;

  String get displayDateAndTime {
    final dateFormat = DateFormat('E, MMMM d, y');
    final timeFormat = DateFormat.jm();
    return "${dateFormat.format(orderDateAndTime)} at ${timeFormat.format(orderDateAndTime)}";
  }

  void cancelOrder() {}

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Order Summary",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 10),
              OrderStatus(orderStatus: orderStatus),
              SizedBox(height: height * 0.05),
              Text(
                "Order $orderID",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.02),
              Text(
                displayDateAndTime,
                style: TextStyle(),
              ),
              SizedBox(height: height * 0.02),
              Divider(color: borderGreyColor, thickness: 1),
              SizedBox(height: 10),
              Text("Order Details"),
              SizedBox(height: height * 0.03),
              displayOrderItems(),
              SizedBox(height: height * 0.08),
              if (orderStatus.toLowerCase() == "pending")
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: mainOrangeColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      minimumSize: Size(double.infinity, 50)),
                  onPressed: () {
                    cancelOrder();
                  },
                  child: Text("Cancel Order",
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayOrderItems() {
    int totalPrice = price * quantity;

    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      // crossAxisSpacing: 1,
      childAspectRatio: 4,
      children: [
        Text("Item", style: TextStyle(color: greyTextColor, fontSize: 15)),
        Text("Qty",
            textAlign: TextAlign.center,
            style: TextStyle(color: greyTextColor, fontSize: 15)),
        Text(
          "Price(₦)",
          textAlign: TextAlign.right,
        ),
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text('$quantity',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(
          '₦$price',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.right,
        ),
        Text("Total",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
        SizedBox(),
        Text(
          "₦$totalPrice",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          textAlign: TextAlign.right,
        )
      ],
    );
  }
}
