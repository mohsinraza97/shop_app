import 'package:uuid/uuid.dart';
import '../../resources/app_strings.dart';
import '../../../data/models/ui/ui_response.dart';
import '../../../data/services/entities/product_service.dart';
import '../../../data/app_locator.dart';
import '../base_view_model.dart';
import '../../../data/models/entities/product.dart';

class ProductListViewModel extends BaseViewModel {
  List<Product> _products = [];
  final _service = locator<ProductService>();

  List<Product> get products => _products;

  List<Product> get favoriteProducts {
    return _products.where((p) => p.isFavorite ?? false).toList();
  }

  Product findById(String? id) {
    return _products.firstWhere((p) => p.id == id);
  }

  void clearProducts() {
    _products = [];
    notifyListeners();
  }

  Future<UiResponse<List<Product>>> fetchAll({bool filterByUser = false}) async {
    final response = await _service.fetchAll(filterByUser);
    if (response.hasData) {
      _products = response.data!;
      notifyListeners();
      return UiResponse(data: _products);
    }
    return UiResponse(
      errorMessage: response.errorMessage ?? AppStrings.error_no_data_found,
    );
  }

  Future<UiResponse<bool>> add(Product? product) async {
    if (product != null) {
      final response = await _service.add(product);
      if (response.hasData) {
        product.id = response.data?.id ?? Uuid().v1();
        _products.add(product);
        notifyListeners();
        return UiResponse(data: true);
      }
      return UiResponse(
        errorMessage: response.errorMessage ?? AppStrings.error_ui_general,
      );
    }
    return UiResponse(errorMessage: AppStrings.error_product_empty);
  }

  Future<UiResponse<bool>> update(Product? product) async {
    var index = _products.indexWhere((p) => p.id == product?.id);
    if (index >= 0) {
      final response = await _service.update(product);
      if (response.hasData) {
        _products[index] = response.data!;
        notifyListeners();
        return UiResponse(data: true);
      }
      return UiResponse(
        errorMessage: response.errorMessage ?? AppStrings.error_ui_general,
      );
    }
    return UiResponse(errorMessage: AppStrings.error_product_not_found);
  }

  Future<UiResponse<bool>> delete(String? id) async {
    final response = await _service.delete(id);
    if (response.hasData && response.data!) {
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
      return UiResponse(data: response.data!);
    }
    return UiResponse(
      errorMessage: response.errorMessage ?? AppStrings.error_ui_general,
    );
  }
}
