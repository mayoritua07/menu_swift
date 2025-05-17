import 'package:flutter/material.dart';

class OrderStatusParameters {
  const OrderStatusParameters(
      {required this.textColor,
      required this.borderColor,
      required this.bgColor});
  final Color textColor;
  final Color borderColor;
  final Color bgColor;
}

const pendingOrderStatusParameters = OrderStatusParameters(
    textColor: Color.fromARGB(255, 107, 107, 107),
    borderColor: Color.fromARGB(255, 142, 142, 142),
    bgColor: Color.fromARGB(78, 249, 249, 249));
const inProgressOrderStatusParameters = OrderStatusParameters(
    textColor: Color.fromARGB(255, 223, 180, 0),
    borderColor: Color.fromARGB(255, 223, 180, 0),
    bgColor: Color.fromARGB(255, 255, 249, 222));
const completedOrderStatusParameters = OrderStatusParameters(
    textColor: Color.fromARGB(255, 23, 145, 80),
    borderColor: Color.fromARGB(255, 19, 116, 64),
    bgColor: Color.fromARGB(255, 233, 249, 240));
const cancelledOrderStatusParameters = OrderStatusParameters(
    textColor: Colors.red,
    borderColor: Colors.red,
    bgColor: Color.fromARGB(187, 253, 238, 238));
