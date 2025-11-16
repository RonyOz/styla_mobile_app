import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/features/community/domain/model/user_profile.dart';
import 'package:styla_mobile_app/features/community/ui/screens/post_detail_screen.dart';
import 'package:styla_mobile_app/features/community/domain/usecases/get_user_profile_usecase.dart';
import 'package:styla_mobile_app/features/community/domain/usecases/get_user_posts_usecase.dart';
import 'package:styla_mobile_app/features/community/domain/usecases/get_user_stats_usecase.dart';
import 'package:styla_mobile_app/features/community/domain/usecases/check_follow_status_usecase.dart';
import 'package:styla_mobile_app/features/community/domain/usecases/follow_user_usecase.dart';
import 'package:styla_mobile_app/features/community/domain/usecases/unfollow_user_usecase.dart';
import 'package:styla_mobile_app/features/profile/domain/usescases/who_am_i_usecase.dart';
import 'package:styla_mobile_app/features/profile/data/repository/profile_repository_impl.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String? nickname;
  final String? photo;

  const UserProfileScreen({
    super.key,
    required this.userId,
    this.nickname,
    this.photo,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _getUserProfileUsecase = GetUserProfileUsecase();
  final _getUserPostsUsecase = GetUserPostsUsecase();
  final _getUserStatsUsecase = GetUserStatsUsecase();
  final _checkFollowStatusUsecase = CheckFollowStatusUsecase();
  final _followUserUsecase = FollowUserUsecase();
  final _unfollowUserUsecase = UnfollowUserUsecase();
  final _whoAmIUsecase = WhoAmIUsecase(
    profileRepository: ProfileRepositoryImpl(),
  );

  bool _isFollowing = false;
  int _followersCount = 0;
  int _followingCount = 0;
  List<Post> _userPosts = [];
  bool _isLoading = true;
  String? _currentUserId;
  String? _displayNickname;
  String? _displayPhoto;
  String? _displayGender;
  int? _displayAge;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    try {
      // Obtener el ID del usuario actual
      _currentUserId = _whoAmIUsecase.execute();

      // Cargar perfil del usuario
      final profile = await _getUserProfileUsecase.execute(
        userId: widget.userId,
      );

      // Cargar estadísticas
      final stats = await _getUserStatsUsecase.execute(userId: widget.userId);

      // Cargar posts
      final posts = await _getUserPostsUsecase.execute(userId: widget.userId);

      // Verificar si el usuario actual sigue a este usuario
      bool isFollowing = false;
      if (_currentUserId != null && _currentUserId != widget.userId) {
        isFollowing = await _checkFollowStatusUsecase.execute(
          followerUserId: _currentUserId!,
          followedUserId: widget.userId,
        );
      }

      setState(() {
        _displayNickname = profile.nickname ?? widget.nickname;
        _displayPhoto = profile.photo ?? widget.photo;
        _displayGender = profile.gender;
        _displayAge = profile.age;
        _followersCount = stats['followers'] ?? 0;
        _followingCount = stats['following'] ?? 0;
        _userPosts = posts;
        _isFollowing = isFollowing;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar perfil: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleFollow() async {
    if (_currentUserId == null) return;

    final wasFollowing = _isFollowing;

    // Actualizar UI optimísticamente
    setState(() {
      _isFollowing = !_isFollowing;
      _followersCount += _isFollowing ? 1 : -1;
    });

    try {
      if (wasFollowing) {
        await _unfollowUserUsecase.execute(
          followerUserId: _currentUserId!,
          followedUserId: widget.userId,
        );
      } else {
        await _followUserUsecase.execute(
          followerUserId: _currentUserId!,
          followedUserId: widget.userId,
        );
      }
    } catch (e) {
      // Revertir en caso de error
      setState(() {
        _isFollowing = wasFollowing;
        _followersCount += wasFollowing ? 1 : -1;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar with user photo
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.surface,
                    backgroundImage: _displayPhoto != null
                        ? NetworkImage(_displayPhoto!)
                        : null,
                    child: _displayPhoto == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.textSecondary,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),

          // User info section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Nickname
                  Text(
                    _displayNickname ?? 'Usuario',
                    style: AppTypography.title.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Edad y Género
                  if (_displayAge != null || _displayGender != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_displayAge != null) ...[
                          Icon(
                            Icons.cake,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_displayAge años',
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        if (_displayAge != null && _displayGender != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '•',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        if (_displayGender != null) ...[
                          Icon(
                            _displayGender?.toLowerCase() == 'masculino'
                                ? Icons.male
                                : _displayGender?.toLowerCase() == 'femenino'
                                ? Icons.female
                                : Icons.transgender,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _displayGender!,
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Follower stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatColumn('Posts', _userPosts.length),
                      const SizedBox(width: 24),
                      _buildStatColumn('Seguidores', _followersCount),
                      const SizedBox(width: 24),
                      _buildStatColumn('Siguiendo', _followingCount),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Follow button (solo si no es el perfil propio)
                  if (_currentUserId != null && _currentUserId != widget.userId)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _toggleFollow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFollowing
                              ? AppColors.surfaceVariant
                              : AppColors.primary,
                          foregroundColor: _isFollowing
                              ? AppColors.textPrimary
                              : AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _isFollowing ? 'Siguiendo' : 'Seguir',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Divider(color: AppColors.border),
                ],
              ),
            ),
          ),

          // Posts section title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Publicaciones',
                style: AppTypography.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // User's posts grid
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_userPosts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Este usuario aún no ha publicado nada',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final post = _userPosts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(post: post),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: post.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                post.image!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.textSecondary,
                              ),
                            ),
                    ),
                  );
                }, childCount: _userPosts.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
