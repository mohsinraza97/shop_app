import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import '../../../data/models/ui/page_arguments.dart';
import '../../../utils/utilities/common_utils.dart';
import '../../widgets/common/progress_loader.dart';
import '../../../utils/utilities/dialog_utils.dart';
import '../../resources/app_strings.dart';
import '../../../data/models/entities/product.dart';
import '../../../utils/utilities/log_utils.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../data/enums/manage_product_options.dart';
import '../../../utils/constants/route_constants.dart';
import '../../view_models/product/product_list_view_model.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/user_product/user_product_item.dart';
import '../../../utils/utilities/navigation_utils.dart';

class UserProductsPage extends StatefulWidget {
  @override
  _UserProductsPageState createState() => _UserProductsPageState();
}

class _UserProductsPageState extends State<UserProductsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (CommonUtils.isDrawerOpen(_scaffoldKey)) {
          return true;
        }
        return NavigationUtils.clearStack(
          context,
          newRouteName: RouteConstants.product_overview,
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(AppStrings.title_products),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _openAddProductPage();
              },
              tooltip: AppStrings.tooltip_add_product,
            ),
          ],
        ),
        body: _buildBodyWidget(),
        drawer: AppDrawer(),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return FutureBuilder(
      future: _loadProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ProgressLoader(visible: true);
        } else {
          return RefreshIndicator(
            onRefresh: () => _loadProducts(),
            color: Theme.of(context).accentColor,
            child: Consumer<ProductListViewModel>(
              builder: (context, viewModel, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
                  ),
                  child: ListView.separated(
                    itemBuilder: (ctx, index) {
                      return UserProductItem(
                        viewModel.products.elementAt(index),
                        (id) => _deleteProduct(viewModel, id),
                      );
                    },
                    itemCount: viewModel.products.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(thickness: 1);
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<void> _loadProducts() async {
    final viewModel = Provider.of<ProductListViewModel>(context, listen: false);
    final response = await viewModel.fetchAll(filterByUser: true);
    if (response.hasError) {
      CommonUtils.showSnackBar(
        context: context,
        content: response.errorMessage,
      );
    }
  }

  void _openAddProductPage() async {
    final newProduct = await NavigationUtils.push(
      context,
      RouteConstants.manage_product,
      args: PageArguments(
        data: {
          AppConstants.key_option: ManageProductOptions.add,
        },
        transitionType: PageTransitionType.bottomToTop,
      ),
      awaitsResult: true,
    );
    if (newProduct != null && newProduct is Product) {
      LogUtils.debug(
        'UserProductsPage',
        'AddProduct',
        'Newly added product: ${newProduct.toJson()}',
      );
    }
  }

  void _deleteProduct(ProductListViewModel viewModel, String? id) {
    viewModel.delete(id).then((response) {
      if (response.hasError) {
        DialogUtils.showErrorDialog(
          context,
          message: response.errorMessage,
        );
      }
    });
  }
}
