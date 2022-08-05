import '../../../data/models/ui/ui_response.dart';
import '../../resources/app_strings.dart';
import '../../../di/app_locator.dart';
import '../../../data/services/entities/product_service.dart';
import '../base_view_model.dart';
import '../../../data/models/entities/product.dart';

class ProductViewModel extends BaseViewModel {
  Product? product;
  var _service = locator<ProductService>();

  ProductViewModel([this.product]);

  set service(ProductService service) {
    _service = service;
  }

  Future<UiResponse<bool>> updateFavoriteStatus() async {
    product?.isFavorite = !(product?.isFavorite ?? false);
    final response = await _service.updateFavoriteStatus(product);
    if (response.hasData) {
      notifyListeners();
      return UiResponse(data: true);
    }
    return UiResponse(
      errorMessage: response.errorMessage ?? AppStrings.error_ui_general,
    );
  }
}
