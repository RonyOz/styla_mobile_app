import 'package:flutter/material.dart';
import '../core/core.dart';
import 'routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Styla Mobile App',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.theme,

      initialRoute: '/',

      routes: {...AppRouter.routes},
    );
  }
}
