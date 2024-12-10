// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String?,
      msisdn: json['msisdn'] as String?,
      groupId: json['groupId'] as int?,
      email: json['email'] as String?,
      emailVerify: json['emailVerify'] as bool?,
      // fcmId: json['fcmId'] as String?,
      token: json['token'] as String?,
      autoLogoutAt: json['autoLogoutAt'] as int?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'msisdn': instance.msisdn,
      'groupId': instance.groupId,
      'email': instance.email,
      'emailVerify': instance.emailVerify,
      // 'fcmId': instance.fcmId,
      'token': instance.token,
      'autoLogoutAt': instance.autoLogoutAt
    };
