import 'package:flutter/material.dart';
import 'package:swift_menu/component/order_notification_and_status.dart';
import 'package:swift_menu/screens/order_summary_screen.dart';

class OrderNotificationsScreen extends StatefulWidget {
  const OrderNotificationsScreen({super.key, required this.businessID});

  final String businessID;

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
    return DateTime.parse(timestamp);
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
                    String title = detail["items"][0]["item_name"];
                    String orderID = detail["order_id"];
                    String orderStatus = detail["status"];
                    String imageUrl = detail["items"][0]["img_url"];
                    // int quantity = detail['quantity'];
                    DateTime orderDateAndTime =
                        getOrderDateAndTime(detail["created_at"]);

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
                                  orderItems: detail["items"]);
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
    "order_id": "b06b6880-9707-456f-8fcf-3373b7d2857e",
    "name": "Pascal",
    "table_tag": "56",
    "status": "in progress",
    "total_price": "1200.00",
    "created_at": "2025-05-14T22:27:07.256495Z",
    "items": [
      {
        "item_id": "408745dc-0c2b-402b-96a2-91ddfb5f4e28",
        "item_name": "Bean and Plantain",
        "quantity": 1,
        "unit_price_at_order": "1200.00",
        "img_url":
            "https://menucard-menu.s3.amazonaws.com/20250514220346_e9370df0c743465289338b711d3a5303_oil%20beans.jpeg"
      }
    ]
  }
];
