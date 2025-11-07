import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/wardrobe/data/repository/wardrobe_repository_impl.dart';
import 'package:styla_mobile_app/features/wardrobe/data/source/wardrobe_data_source.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/wardrobe_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Wardrobe tab - Closet management with BLoC provider
class WardrobeTab extends StatelessWidget {
  const WardrobeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final supabase = Supabase.instance.client;
        final dataSource = WardrobeDataSourceImpl(supabaseClient: supabase);
        final repository = WardrobeRepositoryImpl(
          wardrobeDataSource: dataSource,
        );
        return WardrobeBloc(wardrobeRepository: repository);
      },
      child: const WardrobeScreen(),
    );
  }
}
