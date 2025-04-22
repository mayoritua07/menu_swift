import 'package:flutter/material.dart';
import 'package:swift_menu/component/completed_order_dialog.dart';
import 'package:swift_menu/model/order_item_model.dart';

class ConfirmOrderSheet extends StatefulWidget {
  final List<OrderItem> orders;
  final VoidCallback onAddMoreItems;

  const ConfirmOrderSheet({
    super.key,
    required this.orders,
    required this.onAddMoreItems,
  });

  @override
  State<ConfirmOrderSheet> createState() => _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState extends State<ConfirmOrderSheet> {
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Text("Customer Details", style: TextStyle(fontSize: 14)),
        const SizedBox(height: 10),
        Divider(thickness: 1, color: const Color(0xffDCDCDC)),
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
                    style: const TextStyle(fontSize: 12),
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
            Text(item.name, style: const TextStyle(fontSize: 16)),
            Text(item.price, style: const TextStyle(color: Colors.grey)),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300),
          ),
        ),
        onPressed: () {
          widget.onAddMoreItems();
        },
        child: const Text(
          "+ Add another plate",
          style: TextStyle(color: Color(0xffF76b15), fontSize: 16),
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
              style: TextStyle(fontSize: 15, color: const Color(0xff6b6b6b)),
            ),
            Text(
              'N${subtotal.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 15, color: const Color(0xff6b6b6b)),
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
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'N${subtotal.toStringAsFixed(2)}',
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSeatNumberControls() {
    return Row(
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
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Name',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xff808080)),
              ),
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
            child: TextField(
              controller: _seatController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Table Tag',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xff808080)),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      ],
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
          Navigator.pop(context); // Close the sheet
          showCompletedOrderDialog(context);
        },
        child: const Text(
          "Confirm Order",
          style: TextStyle(color: Colors.white, fontSize: 18),
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
