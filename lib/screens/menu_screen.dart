import 'package:flutter/material.dart';
import 'package:swift_menu/component/category_button.dart';
import 'package:swift_menu/component/menu_header_card.dart';
import 'package:swift_menu/component/menu_item.dart';
import 'package:swift_menu/model/order_item_model.dart';
import 'package:swift_menu/screens/confirm_order_screen.dart';
import 'package:swift_menu/screens/menu_item_details_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  List<OrderItem> cartItems = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF76b15),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  _showConfirmOrderSheet(context);
                },
                child: Text(
                  'Proceed to Order ${cartItems.length} ${cartItems.length > 1 ? 'items' : 'item'}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          : null,
           body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerIcons(),
                const SizedBox(height: 16,),
                const MenuHeader(),
                const SizedBox(height: 16),
                _buildSearchField(),
                const SizedBox(height: 16),
                _buildCategoryButtons(),
                const SizedBox(height: 16),
                _buildMenuSection(
                  title: 'Rice Dishes',
                  itemCount: '3 items',
                  items: _riceDishes,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _headerIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/Exclude.png',fit: BoxFit.cover,),
        Container(
          width: 32,
          height: 32,
          //padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffDCDCDC), width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.notifications, size: 24, color: Color(0xffF76B15)),
        ),
      ],
    );
  }

 void _showMenuItemDetailsSheet(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MenuItemDetailsSheet(
        itemName: item['title'],
        price: item['price'],
        imagePath: item['image'],
        description: item['description'],
        onOrderAdded: (quantity) {  // Change to accept quantity parameter
         setState(() {
            cartItems.add(OrderItem(
              name: item['title'],
              price: item['price'],
              quantity: quantity,
            ));
          });
        },
      ),
    );
  }

void _showConfirmOrderSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>  ConfirmOrderSheet(
        orders: cartItems,
        onAddMoreItems: () {
          Navigator.pop(context); // Close the confirm order sheet
        },
      ),
    ).then((_) {
      // This runs when the sheet is closed
      setState(() {});
    });
}
  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search menu",
        hintStyle: const TextStyle(color: Color(0xffFAAB7A)),
        prefixIcon: const Icon(Icons.search, color: Color(0xffFAAB7A)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xffFAAB7A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xffFAAB7A), width: 2.0),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        CategoryButton(text: "All", isSelected: true),
        CategoryButton(text: "Rice Dishes"),
        CategoryButton(text: "Local Meals"),
      ],
    );
  }

  Widget _buildMenuSection({
    required String title,
    required String itemCount,
    required List<Map<String, dynamic>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              itemCount,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Column(
            children: [
              MenuItem(
                title: item['title'],
                description: item['description'],
                price: item['price'],
                imagePath: item['image'],
                onTap: () => _showMenuItemDetailsSheet(context, item),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> _riceDishes = [
    {
      'title': 'Asun Pepper Rice',
      'description': 'Basmati Rice with pieces of Asun',
      'price': 'N3,500',
      'image': 'assets/images/image 5.png',
    },
    {
      'title': 'Party Jollof',
      'description': 'Flavorful rice cooked',
      'price': 'N3,500',
      'image': 'assets/images/image 6.png',
    },
    {
      'title': 'Fried Rice',
      'description': 'Rice stir-fried with vegetables',
      'price': 'N3,500',
      'image': 'assets/images/image 4.png',
    },
  ];
}
