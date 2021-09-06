import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressLoader extends StatelessWidget {
  final bool visible;
  final bool? dismissible;

  const ProgressLoader({
    required this.visible,
    this.dismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (visible) {
          return dismissible ?? false;
        }
        return true;
      },
      child: Visibility(
        visible: visible,
        child: Container(
          color: Colors.black54,
          child: Center(
            child: SpinKitRing(
              size: 72,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
