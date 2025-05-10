import 'package:flutter/material.dart';
import 'package:swift_menu/component/category_button.dart';
import 'package:swift_menu/component/menu_header_card.dart';
import 'package:swift_menu/component/menu_item.dart';
import 'package:swift_menu/constants/colors.dart';
import 'package:swift_menu/model/order_item_model.dart';
import 'package:swift_menu/model/order_model.dart';
import 'package:swift_menu/screens/confirm_order_screen.dart';
import 'package:swift_menu/screens/menu_item_details_screen.dart';
import 'package:swift_menu/screens/order_notifications_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int? currentOrderIndex;
  String selectedCategory = 'All';
  List<Map<String, dynamic>> filteredItemsForDisplay = [];
  List<Order> cartItems = [];
  List<String> categories = [
    'All',
    'Rice Dishes',
    'Local Meals',
    'Snacks',
  ];
  TextEditingController searchFieldController = TextEditingController();

  @override
  void initState() {
    filteredItemsForDisplay = filteredItems;
    super.initState();
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainOrangeColor,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
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
                  itemCount: '${filteredItemsForDisplay.length} items',
                  items: filteredItemsForDisplay,
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
        Image.asset(
          'assets/images/Exclude.png',
          fit: BoxFit.cover,
          color: purpleColor,
        ),
        Container(
            width: 32,
            height: 32,
            //padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: borderGreyColor, width: 1.0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return OrderNotificationsScreen();
                  }));
                },
                child: Icon(Icons.notifications,
                    size: 24, color: mainOrangeColor))),
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
      builder: (context) => MenuItemDetailsSheet(
        itemName: item['title'],
        price: item['price'],
        imagePath: item['image'],
        description: item['description'],
        onOrderAdded: (quantity) {
          // Change to accept quantity parameter
          setState(() {
            final OrderItem newOrderItem = OrderItem(
                name: item['title'], price: item['price'], quantity: quantity);
            if (currentOrderIndex == null) {
              cartItems.add(
                Order(
                  orderItems: [newOrderItem],
                ),
              );
            } else {
              cartItems[currentOrderIndex!].orderItems.add(newOrderItem);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    padding: EdgeInsets.all(14),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    duration: Duration(
                      seconds: 2,
                    ),
                    content: Center(
                      child: Text(
                          "Order ${currentOrderIndex! + 1} has been updated.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white)),
                    )),
              );
            }
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
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(onTap: () => Navigator.of(context).pop()),
        bottomSheet: ConfirmOrderSheet(
          orders: cartItems,
          onAddMoreItems: () {
            Navigator.pop(context); // Close the confirm order sheet
          },
          onOrderConfirmed: () {
            // Add this new callback
            setState(() {
              cartItems.clear(); // Clear the cart
            });
            Navigator.pop(context); // Close the confirm order sheet
          },
          onOrderRemoved: (int index) {
            setState(() {
              cartItems.removeAt(index);
            });
          },
        ),
      ),
    ).then((value) {
      // This runs when the sheet is closed\

      setState(() {
        if (value == null) {
          currentOrderIndex = null;
        } else {
          currentOrderIndex =
              (value as Map<String, dynamic>)["currentOrderIndex"];
        }
      });
    });
  }

  Widget _buildSearchField() {
    return SizedBox(
      // height: 44,
      width: double.infinity,
      child: TextField(
        controller: searchFieldController,
        decoration: InputDecoration(
          hintText: "Search menu name",
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Color(0xffFAAB7A),
              ),
          prefixIcon: const Icon(Icons.search, color: borderOrangeColor),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: borderOrangeColor)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: borderOrangeColor, width: 2.0),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        onChanged: (value) {
          setState(() {
            filteredItemsForDisplay = searchFilter(filteredItems);
          });
        },
      ),
    );
  }

  List<Map<String, dynamic>> searchFilter(
      List<Map<String, dynamic>> filteredItems) {
    // Pass in a list of map of menu items and it filters it based on the search and returns the valid ones as a list of map entries.
    String searchText = searchFieldController.text;
    if (searchText.isEmpty) {
      return filteredItems;
    }
    return filteredItems
        .where((item) => (item["title"] as String)
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
  }

  // Get filtered items based on selected category
  List<Map<String, dynamic>> get filteredItems {
    // Returns all items under a particular category
    if (selectedCategory == 'All') {
      return _allItems;
    } else {
      return _allItems
          .where((item) => item['category'] == selectedCategory)
          .toList();
    }
  }

  // Update category buttons
  Widget _buildCategoryButtons() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: categories.map((e) {
          return GestureDetector(
            onTap: () => setState(() {
              selectedCategory = e;
              filteredItemsForDisplay = searchFilter(filteredItems);
            }),
            child: CategoryButton(
              text: e,
              isSelected: selectedCategory == e,
              onTap: () => setState(() {
                selectedCategory = e;
                filteredItemsForDisplay = searchFilter(filteredItems);
              }),
            ),
          );
        }).toList()
            // [
            //   GestureDetector(
            //     onTap: () => setState(() => selectedCategory = 'All'),
            //     child: CategoryButton(
            //       text: "All",
            //       isSelected: selectedCategory == 'All',
            //       onTap: () => setState(() => selectedCategory = 'All'),
            //     ),
            //   ),
            //   const SizedBox(width: 12),
            //   GestureDetector(
            //     onTap: () => setState(() => selectedCategory = 'Rice Dishes'),
            //     child: CategoryButton(
            //       text: "Rice Dishes",
            //       isSelected: selectedCategory == 'Rice Dishes',
            //       onTap: () => setState(() => selectedCategory = 'Rice Dishes'),
            //     ),
            //   ),
            //   const SizedBox(width: 12),
            //   GestureDetector(
            //     onTap: () => setState(() => selectedCategory = 'Local Meals'),
            //     child: CategoryButton(
            //       text: "Local Meals",
            //       isSelected: selectedCategory == 'Local Meals',
            //       onTap: () => setState(() => selectedCategory = 'Local Meals'),
            //     ),
            //   ),
            //   const SizedBox(width: 12),
            //   GestureDetector(
            //     onTap: () => setState(() => selectedCategory = 'Snacks'),
            //     child: CategoryButton(
            //       text: "Snacks",
            //       isSelected: selectedCategory == 'Snacks',
            //       onTap: () => setState(() => selectedCategory = 'Snacks'),
            //     ),
            //   ),
            // ],
            ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required String itemCount,
    required List<Map<String, dynamic>> items,
  }) {
    double height = MediaQuery.sizeOf(context).height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
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
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: items.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.1),
                    child: Text(
                      "No Meals found!",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              : ListView.builder(
                  key: ValueKey(filteredItemsForDisplay),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredItemsForDisplay.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    final item = filteredItemsForDisplay[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => _showMenuItemDetailsSheet(context, item),
                          child: MenuItem(
                            title: item['title'],
                            description: item['description'],
                            price: item['price'],
                            imagePath: item['image'],
                            onTap: () =>
                                _showMenuItemDetailsSheet(context, item),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
        ),
        //Changing the items to a list view to animate it when filters are changed
        // ...items.map(
        //   (item) => Column(
        //     children: [
        //       GestureDetector(
        //         onTap: () => _showMenuItemDetailsSheet(context, item),
        //         child: MenuItem(
        //           title: item['title'],
        //           description: item['description'],
        //           price: item['price'],
        //           imagePath: item['image'],
        //           onTap: () => _showMenuItemDetailsSheet(context, item),
        //         ),
        //       ),
        //       const SizedBox(height: 10),
        //     ],
        //   ),
        // ),
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
      'image': 'assets/images/icecream.png',
      'category': 'Snacks',
    },
    {
      'title': 'Tea',
      'description': 'Slim tea',
      'price': 'N2,500',
      'image': 'assets/images/tea.png',
      'category': 'Snacks',
    },
    {
      'title': 'Biscuit',
      'description': 'Chocolate biscuit',
      'price': 'N3,500',
      'image': 'assets/images/biscuit.png',
      'category': 'Snacks',
    },
  ];
}
