import '../../models/network/add_response.dart';
import '../../models/entities/order.dart';
import '../../models/ui/ui_response.dart';

abstract class OrderService {
  Future<UiResponse<List<Order>>> fetchAll();

  Future<UiResponse<AddResponse>> add(Order? order);
}
