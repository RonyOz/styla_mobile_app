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

  CommunityBloc({CommunityRepository? communityRepository})
      : _communityRepository =
            communityRepository ?? CommunityRepositoryImpl(),
        super(CommunityIdleState()) {
    _createPostUsecase =
        CreatePostUsecase(communityRepository: _communityRepository);
    _getFeedUsecase = GetFeedUsecase(communityRepository: _communityRepository);
    _savePostUsecase = SavePostUsecase(communityRepository: _communityRepository);
    _unsavePostUsecase = UnsavePostUsecase(communityRepository: _communityRepository);
    _getSavedPostsUsecase = GetSavedPostsUsecase(communityRepository: _communityRepository);

    on<LoadFeedRequested>(_onLoadFeedRequested);
    on<CreatePostRequested>(_onCreatePostRequested);
    on<SavePostRequested>(_onSavePostRequested);
    on<UnsavePostRequested>(_onUnsavePostRequested);
    on<LoadSavedPostsRequested>(_onLoadSavedPostsRequested);
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
      await _savePostUsecase.execute(userId: event.userId, postId: event.postId);
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
      await _unsavePostUsecase.execute(userId: event.userId, postId: event.postId);
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
      final savedPosts = await _getSavedPostsUsecase.execute(userId: event.userId);
      emit(SavedPostsLoadedState(savedPosts: savedPosts));
    } catch (e) {
      emit(CommunityErrorState(message: e.toString()));
    }
  }
}
