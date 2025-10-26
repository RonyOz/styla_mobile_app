import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/add_garment_screen.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WardrobeBloc>().add(LoadGarmentsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Guardarropa'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<WardrobeBloc>(),
                    child: const AddGarmentScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WardrobeBloc, WardrobeState>(
        builder: (context, state) {
          if (state is WardrobeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WardrobeErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  AppSpacing.verticalMedium,
                  Text(
                    state.message,
                    style: AppTypography.body.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is WardrobeLoadedState) {
            if (state.garments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.checkroom,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    AppSpacing.verticalMedium,
                    Text(
                      'No tienes prendas aún',
                      style: AppTypography.subtitle.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.verticalSmall,
                    Text(
                      'Agrega tu primera prenda',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: AppSpacing.paddingMedium,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: state.garments.length,
              itemBuilder: (context, index) {
                final garment = state.garments[index];
                return Card(
                  color: AppColors.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: const Icon(Icons.checkroom, size: 48),
                        ),
                      ),
                      Padding(
                        padding: AppSpacing.paddingSmall,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              garment.categoryName,
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (garment.tagNames.isNotEmpty)
                              Text(
                                garment.tagNames.join(', '),
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
