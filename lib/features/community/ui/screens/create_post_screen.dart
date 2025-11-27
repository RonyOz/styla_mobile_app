import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';
import 'package:styla_mobile_app/features/community/domain/usecases/get_outfit_usecase.dart';
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
  late final GetOutfitUseCase _getOutfitUseCase; 
  List<Outfit> _availableOutfits = [];
  Outfit? _selectedOutfit;
  bool _isLoadingOutfits = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _whoAmIUsecase = WhoAmIUsecase(profileRepository: ProfileRepositoryImpl());

    final communityRepository = context.read<CommunityRepository>();
    _getOutfitUseCase = GetOutfitUseCase(communityRepository: communityRepository); 

    _loadOutfits(); 
  }

  Future<void> _loadOutfits() async {
    setState(() {
      _isLoadingOutfits = true;
      _errorMessage = null;
    });

    try {
      final outfits = await _getOutfitUseCase.execute();
      
      setState(() {
        _availableOutfits = outfits;
        if (outfits.isNotEmpty) {
          _selectedOutfit = outfits.first;
        }
        _isLoadingOutfits = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar Outfits: ${e.toString()}';
        _isLoadingOutfits = false;
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_selectedOutfit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona un Outfit antes de publicar.')),
      );
      return;
    }
    
    try {
      final userId = await _whoAmIUsecase.execute(); 
      final postContent = _contentController.text.trim();

      context.read<CommunityBloc>().add(
        CreatePostRequested(
          userId: userId,
          outfitId: _selectedOutfit!.id!,
          content: postContent.isEmpty ? null : postContent,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear post: $e')),
      );
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

              if (_isLoadingOutfits)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage != null)
                Center(child: Text(_errorMessage!, style: const TextStyle(color: AppColors.error)))
              else if (_availableOutfits.isEmpty)
                const Center(child: Text('No tienes Outfits disponibles para publicar.'))
              else
                _buildOutfitSelector(), 

              const SizedBox(height: 20),

              Container(
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
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                child: _selectedOutfit?.imageUrl != null 
                    ? AspectRatio( 
                        aspectRatio: 16 / 9, 
                        child: Image.network(
                          _selectedOutfit!.imageUrl!,
                          fit: BoxFit.cover, 
                          width: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Selecciona un Outfit', style: TextStyle(color: AppColors.grey)),
                          if (_selectedOutfit != null) 
                            Text('Outfit: ${_selectedOutfit!.name}', style: const TextStyle(color: AppColors.grey, fontSize: 10)),
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
                  onPressed: _selectedOutfit == null ? null : _createPost, 

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.0,
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

  Widget _buildOutfitSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Outfit>(
          isExpanded: true,
          value: _selectedOutfit,
          hint: const Text('Selecciona un Outfit', style: TextStyle(color: AppColors.grey)),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          dropdownColor: AppColors.textOnPrimary,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
          items: _availableOutfits.map((Outfit outfit) {
            return DropdownMenuItem<Outfit>(
              value: outfit,
              child: Text(outfit.name), 
            );
          }).toList(),
          onChanged: (Outfit? newValue) {
            setState(() {
              _selectedOutfit = newValue;
            });
          },
        ),
      ),
    );
  }
}