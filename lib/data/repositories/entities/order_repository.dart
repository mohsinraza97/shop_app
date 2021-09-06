import '../../../ui/resources/app_strings.dart';
import '../../models/network/add_response.dart';
import '../../models/entities/order.dart';
import '../../models/ui/ui_response.dart';
import '../base_repository.dart';
import '../../services/entities/order_service.dart';

class OrderRepository extends BaseRepository implements OrderService {
  @override
  Future<UiResponse<List<Order>>> fetchAll() async {
    if (!await hasInternet()) {
      return UiResponse(
        errorMessage: AppStrings.error_internet_unavailable,
      );
    }
    final response = await networkService.fetchOrders();
    return UiResponse.map(response);
  }

  @override
  Future<UiResponse<AddResponse>> add(Order? order) async {
    if (!await hasInternet()) {
      return UiResponse(
        errorMessage: AppStrings.error_internet_unavailable,
      );
    }
    final response = await networkService.addOrder(order);
    return UiResponse.map(response);
  }
}
