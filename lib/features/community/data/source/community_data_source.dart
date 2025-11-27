import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/features/community/domain/model/comment.dart';
import 'package:styla_mobile_app/features/community/domain/model/user_profile.dart';

class CommunityException implements Exception {
  final String message;
  CommunityException(this.message);

  @override
  String toString() => 'CommunityException: $message';
}

abstract class CommunityDataSource {
  Future<List<Outfit>> getOutfits();

  Future<Post> createPost({
    required String userId,
    required String outfitId,
    String? content,
  });

  Future<List<Post>> getFeedPosts();

  Future<void> savePost({required String userId, required String postId});

  Future<void> unsavePost({required String userId, required String postId});

  Future<List<Post>> getSavedPosts({required String userId});

  Future<bool> isPostSaved({required String userId, required String postId});

  // UC013 - Dar like a post
  Future<void> likePost({required String postId});

  // UC014 - Comentarios
  Future<List<Comment>> getComments({required String postId});

  Future<Comment> createComment({
    required String postId,
    required String authorUserId,
    required String content,
  });

  // UC016 & UC017 - Perfil de usuario y seguir/dejar de seguir
  Future<UserProfile> getUserProfile({required String userId});

  Future<List<Post>> getUserPosts({required String userId});

  Future<Map<String, int>> getUserStats({required String userId});

  Future<bool> isFollowing({
    required String followerUserId,
    required String followedUserId,
  });

  Future<void> followUser({
    required String followerUserId,
    required String followedUserId,
  });

  Future<void> unfollowUser({
    required String followerUserId,
    required String followedUserId,
  });

  Future<List<Outfit>> getRandomOutfits();
}

class CommunityDataSourceImpl extends CommunityDataSource {
  final SupabaseClient _supabaseClient;

