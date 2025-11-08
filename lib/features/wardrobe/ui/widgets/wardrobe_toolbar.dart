import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

enum WardrobeMenuAction { addGarment, manageTags }

class WardrobeToolbar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onFavoritesTap;
  final Function(WardrobeMenuAction) onMenuSelected;

  const WardrobeToolbar({
    super.key,
    required this.onSearchTap,
    required this.onFavoritesTap,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // _ToolbarIconButton(
        //   icon: Icons.search,
        //   tooltip: 'Buscar en tu closet',
        //   onTap: onSearchTap,
        // ),
        const Spacer(),
        _ToolbarIconButton(
          icon: Icons.favorite_border,
          tooltip: 'Favoritos',
          onTap: onFavoritesTap,
        ),
        const SizedBox(width: 12),
        PopupMenuButton<WardrobeMenuAction>(
          onSelected: onMenuSelected,
          color: AppColors.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: WardrobeMenuAction.addGarment,
              child: Text('Agregar prenda'),
            ),
            PopupMenuItem(
              value: WardrobeMenuAction.manageTags,
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
