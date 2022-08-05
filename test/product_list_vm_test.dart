import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/data/models/entities/product.dart';
import 'package:shop_app/di/app_locator.dart';
import 'package:shop_app/ui/view_models/product/product_list_view_model.dart';
import 'package:uuid/uuid.dart';

import 'data/repositories/MockProductRepository.dart';

void main() {
  // Initialize dependency injection
  initLocator();

  // Initialize view model and inject fake repository
  final viewModel = locator<ProductListViewModel>();
  viewModel.service = MockProductRepository();

  final mouse = Product(
    id: Uuid().v1(),
    title: 'Logitech Mouse',
    description: 'Mouse - Computer Component',
    imageUrl: null,
    price: 49,
  );

  final keyboard = Product(
    id: Uuid().v1(),
    title: 'A4Tech Keyboard',
    description: 'Keyboard - Computer Component',
    imageUrl: null,
    price: 25,
  );

  test('Add items to product list', () async {
    await viewModel.add(mouse);
    expect(viewModel.products.length, 1);

    await viewModel.add(keyboard);
    expect(viewModel.products.length, 2);
  });

  test('Update existing item description', () async {
    mouse.description = "Test Mouse";
    await viewModel.update(mouse);
    expect(viewModel.findById(mouse.id).description, "Test Mouse");
  });

  group('Given product overview page', () {
    test('Should load list of available products', () async {
      await viewModel.fetchAll();
      expect(viewModel.products.length, 2);
    });

    test('Delete an existing item', () async {
      await viewModel.delete(mouse.id);
      expect(viewModel.products.length, 1);
    });
  });
}
