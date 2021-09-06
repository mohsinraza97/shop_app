import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/product/product_list_view_model.dart';
import '../../view_models/product/product_view_model.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool _showOnlyFavorites;

  const ProductGrid(this._showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductListViewModel>(context);
    final products = _showOnlyFavorites
        ? viewModel.favoriteProducts
        : viewModel.products;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: ProductViewModel(products.elementAt(index)),
          child: ProductItem(),
        );
      },
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
    );
  }
}
