import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/entities/user.dart';
import '../../view_models/auth/auth_view_model.dart';
import '../../../utils/utilities/common_utils.dart';
import '../../view_models/product/product_list_view_model.dart';
import '../../resources/app_strings.dart';
import '../../widgets/common/progress_loader.dart';
import '../../../data/enums/product_filter_options.dart';
import '../../../utils/utilities/dialog_utils.dart';
import '../../widgets/common/badge.dart';
import '../../../utils/utilities/navigation_utils.dart';
import '../../view_models/cart/cart_view_model.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/product/product_grid.dart';
import '../../../utils/constants/route_constants.dart';

class ProductOverviewPage extends StatefulWidget {
  @override
  _ProductOverviewPageState createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  var _showOnlyFavorites = false;
  var _isLoading = false;
  late ProductListViewModel _viewModel;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _viewModel = Provider.of<ProductListViewModel>(context, listen: false);
      _viewModel.clearProducts();
      _loadProducts();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _onBackPressed(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: _buildBodyWidget(),
        drawer: AppDrawer(),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    if (CommonUtils.isDrawerOpen(_scaffoldKey)) {
      return true;
    }
    if (_isLoading) {
      return false;
    }
    var allowExit = false;
    await DialogUtils.showAlertDialog<bool>(
      context,
      title: AppStrings.exit,
      message: AppStrings.exit_message,
      dismissible: false,
      secondaryButtonText: AppStrings.cancel,
      primaryButtonText: AppStrings.exit,
      primaryButtonCallback: () => allowExit = true,
    );
    return allowExit;
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppStrings.app_name),
      actions: [
        Consumer<CartViewModel>(
          builder: (ctx, viewModel, staticChild) {
            return Badge(
              child: staticChild ?? _buildCartIconWidget(),
              counter: viewModel.itemCount.toString(),
              callback: _openCart,
            );
          },
          // As this icon button doesn't have any changes
          // So we can use this child in our badge to better performance
          child: _buildCartIconWidget(),
        ),
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          tooltip: AppStrings.tooltip_more_options,
          itemBuilder: (ctx) => [
            PopupMenuItem(
              child: Text(AppStrings.menu_item_favorites),
              value: ProductFilterOptions.favorites,
            ),
            PopupMenuItem(
              child: Text(AppStrings.menu_item_all),
              value: ProductFilterOptions.all,
            ),
          ],
          onSelected: (ProductFilterOptions option) {
            setState(() {
              _showOnlyFavorites = option == ProductFilterOptions.favorites;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCartIconWidget() {
    return IconButton(
      icon: Icon(Icons.shopping_cart),
      tooltip: AppStrings.tooltip_view_cart,
      onPressed: _openCart,
    );
  }

  Widget _buildBodyWidget() {
    return Stack(
      children: [
        ProductGrid(_showOnlyFavorites),
        ProgressLoader(visible: _isLoading),
      ],
    );
  }

  Future<void> _loadProducts() async {
    _toggleLoader(loading: true);
    final response = await _viewModel.fetchAll();
    _toggleLoader(loading: false);
    if (response.hasError) {
      CommonUtils.showSnackBar(
        context: context,
        content: response.errorMessage,
      );
    }
  }

  void _toggleLoader({required bool loading}) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _openCart() {
    NavigationUtils.push(context, RouteConstants.cart);
  }
}
