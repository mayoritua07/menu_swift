import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swift_menu/model/order_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrderService {
  static String get baseUrl =>
      dotenv.env['ORDER_URL'] ?? 'https://api.visit.menu/api/v1/orders';

  //method to submit order
  static Future<String?> submitOrder(Order order) async {
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
        return responseData['id']; // Return the order ID
      }
      return null;
    } catch (e) {
      print('Error submitting order: $e');
      return null;
    }
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
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting orders for customer: $e');
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
        final orders = data.map((json) => Order.fromJson(json)).toList();

        // filterin gthe orders to only include orders after the specified time
        return orders
            .where((order) => order.orderTime.isAfter(startTime))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting orders for customer in time range: $e');
      return [];
    }
  }

  // Get a specific order by id
  static Future<Order?> getOrderById(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$orderId'),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        return Order.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting order by ID: $e');
      return null;
    }
  }
}
