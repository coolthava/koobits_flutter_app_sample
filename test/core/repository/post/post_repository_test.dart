import 'package:flutter_test/flutter_test.dart';
import 'package:koobits_flutter_app/core/api/post/model/post_data_response.dart';
import 'package:koobits_flutter_app/core/repository/postdata/i_post_repository.dart';
import 'package:koobits_flutter_app/core/repository/postdata/post_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../shared_mocks.mocks.dart';

void main() {
  group('PostRepositoryTest', () {
    late IPostRepository postRepository;
    late MockIPostProvider postProvider;

    PostDataResponse postDataResponse1 =
        PostDataResponse(1, 3, 'test1', 'test1');
    PostDataResponse postDataResponse2 = PostDataResponse(2, 4, 'cr2', 'cr2');
    setUp(() {
      postProvider = MockIPostProvider();

      when(postProvider.getPostData())
          .thenAnswer((_) async => [postDataResponse1, postDataResponse2]);
      postRepository = PostRepository(postProvider);
    });

    test('return Right with data when api successful', () async {
      var newList = await postRepository.getPostData();
      expect(newList.isRight(), true);
      newList.mapWithIndex((i, r) =>
          r[i].userId == [postDataResponse1, postDataResponse2][i].userId);
    });

    test('return Left with Exception when api fails', () async {
      when(postProvider.getPostData()).thenThrow(Exception());
      var newList = await postRepository.getPostData();
      expect(newList.isLeft(), true);
    });
  });
}
