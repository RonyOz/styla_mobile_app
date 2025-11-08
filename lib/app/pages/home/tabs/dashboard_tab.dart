import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/bloc/dashboard_bloc.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/bloc/dashboard_event.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/bloc/dashboard_state.dart';
import 'package:styla_mobile_app/core/core.dart';

/// Dashboard tab - Home screen showing main content and recommendations
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  static const List<String> _moodTags = [
    'Trabajo',
    'Fiesta',
    'Gym',
    'Cita',
    'Concierto',
  ];

  static const List<_OutfitCardData> _recommendedOutfits = [
    _OutfitCardData(
      title: 'Outfit para ir a la U',
      vibe: 'Casual',
      tags: ['Casual', 'Cool'],
      isFavorite: true,
    ),
    _OutfitCardData(
      title: 'Brunch relajado',
      vibe: 'Fresco',
      tags: ['Relax', 'Denim'],
    ),
    _OutfitCardData(
      title: 'Reunion creativa',
      vibe: 'Smart',
      tags: ['Trabajo', 'Color'],
    ),
  ];

  static const List<_OutfitCardData> _highlightedOutfits = [
    _OutfitCardData(
      title: 'Viernes informal',
      vibe: 'Cool',
      tags: ['Casual', 'Mix&Match'],
      isFavorite: true,
    ),
    _OutfitCardData(
      title: 'Date night',
      vibe: 'Bold',
      tags: ['Cita', 'Nocturno'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(LoadUserProfile()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final nickname = state is DashboardLoaded
              ? state.profile.nickname
              : 'Usuario';

          final dateLabel = _formatDate(DateTime.now());

          return ColoredBox(
            color: AppColors.background,
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner de construcción
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.construction,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Página aún en construcción, no esperes que las funcionalidades funcionen en esta página',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildHeaderActions(context),
                    const SizedBox(height: 16),
                    _buildStyleAiCard(context, dateLabel, nickname),
                    const SizedBox(height: 28),
                    _buildSectionHeader(
                      context,
                      title: 'Outfits recomendados',
                      onTap: () => _showComingSoon(context),
                    ),
                    const SizedBox(height: 12),
                    _buildOutfitCarousel(_recommendedOutfits),
                    const SizedBox(height: 28),
                    _buildSectionHeader(
                      context,
                      title: 'Outfits destacados',
                      onTap: () => _showComingSoon(context),
                    ),
                    const SizedBox(height: 12),
                    _buildOutfitCarousel(_highlightedOutfits),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _FrostedIconButton(
          icon: Icons.search,
          tooltip: 'Buscar',
          onPressed: () => _showComingSoon(context),
        ),
        const SizedBox(width: 12),
        _FrostedIconButton(
          icon: Icons.favorite_border,
          tooltip: 'Favoritos',
          onPressed: () => _showComingSoon(context),
        ),
        const SizedBox(width: 12),
        _FrostedIconButton(
          icon: Icons.more_horiz,
          tooltip: 'Mas opciones',
          onPressed: () => _showComingSoon(context),
        ),
      ],
    );
  }

  Widget _buildStyleAiCard(
    BuildContext context,
    String dateLabel,
    String nickname,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF181818), Color(0xFF101010)],
        ),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'StyleAI',
                style: AppTypography.subtitle.copyWith(
                  color: AppColors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'SOON',
                  style: AppTypography.caption.copyWith(
                    letterSpacing: 1,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Hola $nickname!',
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontFamily: AppTypography.headingFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.place_outlined, size: 16, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text(
                'Cali, $dateLabel',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(Icons.wb_sunny_outlined, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                '27 C',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _moodTags.map((mood) => _MoodChip(label: mood)).toList(),
          ),
          const SizedBox(height: 16),
          _MoodPromptField(onTap: () => _showComingSoon(context)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: AppTypography.subtitle.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondary,
              textStyle: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Ver mas'),
          ),
      ],
    );
  }

  Widget _buildOutfitCarousel(List<_OutfitCardData> outfits) {
    return SizedBox(
      height: 360,
      child: ListView.separated(
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: outfits.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) => _OutfitCard(data: outfits[index]),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const weekdays = [
      'Lunes',
      'Martes',
      'Miercoles',
      'Jueves',
      'Viernes',
      'Sabado',
      'Domingo',
    ];
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday ${date.day} $month';
  }

  static void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Disponible pronto.'),
          duration: Duration(seconds: 2),
        ),
      );
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MoodPromptField extends StatelessWidget {
  const _MoodPromptField({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Cual es el mood de hoy? StyleAI te ayuda',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_forward,
                size: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutfitCardData {
  const _OutfitCardData({
    required this.title,
    required this.vibe,
    required this.tags,
    this.isFavorite = false,
  });

  final String title;
  final String vibe;
  final List<String> tags;
  final bool isFavorite;
}

class _OutfitCard extends StatelessWidget {
  const _OutfitCard({required this.data});

  final _OutfitCardData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2F2F2F), Color(0xFF1C1C1C)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.checkroom_outlined,
                          size: 48,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 14,
                  top: 14,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    child: IconButton(
                      icon: Icon(
                        data.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: data.isFavorite
                            ? AppColors.secondary
                            : Colors.white,
                      ),
                      tooltip: data.isFavorite
                          ? 'Quitar de favoritos'
                          : 'Agregar a favoritos',
                      onPressed: () => DashboardTab._showComingSoon(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: data.tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 6),
          Text(
            data.vibe,
            style: AppTypography.caption.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FrostedIconButton extends StatelessWidget {
  const _FrostedIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white10),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.white),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
