import 'dart:io';

class Unauthorized extends HttpException {
  Unauthorized(super.message);
  @override
  toString() => 'unauthorized';
}
