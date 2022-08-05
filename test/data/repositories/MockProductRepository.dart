import 'package:shop_app/data/models/entities/product.dart';
import 'package:shop_app/data/models/network/add_response.dart';
import 'package:shop_app/data/models/ui/ui_response.dart';
import 'package:shop_app/data/services/entities/product_service.dart';
import 'package:shop_app/ui/resources/app_strings.dart';

class MockProductRepository implements ProductService {
  List<Product> _products = [];

  @override
  Future<UiResponse<AddResponse>> add(Product? product) {
    if (product == null) {
      return Future.value(UiResponse(errorMessage: AppStrings.error_product_empty));
    }
    _products.add(product);
    return Future.value(UiResponse(data: AddResponse(id: product.id)));
  }

  @override
  Future<UiResponse<bool>> delete(String? id) {
    _products.removeWhere((p) => p.id == id);
    return Future.value(UiResponse(data: true));
  }

  @override
  Future<UiResponse<List<Product>>> fetchAll(bool filterByUser) {
    if (filterByUser) {
      final userId = "";
      final list = _products.where((p) => p.userId == userId).toList();
      return Future.value(UiResponse(data: list));
    }
    return Future.value(UiResponse(data: _products));
  }

  @override
  Future<UiResponse<Product>> update(Product? product) {
    var index = _products.indexWhere((p) => p.id == product?.id);
    if (product == null || index < 0) {
      return Future.value(UiResponse(errorMessage: AppStrings.error_product_not_found));
    }
    _products[index] = product;
    return Future.value(UiResponse(data: product));
  }

  @override
  Future<UiResponse<bool>> updateFavoriteStatus(Product? product) {
    // Favorite flag is already updated from view model before calling repository function
    // So no need to further update flag over here
    return Future.value(UiResponse(data: product?.isFavorite != null));
  }
}
