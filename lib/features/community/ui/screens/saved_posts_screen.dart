import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/community_bloc.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/events/community_event.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/states/community_state.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:styla_mobile_app/features/profile/domain/usescases/who_am_i_usecase.dart';
import 'package:styla_mobile_app/features/profile/data/repository/profile_repository_impl.dart';

class SavedPostsScreen extends StatefulWidget {
  const SavedPostsScreen({super.key});

  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  late final WhoAmIUsecase _whoAmIUsecase;

  @override
  void initState() {
    super.initState();
    _whoAmIUsecase = WhoAmIUsecase(profileRepository: ProfileRepositoryImpl());
    final userId = _whoAmIUsecase.execute();
    context.read<CommunityBloc>().add(LoadSavedPostsRequested(userId: userId));
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
          title: const Text('Guardados'),
        ),
        body: BlocBuilder<CommunityBloc, CommunityState>(
          builder: (context, state) {
            if (state is CommunityLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SavedPostsLoadedState) {
              if (state.savedPosts.isEmpty) {
                return const Center(
                  child: Text('No tienes posts guardados'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  final userId = _whoAmIUsecase.execute();
                  context.read<CommunityBloc>().add(LoadSavedPostsRequested(userId: userId));
                },
                child: MasonryGridView.count(
                  padding: const EdgeInsets.all(12.0),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  itemCount: state.savedPosts.length,
                  itemBuilder: (context, index) {
                    final post = state.savedPosts[index];
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.favorite_border),
                                const SizedBox(width: 4),
                                Text('${post.likesAmount} likes'),
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

            if (state is CommunityErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const Center(child: Text('Cargando...'));
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
