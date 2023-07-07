import 'package:json_annotation/json_annotation.dart';
import 'package:koobits_flutter_app/core/api/post/model/post_data_response.dart';
import 'package:koobits_flutter_app/core/model/post/post_data_list.dart';

part 'post_data_response_list.g.dart';

@JsonSerializable()
class PostDataListResponse {
  List<PostDataResponse> responseList;

  PostDataListResponse(this.responseList);

  static PostDataListResponse fromJson(Map<String, dynamic> json) =>
      _$PostDataListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostDataListResponseToJson(this);

  PostDataList toModel() => PostDataList(
        responseList.map((data) => data.toModel()).toList(),
      );
}
