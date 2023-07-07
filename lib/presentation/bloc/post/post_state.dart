import 'package:equatable/equatable.dart';
import 'package:koobits_flutter_app/core/model/post/post_data.dart';

abstract class PostState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialPostState extends PostState {}

class LoadingPostState extends PostState {}

class ErrorPostState extends PostState {}

class SuccessPostState extends PostState {
  final List<PostData> postData;

  SuccessPostState(this.postData);

  @override
  List<Object> get props => [postData];
}

class EmptyPostState extends PostState {}
