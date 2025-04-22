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
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:
          cartItems.isNotEmpty
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
                    style: const TextStyle(color: Colors.white, fontSize: 18,fontFamily: 'Helvetica Neue',),
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
                const SizedBox(height: 16),
                const MenuHeader(),
                const SizedBox(height: 16),
                _buildSearchField(),
                const SizedBox(height: 16),
                _buildCategoryButtons(),
                const SizedBox(height: 16),
                _buildMenuSection(
                  title: selectedCategory,
                  itemCount: '${filteredItems.length} items',
                  items: filteredItems,
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
        Image.asset('assets/Exclude.png', fit: BoxFit.cover),
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

  void _showMenuItemDetailsSheet(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => MenuItemDetailsSheet(
            itemName: item['title'],
            price: item['price'],
            imagePath: item['image'],
            description: item['description'],
            onOrderAdded: (quantity) {
              // Change to accept quantity parameter
              setState(() {
                cartItems.add(
                  OrderItem(
                    name: item['title'],
                    price: item['price'],
                    quantity: quantity,
                  ),
                );
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
      builder:
          (context) => ConfirmOrderSheet(
            orders: cartItems,
            onAddMoreItems: () {
              Navigator.pop(context); // Close the confirm order sheet
            },
             onOrderConfirmed: () {  // Add this new callback
        setState(() {
          cartItems.clear(); // Clear the cart
        });
        Navigator.pop(context); // Close the confirm order sheet
      },
          ),
    ).then((_) {
      // This runs when the sheet is closed
      setState(() {});
    });
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 44,
      width: 362,
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search menu name",
          hintStyle: const TextStyle(
            color: Color(0xffFAAB7A),
            fontSize: 16,
            fontFamily: 'Helvetica Neue',
          ),
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
      ),
    );
  }

  // Get filtered items based on selected category
  List<Map<String, dynamic>> get filteredItems {
    if (selectedCategory == 'All') return _allItems;
    return _allItems
        .where((item) => item['category'] == selectedCategory)
        .toList();
  }

  // Update category buttons
  Widget _buildCategoryButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => selectedCategory = 'All'),
            child: CategoryButton(
              text: "All",
              isSelected: selectedCategory == 'All',
              onTap: () => setState(() => selectedCategory = 'All'),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => selectedCategory = 'Rice Dishes'),
            child: CategoryButton(
              text: "Rice Dishes",
              isSelected: selectedCategory == 'Rice Dishes',
              onTap: () => setState(() => selectedCategory = 'Rice Dishes'),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => selectedCategory = 'Local Meals'),
            child: CategoryButton(
              text: "Local Meals",
              isSelected: selectedCategory == 'Local Meals',
              onTap: () => setState(() => selectedCategory = 'Local Meals'),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => selectedCategory = 'Snacks'),
            child: CategoryButton(
              text: "Snacks",
              isSelected: selectedCategory == 'Snacks',
              onTap: () => setState(() => selectedCategory = 'Snacks'),
            ),
          ),
        ],
      ),
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
                 fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              itemCount,
              style: const TextStyle(
                fontFamily: 'Helvetica Neue',
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
              GestureDetector(
                onTap: () => _showMenuItemDetailsSheet(context, item),
                child: MenuItem(
                  title: item['title'],
                  description: item['description'],
                  price: item['price'],
                  imagePath: item['image'],
                  onTap: () => _showMenuItemDetailsSheet(context, item),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> _allItems = [
    // Rice Dishes
    {
      'title': 'Asun Pepper Rice',
      'description': 'Basmati Rice with pieces of Asun',
      'price': 'N3,500',
      'image': 'assets/images/image 5.png',
      'category': 'Rice Dishes',
    },
    {
      'title': 'Party Jollof',
      'description': 'Flavorful rice cooked',
      'price': 'N3,500',
      'image': 'assets/images/image 6.png',
      'category': 'Rice Dishes',
    },
    {
      'title': 'Fried Rice',
      'description': 'Rice stir-fried with vegetables',
      'price': 'N3,500',
      'image': 'assets/images/image 4.png',
      'category': 'Rice Dishes',
    },
    // Local Meals
    {
      'title': 'Pounded Yam',
      'description': 'Traditional Nigerian meal',
      'price': 'N3,500',
      'image': 'assets/images/image 4.png',
      'category': 'Local Meals',
    },
    {
      'title': 'Eba',
      'description': 'Cassava flour meal',
      'price': 'N2,500',
      'image': 'assets/images/image 5.png',
      'category': 'Local Meals',
    },

    // Snacks
    {
      'title': 'Iceream',
      'description': 'Chocolate iceream',
      'price': 'N3,500',
      'image': 'assets/images/icecream.jpg',
      'category': 'Snacks',
    },
    {
      'title': 'Tea',
      'description': 'Slim tea',
      'price': 'N2,500',
      'image': 'assets/images/tea.jpg',
      'category': 'Snacks',
    },
    {
      'title': 'Biscuit',
      'description': 'Chocolate biscuit',
      'price': 'N3,500',
      'image': 'assets/images/biscuit.jpg',
      'category': 'Snacks',
    },
  ];
}
