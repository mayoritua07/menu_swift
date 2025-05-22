import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swift_menu/component/order_notification_and_status.dart';
import 'package:swift_menu/constants/colors.dart';
import 'package:http/http.dart' as http;

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen(
      {super.key,
      required this.title,
      required this.orderID,
      required this.orderDateAndTime,
      required this.orderStatus,
      required this.orderItems});

  final String title;
  final String orderID;
  final DateTime orderDateAndTime;
  final String orderStatus;
  final List<Map<String, dynamic>> orderItems;

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  String get displayDateAndTime {
    final dateFormat = DateFormat('E, MMMM d, y');
    final timeFormat = DateFormat.jm();
    return "${dateFormat.format(widget.orderDateAndTime)} at ${timeFormat.format(widget.orderDateAndTime)}";
  }

  void cancelOrder(context) {
    bool isLoading = false;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Confirm Cancel Order"),
            content: isLoading
                ? CircularProgressIndicator()
                : Text("Are you sure you want to cancel this deicious order?"),
            actions: isLoading
                ? null
                : [
                    TextButton(
                        onPressed: () async {
                          ///send a request to cancel the order
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final response = await http.patch(
                                Uri.parse(
                                    "http://api.order.visit.menu/api/v1/orders/${widget.orderID}/status/"),
                                headers: {
                                  'Content-Type': 'application/json',
                                },
                                body: jsonEncode({"status": "cancelled"}));
                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  padding: EdgeInsets.all(14),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  duration: Duration(seconds: 2),
                                  // backgroundColor: mainOrangeColor,
                                  content: Center(
                                    child: Text("Order has been cancelled",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              );
                            }
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Unable to cancel order. Please try again."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                          Navigator.of(context).pop();
                        },
                        child: Text("Yes")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("No"))
                  ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      key: scaffoldMessengerKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Order Summary",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 10),
              OrderStatus(orderStatus: widget.orderStatus),
              SizedBox(height: height * 0.05),
              Text(
                "Order ${widget.orderID}",
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
              if (widget.orderStatus.toLowerCase() == "pending")
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: mainOrangeColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      minimumSize: Size(double.infinity, 50)),
                  onPressed: () {
                    cancelOrder(context);
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

  List<Widget> createOrderItemRowAndTotal(
      List<Map<String, dynamic>> orderItems) {
    List<Widget> myTextWidgetList = [];
    //Update totalPrice variable
    double totalPrice = 0;
    for (final item in orderItems) {
      final String itemName = item["item_name"];
      final quantity = item["quantity"];
      final unitPrice = item["unit_price_at_order"];
      final price = double.parse(unitPrice!) * double.parse(quantity!);
      totalPrice += price;
      final myList = [
        Text(
            itemName[0].toUpperCase() +
                itemName
                    .substring(
                      1,
                    )
                    .toLowerCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(quantity,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(
          '$price',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.right,
        )
      ];

      myTextWidgetList.addAll(myList);
    }
    //Total row
    myTextWidgetList.addAll([
      Text("Total",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
      SizedBox(),
      Text(
        "₦$totalPrice",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        textAlign: TextAlign.right,
      )
    ]);

    return myTextWidgetList;
  }

  Widget displayOrderItems() {
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
        ...createOrderItemRowAndTotal(widget.orderItems),
      ],
    );
  }
}
