import 'package:koobits_flutter_app/core/api/post/model/post_data_response.dart';

abstract class IPostProvider {
  Future<List<PostDataResponse>> getPostData();
}