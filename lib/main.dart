import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/signin_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/signup_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/screens/signIn_screen.dart';
import 'package:styla_mobile_app/features/auth/ui/screens/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oudurvxsoiychjywpfdl.supabase.co',
    anonKey: 'sb_publishable_kgI1oBb4QGqkxHiMBCwZNA_esRrgr1F',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: session != null ? '/home' : '/signup',
      routes: {
        '/login': (_) =>
            BlocProvider(create: (_) => SigninBloc(), child: SigninScreen()),
        '/signup': (_) =>
            BlocProvider(create: (_) => SignupBloc(), child: SignupScreen()),
      },
    );
  }
}
