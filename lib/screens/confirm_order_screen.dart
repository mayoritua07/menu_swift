import 'package:flutter/material.dart';
import 'package:swift_menu/component/completed_order_dialog.dart';
import 'package:swift_menu/constants/colors.dart';
import 'package:swift_menu/model/order_item_model.dart';
import 'package:swift_menu/model/order_model.dart';

class ConfirmOrderSheet extends StatefulWidget {
  final List<Order> orders;
  final VoidCallback onAddMoreItems;
  final VoidCallback onOrderConfirmed;
  final Function(int) onOrderRemoved;

  const ConfirmOrderSheet({
    super.key,
    required this.orders,
    required this.onAddMoreItems,
    required this.onOrderConfirmed,
    required this.onOrderRemoved,
  });

  @override
  State<ConfirmOrderSheet> createState() => _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState extends State<ConfirmOrderSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    _nameController.dispose();
    _seatController.dispose();
    super.dispose();
  }
  //late int quantity;

  double get total {
    // return widget.orders.fold(0, (sum, item) => sum + item.totalPrice);
    return widget.orders.fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(onTap: () => Navigator.of(context).pop()),
        bottomSheet: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSeatNumberControls(),
                  const SizedBox(height: 16),
                  _buildRestaurantInfo(),
                  const SizedBox(height: 16),
                  ..._buildOrderItems(),
                  const SizedBox(height: 16),
                  _buildAddAnotherPlateButton(),
                  const SizedBox(height: 16),
                  _costTitle(),
                  const SizedBox(height: 16),
                  _costDetails(),
                  const SizedBox(height: 16),
                  _buildConfirmOrderButton(),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Back button aligned to start (left)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // Centered title
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4), // Reduced spacing
        const Text(
          "Customer Details",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 1, color: borderGreyColor),
      ],
    );
  }

  List<Widget> _buildOrderItems() {
    return widget.orders.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return Column(
        children: [
          _buildPlateHeader(index + 1),
          const SizedBox(height: 16),
          ..._buildOrderItem(item.orderItems),
          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  Widget _buildPlateHeader(int orderNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Order $orderNumber",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Container(
              height: 39,
              width: 137,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: borderGreyColor, width: 1.0),
                  borderRadius: BorderRadius.circular(300),
                  color: borderGreyColor),
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pop({"currentOrderIndex": orderNumber - 1});
                },
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 12, weight: 15),
                    Text(
                      'Add to this order',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.orders.removeAt(orderNumber - 1);
                  // widget.onOrderRemoved(orderNumber - 1);
                });
              },
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(4000),
                ),
                child: Center(child: Icon(Icons.delete, color: Colors.red)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildOrderItem(List<OrderItem> items) {
    return items
        .map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      item.price,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                _buildQuantityControl(item),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildQuantityControl(OrderItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: borderGreyColor, width: 1.0),
        borderRadius: BorderRadius.circular(300),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: item.quantity > 1
                ? () {
                    setState(() {
                      if (item.quantity > 1) {
                        item.quantity--;
                      }
                    });
                  }
                : null,
          ),
          Text(
            '${item.quantity}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                item.quantity++;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddAnotherPlateButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300),
          ),
          side: const BorderSide(
            color: mainOrangeColor, // Orange border color
            width: 1.0,
          ),
        ),
        onPressed: () {
          widget.onAddMoreItems();
        },
        child: const Text(
          "+ Add another plate",
          style: TextStyle(
            color: mainOrangeColor, // Orange text color
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _costDetails() {
    bool isOneOrder = widget.orders.length == 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sub-total${isOneOrder ? "(1 order)" : ""}',
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xff6b6b6b),
              ),
            ),
            if (isOneOrder)
              Text(
                'N${widget.orders[0].price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15,
                  color: const Color(0xff6b6b6b),
                ),
              ),
          ],
        ),
        SizedBox(height: 5),
        if (!isOneOrder)
          ...widget.orders.asMap().entries.map((entry) {
            int index = entry.key + 1;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order $index",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'N${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xff6b6b6b),
                    ),
                  ),
                ],
              ),
            );
          }),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'N${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRestaurantInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Divider(thickness: 1, color: borderGreyColor),
      ],
    );
  }

  Widget _costTitle() {
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xffF0F0F0)),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Text(
          'Cost Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSeatNumberControls() {
    return Form(
      key:
          _formKey, // Add this to your state class: final _formKey = GlobalKey<FormState>();
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderGreyColor),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xff808080),
                      ),
                      errorStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderGreyColor),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: TextFormField(
                    controller: _seatController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Table Tag',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xff808080),
                      ),
                      errorStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    // keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: mainOrangeColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Proceed with order

            // Then call the success callback
            widget.onOrderConfirmed();

            showCompletedOrderDialog(context);
          } else {
            scaffoldMessengerKey.currentState?.clearSnackBars();
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                  padding: EdgeInsets.all(14),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  duration: Duration(seconds: 3),
                  // backgroundColor: mainOrangeColor,
                  content: Center(
                    child: Text("Fill in the required fields.",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white)),
                  )),
            );
          }
        },
        child: const Text(
          "Confirm Order",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void showCompletedOrderDialog(context) {
    showDialog(
      context: context,
      builder: (ctx) => const CompletedOrderDialog(),
    );
  }
}
