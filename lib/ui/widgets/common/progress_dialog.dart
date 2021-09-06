import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressDialog extends StatelessWidget {
  final bool visible;
  final String? message;
  final bool? dismissible;

  const ProgressDialog({
    required this.visible,
    this.message,
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
      child: LayoutBuilder(builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        return Visibility(
          visible: visible,
          child: Container(
            color: Colors.black54,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildLoaderWidget(constraints, context),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLoaderWidget(BoxConstraints constraints, BuildContext context) {
    if (message?.isNotEmpty ?? false) {
      return Container(
        width: constraints.maxWidth * 0.75,
        height: constraints.maxHeight * 0.225,
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildProgressWidget(context, size: 72),
            _buildMessageWidget(),
          ],
        ),
      );
    } else {
      return Container(
        width: 104,
        height: 104,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: _buildProgressWidget(context, size: 56),
      );
    }
  }

  Widget _buildProgressWidget(BuildContext context, {required double size}) {
    return SpinKitRing(
      size: size,
      color: Theme.of(context).accentColor,
    );
  }

  Widget _buildMessageWidget() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: Text(
        message ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
