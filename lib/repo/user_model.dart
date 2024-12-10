import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(createFactory: true, createToJson: true)
class UserModel {
  final String? name;
  final String? msisdn;
  final int? groupId;
  final String? email;
  final bool? emailVerify;
  final String? token;
  final int? autoLogoutAt;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserModel(
      {this.name,
        this.msisdn,
        this.groupId,
        this.email,
        this.emailVerify,
        // this.fcmId,
        this.token,
        this.autoLogoutAt});

  static UserModel fromApiValue(UserModel data) {
    return UserModel(
        name: data.name,
        email: data.email,
        emailVerify: data.emailVerify,
        msisdn: data.msisdn,
        token: data.token
    );
  }

  static UserModel fromValues({
    String? name,
    String? msisdn,
    int? groupId,
    String? email,
    bool? emailVerify,
    String? token,
    int? autoLogoutAt,
  }) {
    return UserModel(
      name: name,
      msisdn: msisdn,
      groupId: groupId,
      email: email,
      emailVerify: emailVerify,
      token: token,
      autoLogoutAt: autoLogoutAt,
    );
  }

  static UserModel copy(UserModel src,
      {String? name,
        String? email,
        bool? emailVerify,
        // String? fcmId,
        int? groupId,
        String? msisdn,
        String? token,
        int? autoLogoutAt}) {
    return UserModel(
        name: name ?? src.name,
        email: email ?? src.email,
        emailVerify: emailVerify ?? src.emailVerify,
        // fcmId: fcmId ?? src.fcmId,
        groupId: groupId ?? src.groupId,
        msisdn: msisdn ?? src.msisdn,
        token: token ?? src.token,
        autoLogoutAt: autoLogoutAt ?? src.autoLogoutAt);
  }
}
