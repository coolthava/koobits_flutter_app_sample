import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koobits_flutter_app/core/model/post/post_data.dart';
import 'package:koobits_flutter_app/core/repository/postdata/i_post_repository.dart';
import 'package:koobits_flutter_app/presentation/bloc/post/post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit(this.postRepository) : super(InitialPostState());

  final IPostRepository postRepository;

  /// This storage pattern assumes text results from API are not rapidly changing
  @visibleForTesting
  List<PostData>? postData;

  @visibleForTesting
  String prevSearchedText = '';

  Future<void> getPostData() async {
    final either = await _getPostData();
    emit(
      either.fold(
        (_) {
          postData = null;
          return ErrorPostState();
        },
        (data) {
          postData = data;
          if (data.isEmpty) {
            return EmptyPostState();
          }
          return SuccessPostState(data);
        },
      ),
    );
  }

  Future<Either<Exception, List<PostData>>> _getPostData() async {
    if (postData != null) {
      return Right(postData!);
    }
    emit(LoadingPostState());

    /// Artificially delayed to show Loading state as API too fast
    return Future.delayed(
        const Duration(seconds: 2), () async => postRepository.getPostData());
  }

  void searchDataForText(String text) async {
    /// Error state excluded as search function parses through available _postData
    if (postData == null && state is! ErrorPostState) {
      await getPostData();
    }
    if (postData != null &&
        text.trimLeft().isNotEmpty &&
        text != prevSearchedText) {
      prevSearchedText = text;

      /// Simple search logic. Fuzzywuzzy package could be used for more options
      var searchList = postData!
          .where((element) =>
              element.title.contains(text) || element.body.contains(text))
          .toList();

      if (searchList.isEmpty) {
        return emit(EmptyPostState());
      }
      return emit(SuccessPostState(searchList));
    }
  }
}
