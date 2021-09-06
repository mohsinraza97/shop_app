import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String counter;
  final Color? color;
  final VoidCallback? callback;

  const Badge({
    required this.child,
    required this.counter,
    this.color,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: color ?? Theme.of(context).accentColor,
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                counter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
