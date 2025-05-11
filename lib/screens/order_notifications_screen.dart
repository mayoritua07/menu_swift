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
  final now = DateTime.now();
  late DateTime todayDate;
  late DateTime thisWeekSunday;

  DateTime getOrderDateAndTime(String timestamp) {
    return DateTime(2025, 5, 1, 18);
  }

  @override
  void initState() {
    todayDate = DateTime(now.year, now.month, now.day);
    thisWeekSunday =
        todayDate.subtract(Duration(days: todayDate.weekday + 1 % 7));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currentSection = "";
    String section = "";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text("Orders",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
      ),
      body: isLoading
          ? CircularProgressIndicator.adaptive()
          : SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
              child: Column(
                children: [
                  ...orderNotificationsDetails.map((detail) {
                    String title = detail["title"];
                    String orderID = detail["orderID"];
                    String orderStatus = detail["orderStatus"];
                    String imageUrl = detail["imageUrl"];
                    int quantity = detail['quantity'];
                    int price = detail["price"];
                    DateTime orderDateAndTime =
                        getOrderDateAndTime(detail["timestamp"]);

                    // final orderDuration = now.difference(orderDateAndTime);

                    if (now.day == orderDateAndTime.day) {
                      section = "Today";
                    } else if (!orderDateAndTime
                        .difference(thisWeekSunday)
                        .isNegative) {
                      section = "This week";
                    } else {
                      section = "Older";
                    }
                    bool display = section != currentSection;
                    currentSection = section;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (display)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, top: 8, bottom: 8),
                            child: Text(
                              section,
                              // textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (ctx) {
                              return OrderSummaryScreen(
                                  title: title,
                                  orderID: orderID,
                                  orderDateAndTime: orderDateAndTime,
                                  orderStatus: orderStatus,
                                  quantity: quantity,
                                  price: price);
                            }));
                          },
                          child: OrderNotification(
                              imageUrl: imageUrl,
                              title: title,
                              orderID: orderID,
                              orderDateAndTime: orderDateAndTime,
                              orderStatus: orderStatus),
                        ),
                      ],
                    );
                  })
                ],
              ),
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
