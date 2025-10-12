import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oudurvxsoiychjywpfdl.supabase.co',
    anonKey: 'sb_publishable_kgI1oBb4QGqkxHiMBCwZNA_esRrgr1F',
  );

  runApp(const App());
}
