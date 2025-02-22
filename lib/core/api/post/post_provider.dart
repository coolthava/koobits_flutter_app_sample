import 'package:dio/dio.dart';
import 'package:koobits_flutter_app/core/api/i_api_provider.dart';
import 'package:koobits_flutter_app/core/api/post/i_post_provider.dart';
import 'package:koobits_flutter_app/core/api/post/model/post_data_response.dart';
import 'package:koobits_flutter_app/core/common/error/api_exception_handler.dart';

class PostProvider extends IApiProvider
    with ApiClientExceptionHandler
    implements IPostProvider {
  PostProvider(super.client);

  @override
  Future<List<PostDataResponse>> getPostData() async {
    try {
      var res = await client.get<List<dynamic>>('/posts');
      final response = res.data!
          .map((e) => PostDataResponse.fromJson(e as Map<String, dynamic>))
          .toList();

      return response;
    } on DioException catch (dioE) {
      throw apiExceptionHandler(dioE);
    } on Error catch (error) {
      throw apiExceptionHandler(Exception(error.toString()), error: error);
    } catch (_) {
      throw apiExceptionHandler(Exception());
    }
  }
}
