import 'dart:io';

import '../models/models.dart';

class CustomException extends HttpException {
  CustomException(super.message,
      {this.backendMessage, this.backendDescription, this.responseCode});

  final ResponseCodeEnum? responseCode;
  final String? backendMessage;
  final String? backendDescription;

  @override
  toString() => 'customexception';
}
