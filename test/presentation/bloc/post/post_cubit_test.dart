import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koobits_flutter_app/presentation/bloc/post/post_cubit.dart';
import 'package:koobits_flutter_app/presentation/bloc/post/post_state.dart';
import 'package:mockito/mockito.dart';

import '../../../shared_mocks.mocks.dart';

void main() {
  group('PostCubitTest', () {
    late PostCubit postCubit;
    late MockIPostRepository postRepository;

    MockPostData postData1 = MockPostData();
    MockPostData postData2 = MockPostData();

    setUp(() {
      when(postData1.title).thenReturn('test1');
      when(postData2.title).thenReturn('cr2');
      when(postData1.body).thenReturn('test1');
      when(postData2.body).thenReturn('cr2');

      postRepository = MockIPostRepository();

      when(postRepository.getPostData())
          .thenAnswer((_) async => Right([postData1, postData2]));

      postCubit = PostCubit(postRepository);
    });

    test('initial State is InitialPostState', () {
      expect(postCubit.state, InitialPostState());
    });

    blocTest<PostCubit, PostState>(
        'getPostData calls sends SuccessPostState when api success',
        build: () {
          return postCubit;
        },
        act: (cubit) => cubit.getPostData(),
        expect: () => <PostState>[
              LoadingPostState(),
              SuccessPostState([postData1, postData2]),
            ],
        verify: (cubit) {
          expect(postCubit.postData, [postData1, postData2]);
        });

    blocTest<PostCubit, PostState>(
        'further getPostData calls after first success will get postData from storage',
        build: () {
          return postCubit;
        },
        act: (cubit) async {
          await cubit.getPostData();
          await cubit.getPostData();
          await cubit.getPostData();
        },
        expect: () => <PostState>[
              LoadingPostState(),
              SuccessPostState([postData1, postData2]),
            ],
        verify: (cubit) {
          expect(postCubit.postData, [postData1, postData2]);
          verify(postRepository.getPostData()).called(1);
        });

    blocTest<PostCubit, PostState>(
        'getPostData calls sends EmptyPostState when api success but empty',
        build: () {
          when(postRepository.getPostData())
              .thenAnswer((_) async => const Right([]));
          return postCubit;
        },
        act: (cubit) => cubit.getPostData(),
        expect: () => <PostState>[
              LoadingPostState(),
              EmptyPostState(),
            ],
        verify: (cubit) {
          expect(postCubit.postData, []);
        });

    blocTest<PostCubit, PostState>(
        'getPostData calls sends ErrorPostState when api fails',
        build: () {
          when(postRepository.getPostData())
              .thenAnswer((_) async => Left(Exception()));
          return postCubit;
        },
        act: (cubit) => cubit.getPostData(),
        expect: () => <PostState>[
              LoadingPostState(),
              ErrorPostState(),
            ],
        verify: (cubit) {
          expect(postCubit.postData, null);
        });

    blocTest<PostCubit, PostState>(
        'searchDataForText, if postData is null, will get values from API first before executing search',
        build: () {
          return postCubit;
        },
        act: (cubit) => cubit.searchDataForText('test'),
        expect: () => <PostState>[
              LoadingPostState(),
              SuccessPostState([postData1, postData2]),
              SuccessPostState([postData1]),
            ],
        verify: (cubit) {
          expect(postCubit.postData, [postData1, postData2]);
        });

    blocTest<PostCubit, PostState>(
        'searchDataForText, if postData is not null, will get values from storage before executing search',
        build: () {
          return postCubit;
        },
        act: (cubit) async {
          await cubit.getPostData();
          cubit.searchDataForText('test');
        },
        expect: () => <PostState>[
              LoadingPostState(),
              SuccessPostState([postData1, postData2]),
              SuccessPostState([postData1]),
            ],
        verify: (cubit) {
          expect(postCubit.postData, [postData1, postData2]);
        });

    blocTest<PostCubit, PostState>(
        'searchDataForText when text not empty, no the same as prevText and postData not null,'
        'will return SuccessPostState with filtered list',
        build: () {
          return postCubit;
        },
        act: (cubit) => cubit.searchDataForText('test'),
        expect: () => <PostState>[
              LoadingPostState(),
              SuccessPostState([postData1, postData2]),
              SuccessPostState([postData1]),
            ],
        verify: (cubit) {
          expect(postCubit.postData, [postData1, postData2]);
        });

    blocTest<PostCubit, PostState>(
        'searchDataForText when text not empty, no the same as prevText and postData not null,'
        'will return EmptyState if results empty',
        build: () {
          when(postRepository.getPostData())
              .thenAnswer((_) async => const Right([]));
          return postCubit;
        },
        act: (cubit) => cubit.searchDataForText('test'),
        expect: () => <PostState>[
              LoadingPostState(),
              EmptyPostState(),
            ],
        verify: (cubit) {
          expect(postCubit.postData, []);
        });
  });
}
