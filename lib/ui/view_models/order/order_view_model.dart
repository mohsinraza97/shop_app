import 'package:uuid/uuid.dart';
import '../../../data/models/ui/ui_response.dart';
import '../../resources/app_strings.dart';
import '../../../data/app_locator.dart';
import '../../../data/services/entities/order_service.dart';
import '../base_view_model.dart';
import '../../../data/models/entities/cart.dart';
import '../../../data/models/entities/order.dart';

class OrderViewModel extends BaseViewModel {
  List<Order> _orders = [];
  final _service = locator<OrderService>();

  List<Order> get orders => _orders;

  void clearOrders() {
    _orders = [];
    notifyListeners();
  }

  Future<UiResponse<List<Order>>> fetchAll() async {
    final response = await _service.fetchAll();
    if (response.hasData) {
      _orders = response.data!.reversed.toList();
      notifyListeners();
      return UiResponse(data: _orders);
    }
    return UiResponse(
      errorMessage: response.errorMessage ?? AppStrings.error_no_data_found,
    );
  }

  Future<UiResponse<bool>> add(List<Cart> cartItems, double total) async {
    final order = Order(
      cartItems: cartItems,
      amount: total,
      date: DateTime.now(),
    );
    final response = await _service.add(order);
    if (response.hasData) {
      order.id = response.data?.id ?? Uuid().v1();
      _orders.insert(0, order);
      notifyListeners();
      return UiResponse(data: true);
    }
    return UiResponse(
      errorMessage: response.errorMessage ?? AppStrings.error_ui_general,
    );
  }
}
