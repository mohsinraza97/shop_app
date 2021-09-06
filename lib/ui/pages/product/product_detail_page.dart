import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/extensions/app_extensions.dart';
import '../../resources/app_strings.dart';
import '../../view_models/product/product_list_view_model.dart';
import '../../../utils/utilities/image_utils.dart';
import '../../../data/models/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final String? productId;

  const ProductDetailPage({this.productId});

  @override
  Widget build(BuildContext context) {
    // "listen: false" will not allow to re build this page on every change
    final viewModel = Provider.of<ProductListViewModel>(context, listen: false);
    final product = viewModel.findById(productId);

    return Scaffold(
      body: _buildBodyWidget(product),
    );
  }

  Widget _buildBodyWidget(Product product) {
    return Column(
      children: [
        _buildProductDetailWidget(product),
        // _buildAddToCartWidget(context, product),
      ],
    );
  }

  Widget _buildProductDetailWidget(Product product) {
    return Expanded(
      child: CustomScrollView(
        // Slivers are scrollable area on the screen
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title ?? ''),
              background: Hero(
                tag: product.id ?? '',
                child: ImageUtils.getNetworkImage(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 16),
              Text(
                '\$${product.price.format()}',
                style: TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    product.description ?? '',
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
              SizedBox(height: 600), // Fake scrolling
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartWidget(BuildContext context, Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      width: double.infinity,
      height: 48,
      child: RaisedButton.icon(
        color: Theme.of(context).primaryColor,
        label: Text(
          AppStrings.add_to_cart.toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }
}
