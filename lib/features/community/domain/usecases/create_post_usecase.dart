import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class CreatePostUsecase {
  final CommunityRepository _communityRepository;

  CreatePostUsecase({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  Future<Post> execute({
    required String userId,
    required String outfitId,
    String? content,
  }) {
    return _communityRepository.createPost(
      userId: userId,
      outfitId: outfitId,
      content: content,
    );
  }
}
