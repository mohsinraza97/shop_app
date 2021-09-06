import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../data/models/ui/page_arguments.dart';
import '../../../utils/utilities/navigation_utils.dart';
import '../../../utils/extensions/app_extensions.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../data/enums/manage_product_options.dart';
import '../../../utils/constants/route_constants.dart';
import '../../../data/models/entities/product.dart';

class UserProductItem extends StatelessWidget {
  final Product? _product;
  final Function(String? id) _deleteProductCallback;

  const UserProductItem(this._product, this._deleteProductCallback);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_product?.title ?? ''),
      subtitle: Text('\$${_product?.price.format()}'),
      leading: CircleAvatar(
        radius: 32,
        backgroundImage: NetworkImage(_product?.imageUrl ?? ''),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                NavigationUtils.push(
                  context,
                  RouteConstants.manage_product,
                  args: PageArguments(
                    data: {
                      AppConstants.key_id: _product?.id,
                      AppConstants.key_option: ManageProductOptions.edit,
                    },
                    transitionType: PageTransitionType.bottomToTop,
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () => _deleteProductCallback(_product?.id),
            ),
          ],
        ),
      ),
    );
  }
}
