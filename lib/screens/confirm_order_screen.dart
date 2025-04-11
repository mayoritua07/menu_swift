import 'package:flutter/material.dart';
import 'package:swift_menu/widgets/completed_order_dialog.dart';


class ConfirmOrderSheet extends StatefulWidget {
  final String itemName;
  final String price;
  final int initialQuantity;

  const ConfirmOrderSheet({
    super.key,
    required this.itemName,
    required this.price,
    this.initialQuantity = 1,
  });

  @override
  State<ConfirmOrderSheet> createState() => _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState extends State<ConfirmOrderSheet> {
  late int quantity;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _seatController.dispose();
    super.dispose();
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
            _buildRestaurantInfo(),
            const SizedBox(height: 16),
            _buildPlateHeader(),
            const SizedBox(height: 16),
            _buildOrderItem(),
            const SizedBox(height: 16),
            _buildAddAnotherPlateButton(),
            const SizedBox(height: 16),
            _buildSeatNumberControls(),
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
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          "Order Summary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRestaurantInfo() {
    return Row(
      children: [
        Text(
          'SD',
          style: TextStyle(color: const Color(0xff3c00c6), fontSize: 14),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Swoop Dining'),
            Text('1 item', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildPlateHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Plate"),
        Row(
          children: [
            Icon(Icons.copy, color: Colors.grey),
            SizedBox(width: 10),
            Icon(Icons.delete, color: Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.itemName, style: const TextStyle(fontSize: 16)),
            Text(widget.price, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        _buildQuantityControl(),
      ],
    );
  }

  Widget _buildQuantityControl() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffFAAB7A),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(300),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _decreaseQuantity,
          ),
          Text('$quantity', style: const TextStyle(fontSize: 16)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _increaseQuantity,
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
          backgroundColor: Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300),
          ),
        ),
        onPressed: () {},
        child: const Text(
          "+ Add another plate",
          style: TextStyle(color: Colors.black),
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
              border: Border.all(color: const Color(0xffF76b15)),
              borderRadius: BorderRadius.circular(200),
            ),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Name',
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
              border: Border.all(color: const Color(0xffF76b15)),
              borderRadius: BorderRadius.circular(200),
            ),
            child: TextField(
              controller: _seatController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Seat number',
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

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void showCompletedOrderDialog(context) {
    showDialog(
      context: context,
      builder: (ctx) => const CompletedOrderDialog(),
    );
  }
}