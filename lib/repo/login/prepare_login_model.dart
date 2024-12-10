import 'package:json_annotation/json_annotation.dart';
part 'prepare_login_model.g.dart';

@JsonSerializable(createFactory: true, createToJson: true)
class PrepareLoginModel {
  final String? userName;
  final String? pin;
  final String? fcmId;

  PrepareLoginModel({this.userName, this.pin, this.fcmId});

  Map<String, dynamic> toJson() => _$PrepareLoginModelToJson(this);

  factory PrepareLoginModel.fromJson(Map<String, dynamic> json) =>
      _$PrepareLoginModelFromJson(json);
}
