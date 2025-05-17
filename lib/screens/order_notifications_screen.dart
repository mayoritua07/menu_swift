import 'package:flutter/material.dart';
import 'package:swift_menu/component/order_notification_and_status.dart';
import 'package:swift_menu/screens/order_summary_screen.dart';
import 'package:swift_menu/services/order_service.dart';
import 'package:swift_menu/utils/device_id_manager.dart';
import 'package:swift_menu/model/order_model.dart';

class OrderNotificationsScreen extends StatefulWidget {
  const OrderNotificationsScreen({super.key, required this.businessID});

  final String businessID;

  @override
  State<OrderNotificationsScreen> createState() =>
      _OrderNotificationsScreenState();
}

class _OrderNotificationsScreenState extends State<OrderNotificationsScreen> {
  bool isLoading = true;
  final now = DateTime.now();
  late DateTime todayDate;
  late DateTime thisWeekSunday;
  List<Order> orders = [];

  DateTime getOrderDateAndTime(String timestamp) {
    return DateTime.parse(timestamp);
  }

  @override
  void initState() {
    todayDate = DateTime(now.year, now.month, now.day);
    thisWeekSunday =
        todayDate.subtract(Duration(days: todayDate.weekday + 1 % 7));
    super.initState();

    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    // setState(() {
    //   isLoading = true;
    // });

    try {
      // Get the last used customer name
      // final customerName = await DeviceIdManager.getLastCustomerName();

      final customerOrderIDs =
          await DeviceIdManager.getCustomerOrderIDs(widget.businessID);

      if (customerOrderIDs != null) {
        // final twelveHoursAgo = DateTime.now().subtract(Duration(hours: 12));

        // orders from the last 12 hours
        final fetchedOrders =
            //     await OrderService.getOrdersForCustomerInTimeRange(
            //   widget.businessID,
            //   customerName,
            //   startTime: twelveHoursAgo,
            // );

            await OrderService.getFilteredOrders(
          widget.businessID,
          customerOrderIDs,
        );

        setState(() {
          orders = fetchedOrders;
          isLoading = false;
        });
      } else {
        setState(() {
          orders = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchOrders,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
              child: Column(
                children: orders.isEmpty
                    ? [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3),
                        Center(
                          child: Column(
                            children: [
                              Icon(Icons.receipt_long_outlined,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No orders found',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Orders from the last 12 hours will appear here',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ]
                    : orders.map((order) {
                        String title = order.orderItems.isNotEmpty
                            ? order.orderItems.first.name
                            : 'Order ${order.id ?? ''}';
                        String orderID = order.id ?? '';
                        String orderStatus = order.status;
                        // String imageUrl = order.orderItems.isNotEmpty
                        //     ? 'https://menucard-menu.s3.amazonaws.com/placeholder-food.jpg' // Placeholder image
                        //     : 'https://menucard-menu.s3.amazonaws.com/placeholder-food.jpg';
                        DateTime orderDateAndTime = order.orderTime;
                        String imageUrl = order.orderItems[0].imageUrl;

                        // Determine section
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
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
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
                                      orderItems: order.orderItems
                                          .map((item) => {
                                                'item_name': item.name,
                                                'quantity':
                                                    item.quantity.toString(),
                                                'unit_price_at_order':
                                                    item.price.replaceAll(
                                                        RegExp(r'[^0-9.]'), ''),
                                              })
                                          .toList());
                                })).then((_) => _fetchOrders());
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
                      }).toList(),
              ),
            )),
    );
  }
}
