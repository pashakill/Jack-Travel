import 'package:json_annotation/json_annotation.dart';

part 'api_base_request.g.dart';

@JsonSerializable(createFactory: false, createToJson: true)
class ApiBaseRequest {
  final String token;

  ApiBaseRequest(this.token);

  Map<String, dynamic> toJson() => _$ApiBaseRequestToJson(this);
}
