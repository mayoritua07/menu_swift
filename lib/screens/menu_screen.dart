import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:swift_menu/component/category_button.dart';
import 'package:swift_menu/component/menu_header_card.dart';
import 'package:swift_menu/component/menu_item.dart';
import 'package:swift_menu/component/shimmer_image.dart';
import 'package:swift_menu/constants/colors.dart';
import 'package:swift_menu/model/order_item_model.dart';
import 'package:swift_menu/model/order_model.dart';
import 'package:swift_menu/screens/confirm_order_screen.dart';
import 'package:swift_menu/screens/menu_item_details_screen.dart';
import 'package:swift_menu/model/menu_item_model.dart';
import 'package:swift_menu/screens/order_notifications_screen.dart';
import 'package:swift_menu/utils/device_id_manager.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen(
      {super.key,
      required this.businessID,
      required this.businessName,
      required this.logoUrl});

  final String businessID;
  final String businessName;
  final String logoUrl;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int? currentOrderIndex;
  String selectedCategory = 'All';
  List<Map<String, dynamic>> _allItems = [];
  List<Map<String, dynamic>> filteredItemsForDisplay = [];
  List<Order> cartItems = [];
  List<String> categories = [
    'All',
    'Rice Dishes',
    'Local Meals',
    'Snacks',
  ];
  TextEditingController searchFieldController = TextEditingController();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    // filteredItemsForDisplay = filteredItems;
    super.initState();
    fetchMenuItems();

    //storing the businessID
    DeviceIdManager.storeBusinessId(widget.businessID);
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  void submitOrder(List<Order> cartItems) async {
    {
      // "items": [
      //   {
      //     "menu_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      //     "quantity": 1
      //   }
      // ]
    }
    final List<Map<String, dynamic>> parameters = [];
    cartItems.map((item) {
      item.orderItems.map((elements) {
        parameters.add({
          "menu_id": elements.id,
          "quantity": elements.quantity,
        });
      });
    });
    // print(
    //     "####################################Response###########################");
    // print("parameters = $parameters");
    // final response = await http.post(
    //     Uri.parse("https://api/v1/menus/validate-order"),
    //     body: jsonEncode({"items": parameters}));

    // print(response.body);
    // print(response.statusCode);
  }

  Future<void> fetchMenuItems() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response =
          // await http.get(Uri.parse("https://api.visit.menu/api/v1/menus"));
          await http.get(Uri.parse(
              "${dotenv.env["MENU_URL"]}/${widget.businessID}/menus"));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final menuResponse = MenuResponse.fromJson(jsonData);

        // Convert MenuItem objects to the format expected by the UI
        final items = menuResponse.items.map((item) {
          return {
            'title': item.name,
            'description': item.description,
            'price': '₦${item.price.toStringAsFixed(2)}',
            'image': item.imgUrl,
            'category': item.category,
            /////added business id ot order item for identification
            "id": item.id,
            "available": item.available,
            "is_available": item.isAvailable
          };
        }).toList();

        setState(() {
          _allItems = items;
          filteredItemsForDisplay = items;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load menu items. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
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
          child: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: fetchMenuItems,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerIcons(),
                const SizedBox(height: 16),
                MenuHeader(businessName: widget.businessName),
                const SizedBox(height: 16),
                _buildSearchField(),
                const SizedBox(height: 16),
                _buildCategoryButtons(),
                const SizedBox(height: 16),
                // _buildMenuSection(
                //   title: selectedCategory,
                //   itemCount: '${filteredItemsForDisplay.length} items',
                //   items: filteredItemsForDisplay,
                // ),
                if (isLoading)
                  _buildLoadingIndicator()
                else if (errorMessage != null)
                  _buildErrorMessage()
                else
                  _buildMenuSection(
                    title: selectedCategory,
                    itemCount:
                        '${filteredItemsForDisplay.length} item${filteredItemsForDisplay.length > 1 ? 's' : ""}',
                    items: filteredItemsForDisplay,
                  ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          CircularProgressIndicator(color: mainOrangeColor),
          SizedBox(height: 16),
          Text('Loading menu items...'),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 16),
          Text(
            "Unable to load Menu!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: fetchMenuItems,
            style: ElevatedButton.styleFrom(
              backgroundColor: mainOrangeColor,
            ),
            child: Text('Try Again', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _headerIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ShimmerImage(widget.logoUrl, fit: BoxFit.cover, width: 30),
            ),
            // Image.network(
            //   widget.logoUrl,
            //   fit: BoxFit.cover,
            //   width: 22,
            // ),
            SizedBox(width: 8),
            Text(
              widget.businessName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        // Container(
        //     width: 32,
        //     height: 32,
        //     //padding: const EdgeInsets.symmetric(horizontal: 10),
        //     decoration: BoxDecoration(
        //       border: Border.all(color: borderGreyColor, width: 1.0),
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     child: InkWell(
        //         onTap: () {
        //           Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        //             return OrderNotificationsScreen();
        //           }));
        //         },
        //         child: CircleAvatar(
        //           radius: 8,
        //           backgroundColor: mainOrangeColor,
        //           child: Icon(Icons.notifications,
        //               size: 24, color: mainOrangeColor),
        //         ))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return OrderNotificationsScreen(
                      businessID: widget.businessID);
                }));
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: mainOrangeColor,
                child: Image.asset(
                  "assets/icons/store.png",
                  fit: BoxFit.cover,
                ),
              )),
        )
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
                name: item['title'],
                price: item['price'],
                quantity: quantity,
                imageUrl: item["image"],
                id: item["id"]);
            if (currentOrderIndex == null) {
              cartItems.add(
                Order(
                  orderItems: [newOrderItem],
                  businessId: widget.businessID,
                  customerName: "Guest",
                  tableTag: "Table",
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
      builder: (context) => ConfirmOrderSheet(
        orders: cartItems,
        businessId: widget.businessID,
        onAddMoreItems: () {
          Navigator.pop(context); // Close the confirm order sheet
        },
        onOrderConfirmed: () {
          // Add this new callback
          submitOrder(cartItems);
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
        onSubmitted: (value) {
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

  // // Get filtered items based on selected category
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

  // get unique categories from the api
  List<String> get uniqueCategories {
    final categories =
        _allItems.map((item) => item['category'] as String).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  // Update category buttons
  Widget _buildCategoryButtons() {
    // return Center(
    //   child: SingleChildScrollView(
    //     scrollDirection: Axis.horizontal,
    //     child: Row(
    //         children: categories.map((e) {
    //       return GestureDetector(
    //         onTap: () => setState(() {
    //           selectedCategory = e;
    //           filteredItemsForDisplay = searchFilter(filteredItems);
    //         }),
    //         child: CategoryButton(
    //           text: e,
    //           isSelected: selectedCategory == e,
    //           onTap: () => setState(() {
    //             selectedCategory = e;
    //             filteredItemsForDisplay = searchFilter(filteredItems);
    //           }),
    //         ),
    //       );
    //     }).toList()
    //         // [
    //         //   GestureDetector(
    //         //     onTap: () => setState(() => selectedCategory = 'All'),
    //         //     child: CategoryButton(
    //         //       text: "All",
    //         //       isSelected: selectedCategory == 'All',
    //         //       onTap: () => setState(() => selectedCategory = 'All'),
    //         //     ),
    //         //   ),
    //         //   const SizedBox(width: 12),
    //         //   GestureDetector(
    //         //     onTap: () => setState(() => selectedCategory = 'Rice Dishes'),
    //         //     child: CategoryButton(
    //         //       text: "Rice Dishes",
    //         //       isSelected: selectedCategory == 'Rice Dishes',
    //         //       onTap: () => setState(() => selectedCategory = 'Rice Dishes'),
    //         //     ),
    //         //   ),
    //         //   const SizedBox(width: 12),
    //         //   GestureDetector(
    //         //     onTap: () => setState(() => selectedCategory = 'Local Meals'),
    //         //     child: CategoryButton(
    //         //       text: "Local Meals",
    //         //       isSelected: selectedCategory == 'Local Meals',
    //         //       onTap: () => setState(() => selectedCategory = 'Local Meals'),
    //         //     ),
    //         //   ),
    //         //   const SizedBox(width: 12),
    //         //   GestureDetector(
    //         //     onTap: () => setState(() => selectedCategory = 'Snacks'),
    //         //     child: CategoryButton(
    //         //       text: "Snacks",
    //         //       isSelected: selectedCategory == 'Snacks',
    //         //       onTap: () => setState(() => selectedCategory = 'Snacks'),
    //         //     ),
    //         //   ),
    //         // ],
    //         ),
    //   ),
    // );
    final categories = uniqueCategories;

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
                  // filteredItemsForDisplay = searchFilter(_allItems);
                  filteredItemsForDisplay = searchFilter(filteredItems);
                }),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget _buildMenuSection({
  //   required String title,
  //   required String itemCount,
  //   required List<Map<String, dynamic>> items,
  // }) {
  //   double height = MediaQuery.sizeOf(context).height;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 6.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               title,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 18,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             Text(
  //               itemCount,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.w400,
  //                 fontSize: 18,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       AnimatedSwitcher(
  //         duration: Duration(milliseconds: 300),
  //         child: items.isEmpty
  //             ? Center(
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(vertical: height * 0.1),
  //                   child: Text(
  //                     "No Meals found!",
  //                     style: Theme.of(context).textTheme.bodyLarge,
  //                   ),
  //                 ),
  //               )
  //             : ListView.builder(
  //                 key: ValueKey(filteredItemsForDisplay),
  //                 shrinkWrap: true,
  //                 physics: NeverScrollableScrollPhysics(),
  //                 itemCount: filteredItemsForDisplay.length,
  //                 itemBuilder: (BuildContext ctx, int index) {
  //                   final item = filteredItemsForDisplay[index];
  //                   return Column(
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () => _showMenuItemDetailsSheet(context, item),
  //                         child: MenuItem(
  //                           title: item['title'],
  //                           description: item['description'],
  //                           price: item['price'],
  //                           imagePath: item['image'],
  //                           onTap: () =>
  //                               _showMenuItemDetailsSheet(context, item),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                     ],
  //                   );
  //                 }),
  //       ),
  //       //Changing the items to a list view to animate it when filters are changed
  //       // ...items.map(
  //       //   (item) => Column(
  //       //     children: [
  //       //       GestureDetector(
  //       //         onTap: () => _showMenuItemDetailsSheet(context, item),
  //       //         child: MenuItem(
  //       //           title: item['title'],
  //       //           description: item['description'],
  //       //           price: item['price'],
  //       //           imagePath: item['image'],
  //       //           onTap: () => _showMenuItemDetailsSheet(context, item),
  //       //         ),
  //       //       ),
  //       //       const SizedBox(height: 10),
  //       //     ],
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

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
                "${title[0].toUpperCase()}${title.substring(1).toLowerCase()}",
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
                          onTap: item["available"]
                              ? () => _showMenuItemDetailsSheet(context, item)
                              : null,
                          child: MenuItem(
                            title: item['title'],
                            description: item['description'],
                            price: item['price'],
                            imagePath: item['image'],
                            isAvailable: item["is_available"],
                            available: item["available"],
                            onTap: () =>
                                _showMenuItemDetailsSheet(context, item),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
        ),
      ],
    );
  }

  // final List<Map<String, dynamic>> _allItems = [
  //   // Rice Dishes
  //   {
  //     'title': 'Asun Pepper Rice',
  //     'description': 'Basmati Rice with pieces of Asun',
  //     'price': 'N3,500',
  //     'image': 'assets/images/image 5.png',
  //     'category': 'Rice Dishes',
  //   },
  //   {
  //     'title': 'Party Jollof',
  //     'description': 'Flavorful rice cooked',
  //     'price': 'N3,500',
  //     'image': 'assets/images/image 6.png',
  //     'category': 'Rice Dishes',
  //   },
  //   {
  //     'title': 'Fried Rice',
  //     'description': 'Rice stir-fried with vegetables',
  //     'price': 'N3,500',
  //     'image': 'assets/images/image 4.png',
  //     'category': 'Rice Dishes',
  //   },
  //   // Local Meals
  //   {
  //     'title': 'Pounded Yam',
  //     'description': 'Traditional Nigerian meal',
  //     'price': 'N3,500',
  //     'image': 'assets/images/image 4.png',
  //     'category': 'Local Meals',
  //   },
  //   {
  //     'title': 'Eba',
  //     'description': 'Cassava flour meal',
  //     'price': 'N2,500',
  //     'image': 'assets/images/image 5.png',
  //     'category': 'Local Meals',
  //   },

  //   // Snacks
  //   {
  //     'title': 'Iceream',
  //     'description': 'Chocolate iceream',
  //     'price': 'N3,500',
  //     'image': 'assets/images/icecream.png',
  //     'category': 'Snacks',
  //   },
  //   {
  //     'title': 'Tea',
  //     'description': 'Slim tea',
  //     'price': 'N2,500',
  //     'image': 'assets/images/tea.png',
  //     'category': 'Snacks',
  //   },
  //   {
  //     'title': 'Biscuit',
  //     'description': 'Chocolate biscuit',
  //     'price': 'N3,500',
  //     'image': 'assets/images/biscuit.png',
  //     'category': 'Snacks',
  //   },
  // ];
}
