import 'package:flutter/material.dart';
import 'package:swift_menu/component/completed_order_dialog.dart';
import 'package:swift_menu/model/order_item_model.dart';

class ConfirmOrderSheet extends StatefulWidget {
  final List<OrderItem> orders;
  final VoidCallback onAddMoreItems;
  final VoidCallback onOrderConfirmed;

  const ConfirmOrderSheet({
    super.key,
    required this.orders,
    required this.onAddMoreItems,
    required this.onOrderConfirmed,
  });

  @override
  State<ConfirmOrderSheet> createState() => _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState extends State<ConfirmOrderSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _seatController.dispose();
    super.dispose();
  }
  //late int quantity;

  double get subtotal {
    return widget.orders.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      ),
    );
  }Widget _buildHeader() {
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
              fontFamily: 'Helvetica Neue',
            ),
          ),
        ],
      ),
      const SizedBox(height: 4), // Reduced spacing
       const  Text(
          "Customer Details",
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Helvetica Neue',
          ),
        
      ),
      const SizedBox(height: 10),
      const Divider(thickness: 1, color: Color(0xffDCDCDC)),
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
          _buildOrderItem(item),
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
            fontFamily: 'Helvetica Neue',
          ),
        ),
        Row(
          children: [
            Container(
              height: 39,
              width: 137,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffDCDCDC), width: 1.0),
                borderRadius: BorderRadius.circular(300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add, size: 12),
                  Text(
                    'Add to this order',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Helvetica Neue',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.orders.removeAt(orderNumber - 1);
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

  Widget _buildOrderItem(OrderItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Helvetica Neue',
              ),
            ),
            Text(
              item.price,
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ],
        ),
        _buildQuantityControl(item),
      ],
    );
  }

  Widget _buildQuantityControl(OrderItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffDCDCDC), width: 1.0),
        borderRadius: BorderRadius.circular(300),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setState(() {
                if (item.quantity > 1) {
                  item.quantity--;
                }
              });
            },
          ),
          Text(
            '${item.quantity}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Helvetica Neue',
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
            color: Color(0xffF76b15), // Orange border color
            width: 1.0,
          ),
        ),
        onPressed: () {
          widget.onAddMoreItems();
        },
        child: const Text(
          "+ Add another plate",
          style: TextStyle(
            color: Color(0xffF76b15), // Orange text color
            fontSize: 16,
            fontFamily: 'Helvetica Neue',
          ),
        ),
      ),
    );
  }

  Widget _costDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sub-total(${widget.orders.length} ${widget.orders.length > 1 ? 'orders' : 'order'})',
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xff6b6b6b),
                fontFamily: 'Helvetica Neue',
              ),
            ),
            Text(
              'N${subtotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xff6b6b6b),
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica Neue',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'N${subtotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica Neue',
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
            fontFamily: 'Helvetica Neue',
          ),
        ),
        const SizedBox(height: 10),
        Divider(thickness: 1, color: const Color(0xffDCDCDC)),
      ],
    );
  }

  Widget _costTitle() {
    return Container(
      height: 44,
      width: 402,
      decoration: BoxDecoration(color: const Color(0xffF0F0F0)),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Text(
          'Cost Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Helvetica Neue',
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
                    border: Border.all(color: const Color(0xffDCDCDC)),
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
                        fontFamily: 'Helvetica Neue',
                      ),
                      errorStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Helvetica Neue',
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
                    border: Border.all(color: const Color(0xffDCDCDC)),
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
                        fontFamily: 'Helvetica Neue',
                      ),
                      errorStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Helvetica Neue',
                      ),
                    ),
                    keyboardType: TextInputType.number,
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
          backgroundColor: const Color(0xffF76b15),
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
          }
        },
        child: const Text(
          "Confirm Order",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Helvetica Neue',
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
