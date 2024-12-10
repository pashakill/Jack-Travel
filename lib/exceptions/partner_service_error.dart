import 'dart:io';

class PartnerServiceError extends HttpException {
  PartnerServiceError(super.message);

  @override
  toString() => 'partnerserviceerror';

}

