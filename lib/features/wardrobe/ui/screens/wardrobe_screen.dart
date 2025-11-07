import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/add_garment_screen.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/garment_detail_screen.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

enum ViewMode { grid, list }

enum _WardrobeMenuAction { addGarment, manageTags }

class _WardrobeScreenState extends State<WardrobeScreen> {
  bool _showFilters = false;
  String? _selectedCategory;
  final List<String> _selectedTags = [];
  ViewMode _viewMode = ViewMode.grid;

  @override
  void initState() {
    super.initState();
    _loadViewMode();
    context.read<WardrobeBloc>().add(LoadGarmentsRequested());
  }

  Future<void> _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode =
        prefs.getString('wardrobe_view_mode') ?? ViewMode.grid.name;
    if (!mounted) return;

    setState(() {
      _viewMode = savedMode == ViewMode.list.name
          ? ViewMode.list
          : ViewMode.grid;
    });
  }

  Future<void> _setViewMode(ViewMode mode) async {
    if (_viewMode == mode) return;

    setState(() => _viewMode = mode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wardrobe_view_mode', mode.name);
  }

  void _openAddGarmentFlow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<WardrobeBloc>(),
          child: const AddGarmentScreen(),
        ),
      ),
    ).then((_) {
      context.read<WardrobeBloc>().add(LoadGarmentsRequested());
    });
  }

  void _onMenuSelected(_WardrobeMenuAction action) {
    switch (action) {
      case _WardrobeMenuAction.addGarment:
        _openAddGarmentFlow();
        break;
      case _WardrobeMenuAction.manageTags:
        _showComingSoon();
        break;
    }
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Disponible pronto.'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  void _applyFilters() {
    context.read<WardrobeBloc>().add(
      GetFilteredGarmentsRequested(
        category: _selectedCategory ?? '',
        tags: _selectedTags,
      ),
    );
    setState(() {
      _showFilters = false;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedTags.clear();
    });
    context.read<WardrobeBloc>().add(LoadGarmentsRequested());
  }

  void _showGarmentDetail(BuildContext context, Garment garment) {
    final wardrobeBloc = context.read<WardrobeBloc>();

    Navigator.of(context, rootNavigator: true)
        .push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider.value(
              value: wardrobeBloc,
              child: GarmentDetailScreen(garment: garment),
            ),
          ),
        )
        .then((_) {
          if (mounted) {
            context.read<WardrobeBloc>().add(LoadGarmentsRequested());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WardrobeBloc, WardrobeState>(
      listener: (context, state) {
        if (state is GarmentUpdatedState || state is GarmentDeletedState) {
          context.read<WardrobeBloc>().add(LoadGarmentsRequested());
        }
      },
      child: ColoredBox(
        color: AppColors.background,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildToolbar(),
                const SizedBox(height: 12),
                Text(
                  'Mi closet',
                  style: AppTypography.title.copyWith(
                    color: AppColors.white,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 12),
                _buildControlsRow(),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildFilterSection(),
                  ),
                  crossFadeState: _showFilters
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: BlocBuilder<WardrobeBloc, WardrobeState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildStateContent(state),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        _ToolbarIconButton(
          icon: Icons.search,
          tooltip: 'Buscar en tu closet',
          onTap: _showComingSoon,
        ),
        const Spacer(),
        _ToolbarIconButton(
          icon: Icons.favorite_border,
          tooltip: 'Favoritos',
          onTap: _showComingSoon,
        ),
        const SizedBox(width: 12),
        PopupMenuButton<_WardrobeMenuAction>(
          onSelected: _onMenuSelected,
          color: AppColors.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _WardrobeMenuAction.addGarment,
              child: Text('Agregar prenda'),
            ),
            PopupMenuItem(
              value: _WardrobeMenuAction.manageTags,
              child: Text('Gestionar etiquetas'),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10),
            ),
            child: const Icon(Icons.more_horiz, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildControlsRow() {
    final hasActiveFilters =
        _selectedCategory != null || _selectedTags.isNotEmpty;

    return Row(
      children: [
        _WardrobeFilterChip(
          label: 'Filtros',
          icon: Icons.filter_list,
          isActive: hasActiveFilters || _showFilters,
          onTap: () {
            setState(() => _showFilters = !_showFilters);
          },
        ),
        const SizedBox(width: 12),
        _WardrobeFilterChip(
          label: 'Ordenar por',
          icon: Icons.swap_vert,
          onTap: _showComingSoon,
        ),
        const Spacer(),
        _ViewTogglePill(selected: _viewMode, onChanged: _setViewMode),
      ],
    );
  }

  Widget _buildStateContent(WardrobeState state) {
    if (state is WardrobeErrorState) {
      return _buildErrorState(state.message);
    }

    if (state is WardrobeLoadedState) {
      if (state.garments.isEmpty) {
        return _buildEmptyState();
      }

      return _viewMode == ViewMode.grid
          ? _buildGridView(state.garments)
          : _buildListView(state.garments);
    }

    return _buildLoadingState();
  }

  Widget _buildGridView(List<Garment> garments) {
    return GridView.builder(
      key: const ValueKey('wardrobe_grid'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemCount: garments.length,
      itemBuilder: (context, index) {
        final garment = garments[index];
        return _GarmentGridTile(
          garment: garment,
          onTap: () => _showGarmentDetail(context, garment),
        );
      },
    );
  }

  Widget _buildListView(List<Garment> garments) {
    return ListView.separated(
      key: const ValueKey('wardrobe_list'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: garments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final garment = garments[index];
        final tags = garment.tagNames ?? const [];

        return GestureDetector(
          onTap: () => _showGarmentDetail(context, garment),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 92,
                    height: 92,
                    child: garment.imageUrl.isNotEmpty
                        ? Image.network(
                            garment.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const _GarmentPlaceholder(),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const _GarmentPlaceholder(isLoading: true);
                            },
                          )
                        : const _GarmentPlaceholder(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        garment.categoryName?.isNotEmpty == true
                            ? garment.categoryName!
                            : 'Sin categoria',
                        style: AppTypography.subtitle.copyWith(
                          fontSize: 16,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (tags.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: tags
                              .take(3)
                              .map((tag) => _TagPill(text: tag))
                              .toList(),
                        )
                      else
                        Text(
                          'Agrega etiquetas para organizarla',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'Estilo: ${garment.style.isNotEmpty ? garment.style : '-'}   |   Ocasion: ${garment.occasion.isNotEmpty ? garment.occasion : '-'}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTypography.body.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                context.read<WardrobeBloc>().add(LoadGarmentsRequested()),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        key: const ValueKey('wardrobe_empty'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checkroom_outlined, size: 82, color: AppColors.secondary),
          const SizedBox(height: 24),
          Text(
            'Aun no tienes nada agregado',
            style: AppTypography.subtitle.copyWith(
              color: AppColors.secondary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega algo para empezar',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: _openAddGarmentFlow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text('Agregar ropa'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      key: const ValueKey('wardrobe_loading'),
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const _WardrobeSkeletonTile(),
    );
  }

  Widget _buildFilterSection() {
    final categories = ['Prendas superiores', 'Calzado', 'Prendas inferiores'];
    final tags = ['Old Money', 'Emo', 'Oversized', 'Street wear', 'Fresco'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filtros',
                style: AppTypography.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Limpiar'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Categorias',
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final isSelected = _selectedCategory == category;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                  });
                },
                selectedColor: AppColors.secondary.withOpacity(0.25),
                checkmarkColor: AppColors.white,
                backgroundColor: AppColors.surface,
                labelStyle: AppTypography.caption.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Etiquetas',
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.25),
                checkmarkColor: AppColors.textOnPrimary,
                backgroundColor: AppColors.surface,
                labelStyle: AppTypography.caption.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Aplicar filtros'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  const _ToolbarIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _WardrobeFilterChip extends StatelessWidget {
  const _WardrobeFilterChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.secondary.withOpacity(0.18)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive
                ? AppColors.secondary
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewTogglePill extends StatelessWidget {
  const _ViewTogglePill({required this.selected, required this.onChanged});

  final ViewMode selected;
  final ValueChanged<ViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          _ViewToggleButton(
            icon: Icons.grid_view,
            isSelected: selected == ViewMode.grid,
            onTap: () => onChanged(ViewMode.grid),
          ),
          _ViewToggleButton(
            icon: Icons.view_list,
            isSelected: selected == ViewMode.list,
            onTap: () => onChanged(ViewMode.list),
          ),
        ],
      ),
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  const _ViewToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? AppColors.textOnSecondary : Colors.white,
        ),
      ),
    );
  }
}

class _GarmentGridTile extends StatelessWidget {
  const _GarmentGridTile({required this.garment, required this.onTap});

  final Garment garment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tags = garment.tagNames ?? const [];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Positioned.fill(
                child: garment.imageUrl.isNotEmpty
                    ? Image.network(
                        garment.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const _GarmentPlaceholder(),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const _GarmentPlaceholder(isLoading: true);
                        },
                      )
                    : const _GarmentPlaceholder(),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.45),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        garment.categoryName?.isNotEmpty == true
                            ? garment.categoryName!
                            : 'Sin categoria',
                        style: AppTypography.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (tags.isNotEmpty)
                        Text(
                          tags.take(2).join(' / '),
                          style: AppTypography.caption.copyWith(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _GarmentPlaceholder extends StatelessWidget {
  const _GarmentPlaceholder({this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : Icon(
                Icons.checkroom_outlined,
                size: 36,
                color: Colors.white.withOpacity(0.4),
              ),
      ),
    );
  }
}

class _WardrobeSkeletonTile extends StatelessWidget {
  const _WardrobeSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
