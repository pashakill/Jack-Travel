import 'dart:io';

class RequestTimeout extends HttpException {
  RequestTimeout(super.message);

  @override
  toString() => 'requesttimeout';
}
