import 'dart:math';

import 'package:flutter/material.dart';
import '../../widgets/auth/auth_card.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_strings.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    transformConfig.translate(-10.0);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).accentColor.withOpacity(0.5),
                    Theme.of(context).accentColor.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
            ),
            Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(top: 48, bottom: 24),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 72.0,
                      ),
                      transform: transformConfig,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).accentColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: FittedBox(
                        child: Text(
                          AppStrings.app_name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontFamily: AppAssets.font_family_anton,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: AuthCard(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
