import 'package:json_annotation/json_annotation.dart';

part 'response_status_model.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: true,
)
class ResponseStatusModel {
  @JsonKey(unknownEnumValue: ResponseCodeEnum.unknown)
  final ResponseCodeEnum responseCode;

  @JsonKey(name: 'message')
  final String enMessage;
  @JsonKey(name: 'description')
  final String enDescription;

  @JsonKey(name: 'messageForID')
  final String idMessage;

  @JsonKey(name: 'descriptionForID')
  final String idDescription;

  factory ResponseStatusModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseStatusModelFromJson(json);

  ResponseStatusModel(this.responseCode, this.enMessage, this.enDescription,
      this.idMessage, this.idDescription);

  Map<String, dynamic> toJson() => _$ResponseStatusModelToJson(this);

}

enum ResponseCodeEnum {
  @JsonValue('A00')
  success,
  @JsonValue('A02')
  paymentRequestReceived,
  @JsonValue('A14')
  invalidPIN,
  @JsonValue('S19')
  felloAccountNotFound,
  @JsonValue('A01')
  validPIN,
  @JsonValue('L17')
  sessionExpired,
  @JsonValue('C14')
  invalidOTP,
  @JsonValue('O01')
  otpLimitReached,
  @JsonValue('M14')
  memberNotFound,
  @JsonValue('M17')
  memberAlreadyRegister,
  @JsonValue('A91')
  differentDeviceLogin,
  @JsonValue('I34')
  billAlreadyPaid,
  @JsonValue('I14')
  billNotFound,
  @JsonValue('K02')
  kycPending,
  @JsonValue('I33')
  billerNotFound,
  @JsonValue('I55')
  billerSecurityFailure,
  @JsonValue('I77')
  invalidMeterId,
  @JsonValue('A18')
  accountBlocked,
  @JsonValue('A03')
  pending,
  @JsonValue('S84')
  noTransaction,
  @JsonValue('O02')
  otpRequestWait,
  @JsonValue('P14')
  invalidParamter,
  unknown
}
