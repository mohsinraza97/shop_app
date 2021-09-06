import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants/route_constants.dart';
import '../../../utils/utilities/common_utils.dart';
import '../../widgets/common/progress_loader.dart';
import '../../resources/app_strings.dart';
import '../../view_models/order/order_view_model.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/order/order_item.dart';
import '../../../utils/utilities/navigation_utils.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var _isLoading = false;
  late OrderViewModel _viewModel;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      _viewModel = Provider.of<OrderViewModel>(context, listen: false);
      _viewModel.clearOrders();
      _loadOrders();
    });

    super.initState();
  }

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
          title: const Text(AppStrings.title_orders),
        ),
        body: _buildBodyWidget(),
        drawer: AppDrawer(),
      ),
    );
  }

  Widget _buildBodyWidget() {
    final viewModel = Provider.of<OrderViewModel>(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              return OrderItem(viewModel.orders.elementAt(index));
            },
            itemCount: viewModel.orders.length,
          ),
        ),
        ProgressLoader(visible: _isLoading),
      ],
    );
  }

  Future<void> _loadOrders() async {
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
}
