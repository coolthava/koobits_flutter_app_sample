import 'package:dartz/dartz.dart';
import 'package:koobits_flutter_app/core/api/post/i_post_provider.dart';
import 'package:koobits_flutter_app/core/model/post/post_data.dart';
import 'package:koobits_flutter_app/core/repository/postdata/i_post_repository.dart';

class PostRepository implements IPostRepository {
  final IPostProvider postProvider;

  PostRepository(this.postProvider);

  @override
  Future<Either<Exception, List<PostData>>> getPostData() async {
    /// improvements are to
    /// 1) create network utils to check internet connectivity before making API call
    /// 2) add retry mechanism

    try {
      final postResponse = await postProvider.getPostData();
      var postData = postResponse.map((r) => r.toModel()).toList();
      return Right(postData);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
