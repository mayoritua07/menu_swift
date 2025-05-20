import 'package:shared_preferences/shared_preferences.dart';

class DeviceIdManager {
  // static const String _deviceIdKey = 'device_id';

  // storing customer name
  static Future<void> storeCustomerName(String customerName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_customer_name', customerName);
  }

  // getting the name that the customer used last
  static Future<String?> getLastCustomerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_customer_name');
  }

  // stroing business id
  static Future<void> storeBusinessId(String businessId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_business_id', businessId);
  }

  // idk if we need this sha
  static Future<String?> getLastBusinessId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_business_id');
  }

  //order ID list
  static Future<void> storeCustomerOrderID(
      String businessID, int orderID) async {
    final prefs = await SharedPreferences.getInstance();
    final customerOrderIDs = prefs.getStringList(businessID) ?? [];
    customerOrderIDs.add(orderID.toString());
    await prefs.setStringList(businessID, customerOrderIDs);
  }

  static Future<List<String>?> getCustomerOrderIDs(String businessID) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(businessID);
  }
}
