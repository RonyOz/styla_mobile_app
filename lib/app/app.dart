import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/core.dart';
>>>>>>> dev
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
