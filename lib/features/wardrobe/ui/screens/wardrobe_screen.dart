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
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/wardrobe_toolbar.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/wardrobe_controls.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/wardrobe_filter_section.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/garment_grid_tile.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/garment_list_tile.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/wardrobe_empty_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/wardrobe_loading_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/wardrobe_error_state.dart' as error_widget;

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

enum ViewMode { grid, list }

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

  void _onMenuSelected(WardrobeMenuAction action) {
    switch (action) {
      case WardrobeMenuAction.addGarment:
        _openAddGarmentFlow();
        break;
      case WardrobeMenuAction.manageTags:
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
                WardrobeToolbar(
                  onSearchTap: _showComingSoon,
                  onFavoritesTap: _showComingSoon,
                  onMenuSelected: _onMenuSelected,
                ),
                const SizedBox(height: 12),
                Text(
                  'Mi closet',
                  style: AppTypography.title.copyWith(
                    color: AppColors.white,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 12),
                WardrobeControls(
                  hasActiveFilters: _selectedCategory != null || _selectedTags.isNotEmpty,
                  showFilters: _showFilters,
                  onFiltersTap: () => setState(() => _showFilters = !_showFilters),
                  onSortTap: _showComingSoon,
                  viewMode: _viewMode,
                  onViewModeChanged: _setViewMode,
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: WardrobeFilterSection(
                      selectedCategory: _selectedCategory,
                      selectedTags: _selectedTags,
                      categories: const ['Prendas superiores', 'Calzado', 'Prendas inferiores'],
                      tags: const ['Old Money', 'Emo', 'Oversized', 'Street wear', 'Fresco'],
                      onApply: _applyFilters,
                      onClear: _clearFilters,
                      onCategoryChanged: (category) {
                        setState(() => _selectedCategory = category);
                      },
                      onTagToggled: (tag) {
                        setState(() {
                          if (_selectedTags.contains(tag)) {
                            _selectedTags.remove(tag);
                          } else {
                            _selectedTags.add(tag);
                          }
                        });
                      },
                    ),
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

  Widget _buildStateContent(WardrobeState state) {
    if (state is WardrobeErrorState) {
      return error_widget.WardrobeErrorView(
        message: state.message,
        onRetry: () => context.read<WardrobeBloc>().add(LoadGarmentsRequested()),
      );
    }

    if (state is WardrobeLoadedState) {
      if (state.garments.isEmpty) {
        return WardrobeEmptyState(onAddGarment: _openAddGarmentFlow);
      }

      return _viewMode == ViewMode.grid
          ? _buildGridView(state.garments)
          : _buildListView(state.garments);
    }

    return const WardrobeLoadingView();
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
        return GarmentGridTile(
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
        return GarmentListTile(
          garment: garment,
          onTap: () => _showGarmentDetail(context, garment),
        );
      },
    );
  }
}
