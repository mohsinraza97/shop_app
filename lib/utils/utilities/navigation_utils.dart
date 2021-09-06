import 'package:flutter/material.dart';
import '../../data/models/ui/page_arguments.dart';
import '../constants/route_constants.dart';
import 'log_utils.dart';

class NavigationUtils {
  const NavigationUtils._internal();

  static Future<Object?> push(
    BuildContext context,
    String routeName, {
    PageArguments? args,
    bool? awaitsResult,
  }) async {
    try {
      if (awaitsResult ?? false) {
        final result = await Navigator.of(context).pushNamed(
          routeName,
          arguments: args,
        );
        return result;
      } else {
        Navigator.of(context).pushNamed(routeName, arguments: args);
        return true;
      }
    } on Exception catch (ex) {
      LogUtils.error('NavigationUtils', 'push', ex.toString());
      return false;
    }
  }

  static bool pop(BuildContext context, {Object? result}) {
    try {
      var navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop(result ?? null);
      }
      return true;
    } on Exception catch (ex) {
      LogUtils.error('NavigationUtils', 'pop', ex.toString());
      return false;
    }
  }

  static Future<Object?> replace(
    BuildContext context,
    String routeName, {
    PageArguments? args,
    bool? awaitsResult,
  }) async {
    try {
      if (awaitsResult ?? false) {
        final result = await Navigator.of(context).pushReplacementNamed(
          routeName,
          arguments: args,
        );
        return result;
      } else {
        Navigator.of(context).pushReplacementNamed(routeName, arguments: args);
        return true;
      }
    } on Exception catch (ex) {
      LogUtils.error('NavigationUtils', 'replace', ex.toString());
      return false;
    }
  }

  static bool clearStack(
    BuildContext context, {
    String newRouteName = RouteConstants.home,
  }) {
    try {
      Navigator.of(context).pushNamedAndRemoveUntil(
        newRouteName,
        (route) => false,
      );
      return true;
    } on Exception catch (ex) {
      LogUtils.error('NavigationUtils', 'clearStack', ex.toString());
      return false;
    }
  }
}
