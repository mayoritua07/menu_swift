import 'package:flutter/material.dart';

class MenuItemDetailsSheet extends StatefulWidget {
  final String itemName;
  final String price;
  final String imagePath;
  final String description;
  final Function(int) onOrderAdded;

  const MenuItemDetailsSheet(
      {super.key,
      required this.itemName,
      required this.price,
      required this.imagePath,
      required this.description,
      required this.onOrderAdded});

  @override
  State<MenuItemDetailsSheet> createState() => _MenuItemDetailsSheetState();
}

class _MenuItemDetailsSheetState extends State<MenuItemDetailsSheet> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDragHandle(),
            const SizedBox(height: 10),
            _buildItemImage(),
            const SizedBox(height: 10),
            _buildItemInfo(),
            const SizedBox(height: 20),
            _buildOrderControls(),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildItemImage() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            widget.imagePath,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            top: 8,
            right: 8,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(800),
                  color: Colors.white),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )),
      ],
    );
  }

  Widget _buildItemInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.itemName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          ' ${widget.description}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 5),
        Text('Price: ${widget.price}',
            style: const TextStyle(
              fontSize: 16,
            )),
      ],
    );
  }

  Widget _buildOrderControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuantityControl(),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffF76b15),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Close the current bottom sheet
              widget.onOrderAdded(_quantity);
            },
            child: const Text(
              'Add to Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControl() {
    return SizedBox(
      width: 110,
      height: 46,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffFAAB7A)),
          borderRadius: BorderRadius.circular(200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.remove, size: 14),
              onPressed: () {
                if (_quantity > 1) {
                  setState(() => _quantity--);
                }
              },
            ),
            Text(
              '$_quantity',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.add, size: 14),
              onPressed: () {
                setState(() => _quantity++);
              },
            ),
          ],
        ),
      ),
    );
  }
}
