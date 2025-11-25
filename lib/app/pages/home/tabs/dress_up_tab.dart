import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/dress/data/repository/dress_repository_impl.dart';
import 'package:styla_mobile_app/features/dress/data/source/dress_data_source.dart';
import 'package:styla_mobile_app/features/dress/ui/bloc/dress_bloc.dart';
import 'package:styla_mobile_app/features/dress/ui/screens/dress_screen.dart';
import 'package:styla_mobile_app/features/wardrobe/data/source/wardrobe_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Dress up tab - Outfit planning and combination features
class DressUpTab extends StatelessWidget {
  const DressUpTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final supabase = Supabase.instance.client;
        final dataSource = DressDataSourceImpl(supabaseClient: supabase);
        final repository = DressRepositoryImpl(dataSource);
        return DressBloc(dressRepository: repository);
      },
      child: const VestirseScreen(),
    );
  }
}
