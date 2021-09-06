import '../../../ui/resources/app_strings.dart';
import '../../models/network/add_response.dart';
import '../../models/ui/ui_response.dart';
import '../base_repository.dart';
import '../../services/entities/product_service.dart';
import '../../models/entities/product.dart';

class ProductRepository extends BaseRepository implements ProductService {
  @override
  Future<UiResponse<List<Product>>> fetchAll(bool filterByUser) async {
    if (!await hasInternet()) {
      return UiResponse(
        errorMessage: AppStrings.error_internet_unavailable,
      );
    }
    final response = await networkService.fetchProducts(filterByUser);
    return UiResponse.map(response);
  }

  @override
  Future<UiResponse<AddResponse>> add(Product? product) async {
    if (!await hasInternet()) {
      return UiResponse(
        errorMessage: AppStrings.error_internet_unavailable,
      );
    }
    final response = await networkService.addProduct(product);
    return UiResponse.map(response);
  }

  @override
  Future<UiResponse<Product>> update(Product? product) async {
    if (!await hasInternet()) {
      return UiResponse(
        errorMessage: AppStrings.error_internet_unavailable,
      );
    }
    final response = await networkService.updateProduct(product);
    return UiResponse.map(response);
  }

  @override
  Future<UiResponse<bool>> updateFavoriteStatus(Product? product) async {
    if (!await hasInternet()) {
      return UiResponse(
        errorMessage: AppStrings.error_internet_unavailable,
      );
    }
    final response = await networkService.updateProductFavoriteStatus(product);
    return UiResponse.map(response);
  }

  @override
  Future<UiResponse<bool>> delete(String? id) async {
    if (!await hasInternet()) {
      return UiResponse(
        errorMessage: AppStrings.error_internet_unavailable,
      );
    }
    final response = await networkService.deleteProduct(id);
    return UiResponse.map(response);
  }
}
