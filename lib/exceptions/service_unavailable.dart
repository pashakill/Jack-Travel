import 'dart:io';

class ServiceUnavailable extends HttpException {
  ServiceUnavailable(super.message);
}
