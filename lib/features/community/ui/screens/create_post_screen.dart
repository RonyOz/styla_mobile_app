import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/community_bloc.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/events/community_event.dart';
import 'package:styla_mobile_app/features/profile/domain/usescases/who_am_i_usecase.dart';
import 'package:styla_mobile_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  late final WhoAmIUsecase _whoAmIUsecase;

  // TODO: Cambiar este hardcoded por un selector para mostrar los outfits del usuario
  static const String _MOCK_OUTFIT_ID = 'be5a2500-73fd-4dbe-a890-b95441fadb33';

  @override
  void initState() {
    super.initState();
    _whoAmIUsecase = WhoAmIUsecase(profileRepository: ProfileRepositoryImpl());
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _createPost() {
    try {
      final userId = _whoAmIUsecase.execute();

      context.read<CommunityBloc>().add(
        CreatePostRequested(
          userId: userId,
          outfitId: _MOCK_OUTFIT_ID,
          content: _contentController.text.trim().isEmpty
              ? null
              : _contentController.text.trim(),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Crear Nuevo Post',
            style: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          actions: const [], 
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16), 

              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.transparent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary,
                      blurRadius: 2,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Outfit Placeholder', style: TextStyle(color: AppColors.grey)),
                    const SizedBox(height: 4),
                    Text('ID Mock: $_MOCK_OUTFIT_ID', style: const TextStyle(color: Colors.transparent, fontSize: 10)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.transparent),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: _contentController,
                  maxLines: 5,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Cuentanos un poco',
                    hintStyle: TextStyle(
                      color: AppColors.grey, 
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
              
              const Spacer(), 

              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ElevatedButton(
                  onPressed: _createPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Publicar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}