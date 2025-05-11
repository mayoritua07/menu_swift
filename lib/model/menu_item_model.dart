class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imgUrl;
  final String category;
  final int portionsAvailable;
  final String businessId;
  final int totalPortions;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imgUrl,
    required this.category,
    required this.portionsAvailable,
    required this.businessId,
    required this.totalPortions,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      imgUrl: json['img_url'] as String,
      category: json['category'] as String,
      portionsAvailable: json['portions_available'] as int,
      businessId: json['business_id'] as String,
      totalPortions: json['total_portions'] as int,
    );
  }

  Map<String, String> toOrderItem() {
    return {
      'title': name,
      'description': description,
      'price': 'N${price.toStringAsFixed(2)}',
      'image': imgUrl,
      'category': category,
    };
  }
}

class MenuResponse {
  final List<MenuItemModel> items;
  final int count;
  final int limit;
  final int page;
  final int totalPages;

  MenuResponse({
    required this.items,
    required this.count,
    required this.limit,
    required this.page,
    required this.totalPages,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final itemsList = data['items'] as List<dynamic>;

    return MenuResponse(
      items: itemsList
          .map((item) => MenuItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      count: data['count'] as int,
      limit: data['limit'] as int,
      page: data['page'] as int,
      totalPages: data['total_pages'] as int,
    );
  }
}
