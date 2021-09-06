import '../../../utils/utilities/datetime_utils.dart';
import '../base_model.dart';
import 'cart.dart';

class Order implements BaseModel {
  String? id;
  final double? amount;
  final List<Cart>? cartItems;
  final DateTime? date;

  Order({
    this.id,
    required this.amount,
    required this.cartItems,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json, {String? id}) {
    return Order(
      id: id ?? json['Id'],
      amount: json['Amount'],
      cartItems: json['Products'] == null
          ? null
          : List<Cart>.from(json['Products'].map((x) => Cart.fromJson(x))),
      date: DateTimeUtils.parse(json['Date']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Amount': amount,
      'Products': cartItems?.map((x) => x.toJson()).toList(),
      'Date': date?.toIso8601String(),
    };
  }
}

class OrderFetchResponse implements BaseModel {
  List<Order>? orders;

  OrderFetchResponse({this.orders});

  factory OrderFetchResponse.fromJson(Map<String, dynamic>? json) {
    final List<Order>? data = [];
    json?.forEach((key, value) {
      data?.add(Order.fromJson(value, id: key));
    });
    return OrderFetchResponse(orders: data);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'orders': orders?.map((x) => x.toJson()),
    };
  }
}
