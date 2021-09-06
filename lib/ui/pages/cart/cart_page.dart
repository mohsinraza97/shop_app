import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/utilities/dialog_utils.dart';
import '../../../utils/extensions/app_extensions.dart';
import '../../widgets/common/progress_loader.dart';
import '../../resources/app_strings.dart';
import '../../../utils/utilities/navigation_utils.dart';
import '../../view_models/cart/cart_view_model.dart';
import '../../view_models/order/order_view_model.dart';
import '../../widgets/cart/cart_item.dart';
import '../../../utils/utilities/common_utils.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var _isLoading = false;
  var _isInit = false;
  late CartViewModel _viewModel;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _isInit = true;
      _viewModel = Provider.of<CartViewModel>(context);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.title_cart),
      ),
      body: _buildBodyWidget(),
    );
  }

  Widget _buildBodyWidget() {
    return Stack(
      children: [
        Column(
          children: [
            _buildCartGrossTotalWidget(),
            _buildCartListWidget(),
          ],
        ),
        ProgressLoader(visible: _isLoading),
      ],
    );
  }

  Widget _buildCartGrossTotalWidget() {
    final orderVM = Provider.of<OrderViewModel>(context, listen: false);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 8, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.total,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 8),
            Chip(
              label: Text(
                '\$${_viewModel.totalAmount.format()}',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            Spacer(),
            FlatButton(
              child: Text(AppStrings.order_now.toUpperCase()),
              textColor: Theme.of(context).primaryColor,
              onPressed: () async {
                if (_viewModel.items.isNotEmpty) {
                  _toggleLoader(loading: true);

                  // Create a new order
                  orderVM.add(
                    _viewModel.items.values.toList(),
                    _viewModel.totalAmount,
                  ).then((response) {
                    _toggleLoader(loading: false);
                    if (response.hasData && response.data!) {
                      // Clear cart
                      _viewModel.clearCart();

                      // Show order placement intimation
                      CommonUtils.showSnackBar(
                        context: context,
                        content: AppStrings.success_order_placement,
                      );

                      NavigationUtils.pop(context);
                    } else {
                      DialogUtils.showErrorDialog(
                        context,
                        message: response.errorMessage,
                      );
                    }
                  });
                } else {
                  // Show cart empty intimation
                  CommonUtils.showSnackBar(
                    context: context,
                    content: AppStrings.cart_empty,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartListWidget() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return CartItem(
            cart: _viewModel.items.values.elementAt(index),
            productId: _viewModel.items.keys.elementAt(index),
          );
        },
        itemCount: _viewModel.items.length,
      ),
    );
  }

  void _toggleLoader({required bool loading}) {
    setState(() {
      _isLoading = loading;
    });
  }
}
