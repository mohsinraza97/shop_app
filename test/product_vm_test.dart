import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/data/models/entities/product.dart';
import 'package:shop_app/di/app_locator.dart';
import 'package:shop_app/ui/view_models/product/product_view_model.dart';
import 'package:uuid/uuid.dart';

import 'data/repositories/MockProductRepository.dart';

void main() {
  // Initialize dependency injection
  initLocator();

  // Dummy product
  final mouse = Product(
    id: Uuid().v1(),
    title: 'Logitech Mouse',
    description: 'Mouse - Computer Component',
    imageUrl: null,
    price: 49,
  );

  // Initialize view model and inject fake repository
  final viewModel = locator<ProductViewModel>();
  viewModel.product = mouse;
  viewModel.service = MockProductRepository();

  test('Mark product as favorite', () async {
    await viewModel.updateFavoriteStatus();
    expect(viewModel.product?.isFavorite, true);
  });

  test('Mark product as un-favorite', () async {
    await viewModel.updateFavoriteStatus();
    expect(viewModel.product?.isFavorite, false);
  });
}
