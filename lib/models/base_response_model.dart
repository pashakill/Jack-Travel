
import 'package:json_annotation/json_annotation.dart';

part 'base_response_model.g.dart';

@JsonSerializable(createFactory: true, createToJson: false)
class BaseResponseModel {
  final String? token;

  BaseResponseModel(this.token);

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) => 
    _$BaseResponseModelFromJson(json);

}