import 'package:flutter/material.dart';

/// Factory class for building tab navigators with independent navigation stacks.
/// 
/// Each tab gets its own Navigator to maintain separate navigation history
/// without affecting other tabs or the main app navigation.
class HomeTabNavigator {
  HomeTabNavigator._();

  /// Builds a Navigator widget for a specific tab.
  /// 
  /// [key] - GlobalKey to maintain navigator state across tab switches
  /// [child] - The root widget for this tab's navigation stack
  static Widget build({
    required GlobalKey<NavigatorState> key,
    required Widget child,
  }) {
    return Navigator(
      key: key,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => child,
        );
      },
    );
  }
}
