import 'package:json_annotation/json_annotation.dart';
import 'package:koobits_flutter_app/core/model/post/post_data.dart';

part 'post_data_response.g.dart';

@JsonSerializable()
class PostDataResponse {
  int userId;
  int id;
  String title;
  String body;

  PostDataResponse(this.userId, this.id, this.title, this.body);

  static PostDataResponse fromJson(Map<String, dynamic> json) =>
      _$PostDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostDataResponseToJson(this);

  PostData toModel() =>
      PostData(userId: userId, id: id, title: title, body: body);
}
