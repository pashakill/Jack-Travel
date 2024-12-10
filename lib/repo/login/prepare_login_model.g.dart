// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prepare_login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrepareLoginModel _$PrepareLoginModelFromJson(Map<String, dynamic> json) =>
    PrepareLoginModel(
      userName: json['userName'] as String?,
      pin: json['pin'] as String?,
      fcmId: json['fcmId'] as String?,
    );

Map<String, dynamic> _$PrepareLoginModelToJson(PrepareLoginModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'pin': instance.pin,
      'fcmId': instance.fcmId,
    };
