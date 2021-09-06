import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/extensions/app_extensions.dart';
import '../../resources/app_strings.dart';
import '../../../utils/utilities/dialog_utils.dart';
import '../../../data/models/entities/cart.dart';
import '../../view_models/cart/cart_view_model.dart';

class CartItem extends StatelessWidget {
  final Cart cart;
  final String productId;

  const CartItem({required this.cart, required this.productId});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CartViewModel>(context, listen: false);
    var total = (cart.price * cart.quantity).format();

    return Dismissible(
      key: ValueKey(cart.id),
      background: Container(
        color: Theme.of(context).errorColor,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return DialogUtils.showAlertDialog<bool>(
          context,
          title: AppStrings.confirmation,
          message: 'Are you sure want to remove \"${cart.title}\" from your cart?',
          dismissible: false,
          secondaryButtonText: AppStrings.cancel,
          primaryButtonText: AppStrings.delete,
        );
      },
      onDismissed: (direction) {
        viewModel.removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorLight,
              radius: 32,
              child: FittedBox(
                child: Text(
                  '\$${cart.price.format()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            title: Text(cart.title),
            subtitle: Text('${AppStrings.total}: \$$total'),
            trailing: Text('${cart.quantity} x'),
          ),
        ),
      ),
    );
  }
}
