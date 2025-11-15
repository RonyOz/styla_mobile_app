import 'package:styla_mobile_app/features/community/domain/model/comment.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class CreateCommentUsecase {
  final CommunityRepository _communityRepository;

  CreateCommentUsecase({required CommunityRepository communityRepository})
    : _communityRepository = communityRepository;

  Future<Comment> execute({
    required String postId,
    required String authorUserId,
    required String content,
  }) {
    return _communityRepository.createComment(
      postId: postId,
      authorUserId: authorUserId,
      content: content,
    );
  }
}
