import '../base_model.dart';

class Cart implements BaseModel {
  final String id;
  final String title;
  final int quantity;
  final double price;

  Cart({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['Id'],
      title: json['Title'],
      quantity: json['Quantity'],
      price: json['Price'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
      'Quantity': quantity,
      'Price': price,
    };
  }
}
