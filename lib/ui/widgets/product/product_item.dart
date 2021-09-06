import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/ui/page_arguments.dart';
import '../../../utils/utilities/dialog_utils.dart';
import '../../resources/app_strings.dart';
import '../../../utils/utilities/image_utils.dart';
import '../../../utils/utilities/navigation_utils.dart';
import '../../../data/models/entities/product.dart';
import '../../view_models/cart/cart_view_model.dart';
import '../../view_models/product/product_view_model.dart';
import '../../../utils/constants/route_constants.dart';
import '../../../utils/utilities/common_utils.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductViewModel>(
      context,
      listen: false,
    ).product;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            NavigationUtils.push(
              context,
              RouteConstants.product_detail,
              args: PageArguments(data: product?.id),
            );
          },
          child: Hero(
            tag: product?.id ?? '',
            child: ImageUtils.getNetworkImage(product?.imageUrl),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // Consumer: It can be used if we want to listen only part of a widget instead entire
          // Example: Data container widget with renders empty view / data list
          leading: Consumer<ProductViewModel>(
            builder: (ctx, viewModel, child) {
              var isFavorite = viewModel.product?.isFavorite ?? false;
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => _onFavorite(viewModel, context),
              );
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.add_shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => _onAddToCart(context, product),
          ),
          title: Text(
            product?.title ?? '',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _onFavorite(ProductViewModel viewModel, BuildContext context) {
    viewModel.updateFavoriteStatus().then((response) {
      if (response.hasError) {
        DialogUtils.showErrorDialog(
          context,
          message: response.errorMessage,
        );
      }
    });
  }

  void _onAddToCart(BuildContext context, Product? product) {
    final viewModel = Provider.of<CartViewModel>(context, listen: false);
    viewModel.addItem(
      product?.id ?? '',
      product?.price ?? 0,
      product?.title ?? '',
    );

    // Show intimation to user of current product added to cart
    CommonUtils.showSnackBar(
      context: context,
      content: '\"${product?.title ?? ''}\" added to cart.',
      actionVisibility: true,
      actionName: AppStrings.undo,
      actionCallback: () {
        viewModel.undoAddToCart(product?.id ?? '');
      },
    );
  }
}
