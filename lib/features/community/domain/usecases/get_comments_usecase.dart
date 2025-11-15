import 'package:styla_mobile_app/features/community/domain/model/comment.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class GetCommentsUsecase {
  final CommunityRepository _communityRepository;

  GetCommentsUsecase({required CommunityRepository communityRepository})
    : _communityRepository = communityRepository;

  Future<List<Comment>> execute({required String postId}) {
    return _communityRepository.getComments(postId: postId);
  }
}