  CommunityDataSourceImpl({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

@override
Future<List<Outfit>> getOutfits() async {
  try {
    final String? userId = _supabaseClient.auth.currentUser?.id;

    if (userId == null) {
      throw CommunityException('User not authenticated');
    }

    final response = await _supabaseClient
        .from('outfits')
        .select('outfit_id, name, description, created_at, users_user_id, prompts_prompt_id, image_url')
        .eq('users_user_id', userId);

    return response
        .map<Outfit>((json) => Outfit.fromJson(json))
        .toList();

  } catch (e) {
    throw CommunityException('Failed to fetch outfits: $e');
  }
}

  @override
  Future<Post> createPost({
    required String userId,
    required String outfitId,
    String? content,
  }) async {
    try {
      final response = await _supabaseClient
          .from('posts')
          .insert({
            'users_user_id': userId,
            'content': content,
            'outfit_id': outfitId,
            'createdat': DateTime.now().toIso8601String().split('T')[0],
          })
          .select('''
        *,
        profiles:users_user_id (
          nickname,
          photo
        ),
        outfits:outfit_id (
          image_url
        )
      ''')
          .single();

      return Post.fromJson({
        ...response,
        'author_nickname': response['profiles']?['nickname'],
        'author_photo': response['profiles']?['photo'],
        'image': response['outfits']?['image_url'],
      });
    } catch (e) {
      throw CommunityException('Failed to create post: ${e.toString()}');
    }
  }

  @override
  Future<List<Post>> getFeedPosts() async {
    try {
      final response = await _supabaseClient
          .from('posts')
          .select('''
            *,
            profiles:users_user_id (
              nickname,
              photo
            ),
            outfits:outfit_id (
              image_url
            )
          ''')
          .order('createdat', ascending: false);

      return (response as List).map((postData) {
        return Post.fromJson({
          ...postData,
          'author_nickname': postData['profiles']?['nickname'],
          'author_photo': postData['profiles']?['photo'],
          'image': postData['outfits']?['image_url'],
        });
      }).toList();
    } catch (e) {
      throw CommunityException('Failed to fetch feed: ${e.toString()}');
    }
  }

  @override
  Future<void> savePost({
    required String userId,
    required String postId,
  }) async {
    try {
      await _supabaseClient.from('saved_posts').insert({
        'user_id': userId,
        'post_id': postId,
      });
    } catch (e) {
      throw CommunityException('Failed to save post: ${e.toString()}');
    }
  }

  @override
  Future<void> unsavePost({
    required String userId,
    required String postId,
  }) async {
    try {
      await _supabaseClient
          .from('saved_posts')
          .delete()
          .eq('user_id', userId)
          .eq('post_id', postId);
    } catch (e) {
      throw CommunityException('Failed to unsave post: ${e.toString()}');
    }
  }

  @override
  Future<List<Post>> getSavedPosts({required String userId}) async {
    try {
      final response = await _supabaseClient
          .from('saved_posts')
          .select('''
            post_id,
            posts!inner (
              *,
              profiles:users_user_id (
                nickname,
                photo
              ),
              outfits:outfit_id (
                image_url
              )
            )
          ''')
          .eq('user_id', userId)
          .order('saved_at', ascending: false);

      return (response as List).map((savedData) {
        final postData = savedData['posts'];
        return Post.fromJson({
          ...postData,
          'author_nickname': postData['profiles']?['nickname'],
          'author_photo': postData['profiles']?['photo'],
          'image': postData['outfits']?['image_url'],
        });
      }).toList();
    } catch (e) {
      throw CommunityException('Failed to fetch saved posts: ${e.toString()}');
    }
  }

  @override
  Future<bool> isPostSaved({
    required String userId,
    required String postId,
  }) async {
    try {
      final response = await _supabaseClient
          .from('saved_posts')
          .select('id')
          .eq('user_id', userId)
          .eq('post_id', postId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw CommunityException('Failed to check saved status: ${e.toString()}');
    }
  }

  @override
  Future<void> likePost({required String postId}) async {
    try {
      // Incrementar likesAmount en 1
      await _supabaseClient.rpc(
        'increment_likes',
        params: {'post_id_param': postId},
      );
    } catch (e) {
      throw CommunityException('Failed to like post: ${e.toString()}');
    }
  }

  @override
  Future<List<Comment>> getComments({required String postId}) async {
    try {
      final response = await _supabaseClient
          .from('comments')
          .select('''
            *,
            profiles:author_user_id (
              nickname,
              photo
            )
          ''')
          .eq('post_id', postId)
          .order('createdat', ascending: true);

      return (response as List).map((commentData) {
        return Comment.fromJson({
          ...commentData,
          'author_nickname': commentData['profiles']?['nickname'],
          'author_photo': commentData['profiles']?['photo'],
        });
      }).toList();
    } catch (e) {
      throw CommunityException('Failed to fetch comments: ${e.toString()}');
    }
  }

  @override
  Future<Comment> createComment({
    required String postId,
    required String authorUserId,
    required String content,
  }) async {
    try {
      final response = await _supabaseClient
          .from('comments')
          .insert({
            'post_id': postId,
            'author_user_id': authorUserId,
            'content': content,
            'createdat': DateTime.now().toIso8601String(),
          })
          .select('''
        *,
        profiles:author_user_id (
          nickname,
          photo
        )
      ''')
          .single();

      return Comment.fromJson({
        ...response,
        'author_nickname': response['profiles']?['nickname'],
        'author_photo': response['profiles']?['photo'],
      });
    } catch (e) {
      throw CommunityException('Failed to create comment: ${e.toString()}');
    }
  }

  @override
  Future<UserProfile> getUserProfile({required String userId}) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select('user_id, nickname, photo, gender, age')
          .eq('user_id', userId)
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      throw CommunityException('Failed to fetch user profile: ${e.toString()}');
    }
  }

  @override
  Future<List<Post>> getUserPosts({required String userId}) async {
    try {
      final response = await _supabaseClient
          .from('posts')
          .select('''
            *,
            profiles:users_user_id (
              nickname,
              photo
            ),
            outfits:outfit_id (
              image_url
            )
          ''')
          .eq('users_user_id', userId)
          .order('createdat', ascending: false);

      return (response as List).map((postData) {
        return Post.fromJson({
          ...postData,
          'author_nickname': postData['profiles']?['nickname'],
          'author_photo': postData['profiles']?['photo'],
          'image': postData['outfits']?['image_url'],
        });
      }).toList();
    } catch (e) {
      throw CommunityException('Failed to fetch user posts: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getUserStats({required String userId}) async {
    try {
      final response = await _supabaseClient
          .rpc('get_user_stats', params: {'p_user_id': userId})
          .single();

      return {
        'posts': (response['posts_count'] as num?)?.toInt() ?? 0,
        'followers': (response['followers_count'] as num?)?.toInt() ?? 0,
        'following': (response['following_count'] as num?)?.toInt() ?? 0,
      };
    } catch (e) {
      throw CommunityException('Failed to fetch user stats: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFollowing({
    required String followerUserId,
    required String followedUserId,
  }) async {
    try {
      final response = await _supabaseClient
          .from('followers')
          .select('follower_user_id')
          .eq('follower_user_id', followerUserId)
          .eq('followed_user_id', followedUserId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw CommunityException(
        'Failed to check follow status: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> followUser({
    required String followerUserId,
    required String followedUserId,
  }) async {
    try {
      await _supabaseClient.from('followers').insert({
        'follower_user_id': followerUserId,
        'followed_user_id': followedUserId,
      });
    } catch (e) {
      throw CommunityException('Failed to follow user: ${e.toString()}');
    }
  }

  @override
  Future<void> unfollowUser({
    required String followerUserId,
    required String followedUserId,
  }) async {
    try {
      await _supabaseClient
          .from('followers')
          .delete()
          .eq('follower_user_id', followerUserId)
          .eq('followed_user_id', followedUserId);
    } catch (e) {
      throw CommunityException('Failed to unfollow user: ${e.toString()}');
    }
  }

  @override
  Future<List<Outfit>> getRandomOutfits() async {
    try {
      // Obtener 4 outfits aleatorios de la tabla outfit
      final response = await _supabaseClient
          .from('outfits') // Cambiado de 'outfits' a 'outfit'
          .select()
          .limit(100); // Primero obtenemos hasta 100 registros

      if (response.isEmpty) {
        return [];
      }

      // Mezclar aleatoriamente y tomar solo 4
      final outfits = (response as List)
          .map((json) => Outfit.fromJson(json))
          .toList();

      outfits.shuffle(); // Mezclar aleatoriamente

      // Retornar máximo 4 outfits
      return outfits.take(4).toList();
    } catch (e) {
      print('Error fetching random outfits: $e');
      throw CommunityException(
        'Failed to fetch random outfits: ${e.toString()}',
      );
    }
  }
}
