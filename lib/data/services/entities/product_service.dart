import '../../models/entities/user.dart';
import '../../models/network/add_response.dart';
import '../../models/ui/ui_response.dart';
import '../../models/entities/product.dart';

abstract class ProductService {
  Future<UiResponse<List<Product>>> fetchAll(bool filterByUser);

  Future<UiResponse<AddResponse>> add(Product? product);

  Future<UiResponse<Product>> update(Product? product);

  Future<UiResponse<bool>> updateFavoriteStatus(Product? product);

  Future<UiResponse<bool>> delete(String? id);
}
