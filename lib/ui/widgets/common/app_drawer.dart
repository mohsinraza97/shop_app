import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../utils/utilities/common_utils.dart';
import '../../view_models/auth/auth_view_model.dart';
import '../../resources/app_strings.dart';
import '../../../utils/utilities/navigation_utils.dart';
import '../../../utils/constants/route_constants.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Drawer(
      child: Column(
        children: [
          _buildNavWidget(context, authVM),
          _buildVersionWidget(context),
        ],
      ),
    );
  }

  Widget _buildNavWidget(BuildContext context, AuthViewModel authVM) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavHeader(context, authVM),
            ..._buildNavItems(context, authVM),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildNavHeader(BuildContext context, AuthViewModel authVM) {
    final userImage = authVM.user?.imageUrl;
    final userName = authVM.user?.name;
    final userEmail = authVM.user?.email;
    final image = (userImage?.isNotEmpty ?? false) ? userImage : null;
    final name = (userName?.isNotEmpty ?? false) ? userName : null;
    final email = (userEmail?.isNotEmpty ?? false) ? userEmail : null;

    return UserAccountsDrawerHeader(
      currentAccountPicture: CircleAvatar(
        radius: 64,
        backgroundColor: Theme.of(context).primaryColorLight,
        backgroundImage: image != null ? NetworkImage(image) : null,
        child: image == null
            ? FaIcon(
                FontAwesomeIcons.solidUserCircle,
                size: 64,
                color: Colors.white70,
              )
            : null,
      ),
      accountName: Text(
        name ?? 'Anonymous',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        email ?? 'N/A',
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      onDetailsPressed: () {},
    );
  }

  List<Widget> _buildNavItems(BuildContext context, AuthViewModel authVM) {
    final divider = Divider(thickness: 1);
    final home = _buildDrawerItemWidget(
      context,
      Icons.home,
      AppStrings.drawer_home,
      () {
        NavigationUtils.replace(context, RouteConstants.product_overview);
      },
    );
    final orders = _buildDrawerItemWidget(
      context,
      Icons.payment,
      AppStrings.drawer_orders,
      () {
        NavigationUtils.replace(context, RouteConstants.orders);
      },
    );
    final products = _buildDrawerItemWidget(
      context,
      Icons.shopping_basket,
      AppStrings.drawer_products,
      () {
        NavigationUtils.replace(context, RouteConstants.user_products);
      },
    );
    final logout = _buildDrawerItemWidget(
      context,
      Icons.exit_to_app,
      AppStrings.drawer_logout,
      () {
        _onLogout(context, authVM);
      },
    );

    List<Widget> _navItems = [];
    _navItems.add(home);
    _navItems.add(orders);
    _navItems.add(products);
    _navItems.add(divider);
    _navItems.add(logout);
    return _navItems;
  }

  Widget _buildDrawerItemWidget(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTapCallback,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: () {
        _closeDrawer(context);
        onTapCallback();
      },
    );
  }

  Widget _buildVersionWidget(BuildContext context) {
    return FutureBuilder<String>(
      future: CommonUtils.getAppVersion(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                Text(
                  '${AppStrings.app_version}: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  snapshot.data ?? '',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void _closeDrawer(BuildContext context) {
    NavigationUtils.pop(context);
  }

  void _onLogout(BuildContext context, AuthViewModel authVM) {
    authVM.logout().then((value) {
      NavigationUtils.clearStack(
        context,
        newRouteName: RouteConstants.auth,
      );
    });
  }
}
