import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteLogger extends NavigatorObserver {
  Future<void> _saveLastRoute(Route<dynamic> route) async {
    final routeName = route.settings.name;
    if (routeName != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastRoute', routeName);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _saveLastRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _saveLastRoute(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _saveLastRoute(previousRoute);
    }
  }
}
