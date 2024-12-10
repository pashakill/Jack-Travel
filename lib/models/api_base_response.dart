import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'api_base_response.g.dart';

@JsonSerializable(createFactory: true, createToJson: true)
class ApiBaseResponse {
  final ResponseStatusModel? status;

  factory ApiBaseResponse.fromJson(Map<String, dynamic> json) =>
    _$ApiBaseResponseFromJson(json);

  ApiBaseResponse(this.status);

  Map<String, dynamic> toJson() => _$ApiBaseResponseToJson(this);

}