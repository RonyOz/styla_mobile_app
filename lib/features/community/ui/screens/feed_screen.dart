import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/community_bloc.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/events/community_event.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/states/community_state.dart';
import 'package:styla_mobile_app/features/community/ui/screens/create_post_screen.dart';
import 'package:styla_mobile_app/features/community/ui/screens/saved_posts_screen.dart';
import 'package:styla_mobile_app/features/community/ui/screens/post_detail_screen.dart';
import 'package:styla_mobile_app/features/community/ui/widgets/comments_bottom_sheet.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:styla_mobile_app/features/profile/domain/usescases/who_am_i_usecase.dart';
import 'package:styla_mobile_app/features/profile/data/repository/profile_repository_impl.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final WhoAmIUsecase _whoAmIUsecase;
  final Map<String, bool> _savedStates = {};
  final Map<String, int> _likeCounts = {};
  final Map<String, bool> _likedPosts = {};
  final Map<String, bool> _likingPosts = {};

  @override
  void initState() {
    super.initState();
    _whoAmIUsecase = WhoAmIUsecase(profileRepository: ProfileRepositoryImpl());
    context.read<CommunityBloc>().add(LoadFeedRequested());
  }

  @override
  Widget build(BuildContext context) {
    const Color actionColor = Color(0xFFE5FF69);
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        cardTheme: CardTheme.of(context).copyWith( 
          color: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
        ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: actionColor,
        foregroundColor: Colors.black,
      ),
    ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Para Ti'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (newContext) => BlocProvider.value(
                      value: context.read<CommunityBloc>(),
                      child: const SavedPostsScreen(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<CommunityBloc, CommunityState>(
          listener: (context, state) {
            if (state is PostCreatedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post creado exitosamente')),
              );
              context.read<CommunityBloc>().add(LoadFeedRequested());
            }
            if (state is CommunityErrorState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is FeedLoadedState) {
              setState(() {
                for (final post in state.posts) {
                  _likeCounts[post.postId] = post.likesAmount;
                  _likedPosts.putIfAbsent(post.postId, () => false);
                  _likingPosts[post.postId] = false;
                }
              });
            }
            if (state is PostLikedState) {
              setState(() {
                _likingPosts[state.postId] = false;
              });
            }
          },
          buildWhen: (previous, current) {
            // Solo reconstruir cuando cambie el estado del feed
            return current is CommunityLoadingState ||
                current is FeedLoadedState ||
                current is CommunityIdleState;
          },
          builder: (context, state) {
            if (state is CommunityLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FeedLoadedState) {
              if (state.posts.isEmpty) {
                return const Center(
                  child: Text('No hay posts aún. ¡Sé el primero en publicar!'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<CommunityBloc>().add(LoadFeedRequested());
                },
                child: MasonryGridView.count(
                  padding: const EdgeInsets.all(12.0),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    final isSaved = _savedStates[post.postId] ?? false;
                    final isLiked = _likedPosts[post.postId] ?? false;
                    final likeCount =
                        _likeCounts[post.postId] ?? post.likesAmount;

                    return Card(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostDetailScreen(post: post),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 12, 4, 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundImage: post.authorPhoto != null
                                        ? NetworkImage(post.authorPhoto!)
                                        : null,
                                    child: post.authorPhoto == null
                                        ? const Icon(Icons.person, size: 16)
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.authorNickname ?? '@user',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          _formatDate(post.createdAt),
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                fontSize: 10,
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                                      size: 20,
                                      color: isSaved ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                    onPressed: () {
                                      final userId = _whoAmIUsecase.execute();
                                      if (isSaved) {
                                        context.read<CommunityBloc>().add(
                                              UnsavePostRequested(
                                                userId: userId,
                                                postId: post.postId,
                                              ),
                                            );
                                      } else {
                                        context.read<CommunityBloc>().add(
                                              SavePostRequested(
                                                userId: userId,
                                                postId: post.postId,
                                              ),
                                            );
                                      }
                                      setState(() {
                                        _savedStates[post.postId] = !isSaved;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            if (post.image != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0), 
                                child: Image.network(
                                  post.image!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (post.content != null)
                                    Text(
                                      post.content!,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 8),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              isLiked ? Icons.favorite : Icons.favorite_border,
                                              color: isLiked ? AppColors.error : AppColors.textSecondary,
                                              size: 20,
                                            ),
                                            onPressed: isLiked ||
                                                    (_likingPosts[post.postId] ?? false)
                                                ? null
                                                : () {
                                                    setState(() {
                                                      _likedPosts[post.postId] = true;
                                                      _likingPosts[post.postId] = true;
                                                      _likeCounts[post.postId] = likeCount + 1;
                                                    });
                                                    context.read<CommunityBloc>().add(
                                                          LikePostRequested(
                                                            postId: post.postId,
                                                          ),
                                                        );
                                                  },
                                          ),
                                          Text(
                                            '$likeCount',
                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12, 
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 16),

                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.chat_bubble_outline,
                                              color: AppColors.textSecondary,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              final communityBloc = context.read<CommunityBloc>();
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor: Colors.transparent,
                                                builder: (bottomSheetContext) => BlocProvider.value(
                                                  value: communityBloc,
                                                  child: CommentsBottomSheet(
                                                    postId: post.postId,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const Center(child: Text('Cargando feed...'));
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.border,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (newContext) => BlocProvider.value(
                      value: context.read<CommunityBloc>(),
                      child: const CreatePostScreen(),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) {
      return '${diff.inDays}d';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m';
    } else {
      return 'Ahora';
    }
  }
}
