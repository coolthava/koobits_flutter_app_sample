import 'package:dartz/dartz.dart';
import 'package:koobits_flutter_app/core/model/post/post_data.dart';

abstract class IPostRepository {
  Future<Either<Exception, List<PostData>>> getPostData();
}
