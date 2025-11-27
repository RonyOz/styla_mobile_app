import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/events/community_event.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/states/community_state.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';
import 'package:styla_mobile_app/features/community/data/repository/community_repository_impl.dart';
import 'package:styla_mobile_app/features/community/domain/usecases/usecases.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CommunityRepository _communityRepository;
  late final CreatePostUsecase _createPostUsecase;
  late final GetFeedUsecase _getFeedUsecase;
  late final SavePostUsecase _savePostUsecase;
  late final UnsavePostUsecase _unsavePostUsecase;
  late final GetSavedPostsUsecase _getSavedPostsUsecase;
  late final LikePostUsecase _likePostUsecase;
  late final GetCommentsUsecase _getCommentsUsecase;
  late final CreateCommentUsecase _createCommentUsecase;

  CommunityBloc({CommunityRepository? communityRepository})
    : _communityRepository = communityRepository ?? CommunityRepositoryImpl(),
      super(CommunityIdleState()) {
    _createPostUsecase = CreatePostUsecase(
      communityRepository: _communityRepository,
    );
    _getFeedUsecase = GetFeedUsecase(communityRepository: _communityRepository);
    _savePostUsecase = SavePostUsecase(
      communityRepository: _communityRepository,
    );
    _unsavePostUsecase = UnsavePostUsecase(
      communityRepository: _communityRepository,
    );
    _getSavedPostsUsecase = GetSavedPostsUsecase(
      communityRepository: _communityRepository,
    );
    _likePostUsecase = LikePostUsecase(
      communityRepository: _communityRepository,
    );
    _getCommentsUsecase = GetCommentsUsecase(
      communityRepository: _communityRepository,
    );
    _createCommentUsecase = CreateCommentUsecase(
      communityRepository: _communityRepository,
    );

    on<LoadFeedRequested>(_onLoadFeedRequested);
    on<CreatePostRequested>(_onCreatePostRequested);
    on<SavePostRequested>(_onSavePostRequested);
    on<UnsavePostRequested>(_onUnsavePostRequested);
    on<LoadSavedPostsRequested>(_onLoadSavedPostsRequested);
    on<LikePostRequested>(_onLikePostRequested);
    on<LoadCommentsRequested>(_onLoadCommentsRequested);
    on<CreateCommentRequested>(_onCreateCommentRequested);
    on<LoadOutfitsRequested>(_onLoadOutfitsRequested);
  }

  Future<void> _onLoadFeedRequested(
    LoadFeedRequested event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoadingState());
    try {
      final posts = await _getFeedUsecase.execute();
      emit(FeedLoadedState(posts: posts));
    } catch (e) {
      emit(CommunityErrorState(message: e.toString()));
    }
  }

  Future<void> _onCreatePostRequested(
    CreatePostRequested event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoadingState());
    try {
      final post = await _createPostUsecase.execute(
        userId: event.userId,
        outfitId: event.outfitId,
        content: event.content,
      );
      emit(PostCreatedState(post: post));
    } catch (e) {
      emit(CommunityErrorState(message: e.toString()));
    }
  }

  Future<void> _onSavePostRequested(
    SavePostRequested event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      await _savePostUsecase.execute(
        userId: event.userId,
        postId: event.postId,
      );
      emit(PostSavedState());
    } catch (e) {
      emit(CommunityErrorState(message: e.toString()));
    }
  }

  Future<void> _onUnsavePostRequested(
    UnsavePostRequested event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      await _unsavePostUsecase.execute(
        userId: event.userId,
        postId: event.postId,
      );
      emit(PostUnsavedState());
    } catch (e) {
      emit(CommunityErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadSavedPostsRequested(
    LoadSavedPostsRequested event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoadingState());
    try {
      final savedPosts = await _getSavedPostsUsecase.execute(
        userId: event.userId,
      );
      emit(SavedPostsLoadedState(savedPosts: savedPosts));
    } catch (e) {
      emit(CommunityErrorState(message: e.toString()));
    }
  }

  Future<void> _onLikePostRequested(
    LikePostRequested event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      await _likePostUsecase.execute(postId: event.postId);
      emit(PostLikedState(postId: event.postId));
      // Recargar el feed para reflejar el nuevo like
      add(LoadFeedRequested());
    } catch (e) {
      emit(CommunityErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadCommentsRequested(
    LoadCommentsRequested event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      final comments = await _getCommentsUsecase.execute(postId: event.postId);
      emit(CommentsLoadedState(comments: comments, postId: event.postId));
    } catch (e) {
      emit(CommunityErrorState(message: e.toString()));
    }
  }

  Future<void> _onCreateCommentRequested(
    CreateCommentRequested event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      await _createCommentUsecase.execute(
        postId: event.postId,
        authorUserId: event.authorUserId,
        content: event.content,
      );
      // No emitir CommentCreatedState para evitar interferir con el feed
      // Recargar comentarios directamente
      final comments = await _getCommentsUsecase.execute(postId: event.postId);
      emit(CommentsLoadedState(comments: comments, postId: event.postId));
    } catch (e) {
      emit(CommunityErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadOutfitsRequested(
    LoadOutfitsRequested event,
    Emitter<CommunityState> emit,
  ) async {
    emit(OutfitLoadingState());
    try {
      final outfits = await _communityRepository.getOutfits();
      emit(OutfitLoadedState(outfits: outfits));
    } catch (e) {
      emit(OutfitLoadErrorState(message: e.toString()));
    }
  }
}
