import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/community_bloc.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/events/community_event.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/states/community_state.dart';
import 'package:styla_mobile_app/features/community/ui/screens/create_post_screen.dart';
import 'package:styla_mobile_app/features/community/ui/screens/saved_posts_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _whoAmIUsecase = WhoAmIUsecase(profileRepository: ProfileRepositoryImpl());
    context.read<CommunityBloc>().add(LoadFeedRequested());
  }

  @override
  Widget build(BuildContext context) {
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
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
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

                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: post.authorPhoto != null
                                  ? NetworkImage(post.authorPhoto!)
                                  : null,
                              child: post.authorPhoto == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(post.authorNickname ?? 'Usuario'),
                            subtitle: Text(
                              _formatDate(post.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: isSaved ? AppColors.primary : null,
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
                          ),
                          if (post.image != null)
                            Image.network(
                              post.image!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          if (post.content != null)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(post.content!),
                            ),
                          // Actions: Likes y Comentarios
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              children: [
                                // Like button
                                IconButton(
                                  icon: const Icon(Icons.favorite_border),
                                  color: AppColors.error,
                                  onPressed: () {
                                    context.read<CommunityBloc>().add(
                                      LikePostRequested(postId: post.postId),
                                    );
                                  },
                                ),
                                Text('${post.likesAmount}'),
                                const SizedBox(width: 16),
                                // Comment button
                                IconButton(
                                  icon: const Icon(Icons.chat_bubble_outline),
                                  color: AppColors.primary,
                                  onPressed: () {
                                    final communityBloc = context
                                        .read<CommunityBloc>();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (bottomSheetContext) =>
                                          BlocProvider.value(
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
                          ),
                        ],
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
