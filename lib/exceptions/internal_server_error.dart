import 'dart:io';

class InternalServerError extends HttpException {
  InternalServerError(super.message);
}