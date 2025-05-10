import 'package:flutter/material.dart';
import 'package:swift_menu/component/order_notification_and_status.dart';
import 'package:swift_menu/screens/order_summary_screen.dart';

class OrderNotificationsScreen extends StatefulWidget {
  const OrderNotificationsScreen({super.key});

  @override
  State<OrderNotificationsScreen> createState() =>
      _OrderNotificationsScreenState();
}

class _OrderNotificationsScreenState extends State<OrderNotificationsScreen> {
  bool isLoading = false;
  String currentSection = "";
  String section = "";

  DateTime get orderDate {
    return DateTime(2025, 5, 1, 18);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Orders", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? CircularProgressIndicator.adaptive()
          : SingleChildScrollView(
              child: Column(
              children: [
                ...orderNotificationsDetails.map((detail) {
                  String title = detail["title"];
                  String orderID = detail["orderID"];
                  String orderStatus = detail["orderStatus"];
                  String imageUrl = detail["imageUrl"];
                  int quantity = detail['quantity'];
                  int price = detail["price"];
                  final now = DateTime.now();

                  final orderDuration = now.difference(orderDate);
                  if (now.day == orderDate.day) {
                    section = "Today";
                  } else if (orderDuration.inDays <= 7) {
                    section = "This week";
                  }
                  bool display = section == currentSection;
                  currentSection = section;

                  return Column(
                    children: [
                      if (display)
                        Text(
                          section,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return OrderSummaryScreen(
                                title: title,
                                orderID: orderID,
                                orderDateAndTime: orderDate,
                                orderStatus: orderStatus,
                                quantity: quantity,
                                price: price);
                          }));
                        },
                        child: OrderNotification(
                            imageUrl: imageUrl,
                            title: title,
                            orderID: orderID,
                            orderDateAndTime: orderDate,
                            orderStatus: orderStatus),
                      ),
                    ],
                  );
                })
              ],
            )),
    );
  }
}

final List<Map<String, dynamic>> orderNotificationsDetails = [
  {
    "title": "Jollof Rice",
    "orderID": "#MMSS001",
    "timestamp": "1985-09-25 17:45:30.00",
    "orderStatus": "pending",
    "imageUrl": "assets/images/image 5.png",
    "quantity": 1,
    "price": 3500,
  },
  {
    "title": "Jollof Rice",
    "orderID": "#MMSS002",
    "timestamp": "1985-09-25 17:45:30.00",
    "orderStatus": "processing",
    "imageUrl": "assets/images/jellof-rice.png",
    "quantity": 1,
    "price": 3500,
  },
  {
    "title": "Jollof Rice",
    "orderID": "#MMSS003",
    "timestamp": "Wednesday",
    "orderStatus": "completed",
    "imageUrl": "assets/images/image 6.png",
    "quantity": 1,
    "price": 3500,
  },
  {
    "title": "Jollof Rice",
    "orderID": "#MMSS004",
    "timestamp": "Wednesday",
    "orderStatus": "completed",
    "imageUrl": "assets/images/image 4.png",
    "quantity": 1,
    "price": 3500,
  },
  {
    "title": "Jollof Rice",
    "orderID": "#MMSS005",
    "timestamp": "Wednesday",
    "orderStatus": "completed",
    "imageUrl": "assets/images/jellof-rice.png",
    "quantity": 1,
    "price": 3500,
  },
];
