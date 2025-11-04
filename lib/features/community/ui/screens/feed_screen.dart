import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/community_bloc.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/events/community_event.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/states/community_state.dart';
import 'package:styla_mobile_app/features/community/ui/screens/create_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityBloc>().add(LoadFeedRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
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
              child: ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header del post
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
                        // Imagen del post
                        if (post.image != null)
                          Image.network(
                            post.image!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        // Contenido del post
                        if (post.content != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(post.content!),
                          ),
                        // Likes
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

          return const Center(child: Text('Cargando feed...'));
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
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
