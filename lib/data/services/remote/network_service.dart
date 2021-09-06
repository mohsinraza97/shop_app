import '../../models/entities/user.dart';
import '../../models/network/add_response.dart';
import '../../models/entities/order.dart';
import '../../models/network/api_response.dart';
import '../../models/entities/product.dart';

// A network service contract [Usage: API Calls]
abstract class NetworkService {
  // region auth
  Future<ApiResponse<User>> signUp(UserRequest? userRequest);

  Future<ApiResponse<User>> login(UserRequest? userRequest);
  // endregion

  // region product
  Future<ApiResponse<List<Product>>> fetchProducts(bool filterByUser);

  Future<ApiResponse<AddResponse>> addProduct(Product? product);

  Future<ApiResponse<Product>> updateProduct(Product? product);

  Future<ApiResponse<bool>> updateProductFavoriteStatus(Product? product);

  Future<ApiResponse<bool>> deleteProduct(String? id);
  // endregion

  // region order
  Future<ApiResponse<List<Order>>> fetchOrders();

  Future<ApiResponse<AddResponse>> addOrder(Order? order);
  // endregion
}
