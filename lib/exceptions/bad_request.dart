import 'dart:io';

class BadRequest extends HttpException {
  BadRequest(super.message);

  @override
  toString() => 'badrequest';
}
