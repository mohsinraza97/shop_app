import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/utilities/image_utils.dart';
import '../../../utils/constants/route_constants.dart';
import '../../../utils/utilities/navigation_utils.dart';
import '../../view_models/auth/auth_view_model.dart';
import '../../resources/app_assets.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AuthViewModel _viewModel;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _viewModel = Provider.of<AuthViewModel>(context, listen: false);
      _loadUser();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.image_splash),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: ImageUtils.getLocalImage(
              AppAssets.image_shopping_cart,
              width: 196,
              height: 196,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadUser() async {
    final user = await _viewModel.getAuthenticatedUser();
    Future.delayed(Duration(seconds: 2)).then((value) {
      NavigationUtils.replace(
        context,
        user != null ? RouteConstants.product_overview : RouteConstants.auth,
      );
    });
  }
}
