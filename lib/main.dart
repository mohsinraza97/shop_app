import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'ui/view_models/auth/auth_view_model.dart';
import 'ui/resources/app_assets.dart';
import 'ui/resources/app_strings.dart';
import 'ui/resources/app_colors.dart';
import 'data/app_locator.dart';
import 'utils/constants/route_constants.dart';
import 'utils/utilities/log_utils.dart';
import 'ui/view_models/cart/cart_view_model.dart';
import 'ui/view_models/order/order_view_model.dart';
import 'ui/view_models/product/product_list_view_model.dart';
import 'utils/utilities/route_utils.dart';

void main() {
  initLocator();
  LogUtils.init();

  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );

    runApp(Application());
  }, (error, trace) {});
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _getProviders(),
      child: MaterialApp(
        title: AppStrings.app_name,
        theme: _getTheme(),
        debugShowCheckedModeBanner: false,
        initialRoute: RouteConstants.home,
        onGenerateRoute: RouteUtils.generateRoute,
      ),
    );
  }

  List<SingleChildWidget> _getProviders() {
    // ChangeNotifierProvider to be used when instantiating a class
    // ChangeNotifierProvider.value to be used when re use an existing object. Example: List/Grid

    return [
      ChangeNotifierProvider(
        create: (ctx) => AuthViewModel(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => ProductListViewModel(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => CartViewModel(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => OrderViewModel(),
      ),
    ];
  }

  ThemeData _getTheme() {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      primaryColorDark: AppColors.primaryColorDark,
      primaryColorLight: AppColors.primaryColorLight,
      accentColor: AppColors.accentColor,
      dividerColor: AppColors.dividerColor,
      errorColor: AppColors.errorColor,
      // scaffoldBackgroundColor: AppColors.backgroundColor,
      fontFamily: AppAssets.font_family_lato,
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
          fontFamily: AppAssets.font_family_lato,
          fontSize: 16,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
