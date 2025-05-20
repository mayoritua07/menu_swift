import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swift_menu/model/order_item_model.dart';
import 'package:swift_menu/model/order_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrderService {
  static String get baseUrl =>
      dotenv.env['ORDER_URL'] ?? 'https://api.visit.menu/api/v1/orders';

  //method to submit order
  static Future<int?> submitOrder(Order order) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(order.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        //getting order id
        final responseData = jsonDecode(response.body);
        return responseData['order_id']; // Return the order ID
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // validate order
  static Future<List> validateOrder(Order order) async {
    try {
      final data = order.orderItems.map(
        (OrderItem element) {
          return {"menu_id": element.id, 'quantity': element.quantity};
        },
      ).toList();
      final response = await http.post(
        Uri.parse("http://api.menu.visit.menu/api/v1/menus/validate-order"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"items": data}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //getting order id
        final responseData = jsonDecode(response.body) as List<dynamic>;
        for (final responseItem in responseData) {
          if (responseItem['available'] as bool) {
          } else {
            return [false, responseItem["name"]];
          }
        }
        return [true, ""];
        // Return the order ID
      }
    } catch (e) {
      return [false, ""];
    }
    return [false, ""];
  }

  // Getting orders for business using the customer's name
  static Future<List<Order>> getOrdersForCustomer(
      String businessId, String customerName,
      {int limit = 12}) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl?business_id=$businessId&customer_name=$customerName&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Order.fromJson(json, businessId)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Get orders for a business by customer name within a time range
  static Future<List<Order>> getOrdersForCustomerInTimeRange(
      String businessId, String customerName,
      {required DateTime startTime}) async {
    try {
      final startTimeStr = startTime.toIso8601String();

      final response = await http.get(
        Uri.parse(
            '$baseUrl?business_id=$businessId&customer_name=$customerName&start_time=$startTimeStr'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final orders =
            data.map((json) => Order.fromJson(json, businessId)).toList();

        // filterin gthe orders to only include orders after the specified time
        return orders
            .where((order) => order.orderTime.isAfter(startTime))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Get a specific order by id
  static Future<Order?> getOrderById(String orderId, String businessID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$orderId'),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        return Order.fromJson(data, businessID);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

// get orders then filter
  static Future<List<Order>> getFilteredOrders(
      String businessId, List<String> customerOrderIDs) async {
    List<Order> filteredOrderList = [];
    Map<String, String> params = {"business_id": businessId};
    try {
      final response = await http.get(
        Uri.parse(baseUrl).replace(queryParameters: params),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Order> orderList =
            data.map((json) => Order.fromJson(json, businessId)).toList();

        filteredOrderList = orderList.where(
          (order) {
            if (customerOrderIDs.contains(order.id.toString()) &&
                DateTime.now().difference(order.orderTime).inHours < 13) {
              return true;
            }
            return false;
          },
        ).toList();
        return filteredOrderList;
      } else {
        return filteredOrderList;
      }
    } catch (e) {
      return [];
    }
  }
}
