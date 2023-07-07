import 'package:koobits_flutter_app/core/api/post/i_post_provider.dart';
import 'package:koobits_flutter_app/core/api/post/model/post_data_response.dart';
import 'package:koobits_flutter_app/core/model/post/post_data.dart';
import 'package:koobits_flutter_app/core/repository/postdata/i_post_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  PostData,
  PostDataResponse,
], customMocks: [
  MockSpec<IPostProvider>(onMissingStub: null),
  MockSpec<IPostRepository>(onMissingStub: null),
])
void main() {}
