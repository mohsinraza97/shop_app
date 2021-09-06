import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../constants/app_constants.dart';
import '../constants/route_constants.dart';
import '../../ui/pages/splash/splash_page.dart';
import '../../ui/pages/auth/auth_page.dart';
import '../../ui/pages/cart/cart_page.dart';
import '../../ui/pages/order/orders_page.dart';
import '../../ui/pages/product/product_detail_page.dart';
import '../../ui/pages/product/product_overview_page.dart';
import '../../ui/pages/user_product/manage_product_page.dart';
import '../../ui/pages/user_product/user_products_page.dart';
import '../../data/models/ui/page_arguments.dart';
import 'log_utils.dart';

class RouteUtils {
  const RouteUtils._internal();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Route arguments can be managed here and values for those can be passed to page constructor.
    // If we do not want to pass arguments directly to page constructor and let the particular page
    // handle the arguments itself than we must pass 'settings' as an argument to MaterialPageRoute

    final route = settings.name;
    final args = settings.arguments as PageArguments?;
    LogUtils.debug(
      'RouteUtils',
      'generateRoute',
      '$route, ${args?.toJson()}',
    );

    if (route == RouteConstants.home) {
      // Initial route doesn't requires transition
      return MaterialPageRoute(
        builder: (ctx) => SplashPage(),
      );
    } else if (route == RouteConstants.auth) {
      return _getPageRoute(
        AuthPage(),
        transitionType: args?.transitionType,
      );
    } else if (route == RouteConstants.product_overview) {
      return _getPageRoute(
        ProductOverviewPage(),
        transitionType: args?.transitionType,
      );
    } else if (route == RouteConstants.product_detail) {
      return _getPageRoute(
        ProductDetailPage(
          productId: args?.data,
        ),
        transitionType: args?.transitionType,
      );
    } else if (route == RouteConstants.cart) {
      return _getPageRoute(
        CartPage(),
        transitionType: args?.transitionType,
      );
    } else if (route == RouteConstants.orders) {
      return _getPageRoute(
        OrdersPage(),
        transitionType: args?.transitionType,
      );
    } else if (route == RouteConstants.user_products) {
      return _getPageRoute(
        UserProductsPage(),
        transitionType: args?.transitionType,
      );
    } else if (route == RouteConstants.manage_product) {
      final id = args?.data[AppConstants.key_id];
      final option = args?.data[AppConstants.key_option];
      return _getPageRoute(
        ManageProductPage(
          productId: id,
          manageOption: option,
        ),
        transitionType: args?.transitionType,
      );
    }
  }

  static PageTransition<dynamic> _getPageRoute(
    Widget page, {
    PageTransitionType? transitionType,
    RouteSettings? settings,
  }) {
    // If null, set a default transition
    if (transitionType == null) {
      transitionType = PageTransitionType.fade;
    }
    return PageTransition(
      type: transitionType,
      child: page,
      settings: settings,
    );
  }
}
