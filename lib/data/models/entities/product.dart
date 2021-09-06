import '../base_model.dart';

class Product implements BaseModel {
  String? id;
  String? title;
  String? description;
  String? imageUrl;
  double? price;
  String? userId;
  bool? isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.userId,
    this.isFavorite = false,
  });

  factory Product.fromJson(
    Map<String, dynamic> json, {
    String? id,
    bool? favoriteStatus,
  }) {
    return Product(
      id: id ?? json['Id'],
      title: json['Title'],
      description: json['Description'],
      imageUrl: json['ImageURL'],
      price: json['Price'],
      userId: json['UserId'],
      isFavorite: favoriteStatus ?? json['IsFavorite'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
      'Description': description,
      'ImageURL': imageUrl,
      'Price': price,
      'UserId': userId,
      // IsFavorite is managed on user level not product level so not required
      // to send in add/update
      // 'IsFavorite': isFavorite,
    };
  }
}

class ProductFetchResponse implements BaseModel {
  List<Product>? products;

  ProductFetchResponse({this.products});

  factory ProductFetchResponse.fromJson(
    Map<String, dynamic>? productsJson,
    Map<String, dynamic>? favoriteProductsJson,
  ) {
    final List<Product>? data = [];
    productsJson?.forEach((key, value) {
      // Here key is product id and value is product data (map)
      data?.add(Product.fromJson(
        value,
        id: key,
        favoriteStatus: favoriteProductsJson == null
            ? false
            : favoriteProductsJson[key] ?? false,
      ));
    });
    return ProductFetchResponse(products: data);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'products': products?.map((x) => x.toJson()),
    };
  }
}
