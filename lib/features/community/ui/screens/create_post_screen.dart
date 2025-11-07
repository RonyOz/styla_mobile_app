import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Post'),
        actions: [
          TextButton(onPressed: _createPost, child: const Text('Publicar')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO: reemplazar con selector de outfits
            // Ejemplo: DropdownButton, GridView, o ListView de outfits
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: const Text(
                'Usando outfit temporal para pruebas',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText:
                    '¿Qué quieres compartir sobre este outfit? (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
