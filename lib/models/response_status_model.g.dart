// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseStatusModel _$ResponseStatusModelFromJson(Map<String, dynamic> json) =>
    ResponseStatusModel(
      $enumDecode(_$ResponseCodeEnumEnumMap, json['responseCode'],
          unknownValue: ResponseCodeEnum.unknown),
      json['message'] as String,
      json['description'] as String,
      json['messageForID'] as String,
      json['descriptionForID'] as String,
    );

Map<String, dynamic> _$ResponseStatusModelToJson(
    ResponseStatusModel instance) =>
    <String, dynamic>{
      'responseCode': _$ResponseCodeEnumEnumMap[instance.responseCode],
      'message': instance.enMessage,
      'description': instance.enDescription,
      'messageForID': instance.idMessage,
      'descriptionForID': instance.idDescription,
    };

const _$ResponseCodeEnumEnumMap = {
  ResponseCodeEnum.success: 'A00',
  ResponseCodeEnum.paymentRequestReceived: 'A02',
  ResponseCodeEnum.invalidPIN: 'A14',
  ResponseCodeEnum.felloAccountNotFound: 'S19',
  ResponseCodeEnum.validPIN: 'A01',
  ResponseCodeEnum.sessionExpired: 'L17',
  ResponseCodeEnum.invalidOTP: 'C14',
  ResponseCodeEnum.otpLimitReached: 'O01',
  ResponseCodeEnum.memberNotFound: 'M14',
  ResponseCodeEnum.memberAlreadyRegister: 'M17',
  ResponseCodeEnum.differentDeviceLogin: 'A91',
  ResponseCodeEnum.billAlreadyPaid: 'I34',
  ResponseCodeEnum.billNotFound: 'I14',
  ResponseCodeEnum.kycPending: 'K02',
  ResponseCodeEnum.billerNotFound: 'I33',
  ResponseCodeEnum.billerSecurityFailure: 'I55',
  ResponseCodeEnum.invalidMeterId: 'I77',
  ResponseCodeEnum.accountBlocked: 'A18',
  ResponseCodeEnum.pending: 'A03',
  ResponseCodeEnum.noTransaction: 'S84',
  ResponseCodeEnum.otpRequestWait: 'O02',
  ResponseCodeEnum.invalidParamter: 'P14',
  ResponseCodeEnum.unknown: 'unknown',
};
