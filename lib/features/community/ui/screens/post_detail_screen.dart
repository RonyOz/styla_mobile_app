import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagen del post
                  if (post.image != null)
                    Image.network(
                      post.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surfaceVariant,
                          child: Icon(
                            Icons.checkroom,
                            size: 80,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: AppColors.surfaceVariant,
                      child: Icon(
                        Icons.checkroom,
                        size: 80,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  // Overlay gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Autor
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.userProfile,
                        arguments: {
                          'userId': post.authorUserId,
                          'nickname': post.authorNickname,
                          'photo': post.authorPhoto,
                        },
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: post.authorPhoto != null
                              ? NetworkImage(post.authorPhoto!)
                              : null,
                          backgroundColor: AppColors.surfaceVariant,
                          child: post.authorPhoto == null
                              ? Icon(
                                  Icons.person,
                                  color: AppColors.textSecondary,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.authorNickname ?? 'Usuario',
                                style: AppTypography.subtitle.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatDate(post.createdAt),
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Likes
                  Row(
                    children: [
                      Icon(Icons.favorite, color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${post.likesAmount} likes',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  if (post.content != null) ...[
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 16),
                    Text(
                      'Descripción',
                      style: AppTypography.subtitle.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.content!,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (diff.inDays > 0) {
      return 'Hace ${diff.inDays} día${diff.inDays > 1 ? 's' : ''}';
    } else if (diff.inHours > 0) {
      return 'Hace ${diff.inHours} hora${diff.inHours > 1 ? 's' : ''}';
    } else if (diff.inMinutes > 0) {
      return 'Hace ${diff.inMinutes} minuto${diff.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Ahora';
    }
  }
}
