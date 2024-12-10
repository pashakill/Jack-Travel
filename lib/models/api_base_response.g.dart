// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiBaseResponse _$ApiBaseResponseFromJson(Map<String, dynamic> json) =>
    ApiBaseResponse(
      json['status'] == null
          ? null
          : ResponseStatusModel.fromJson(
              json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiBaseResponseToJson(ApiBaseResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
    };
