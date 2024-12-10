import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import '../adapters/dio_web_adapter.dart'
if (dart.library.io) '../adapters/dio_native_adapter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../exceptions/exceptions.dart';
import '../models/models.dart';
import 'security_helper.dart';

class NetworkHelper {
  final String appVersion;
  final String apiVersion;
  final String apiKey;
  final String? tenantId;
  final String hmacKey;
  final String baseUrl;
  final String? environment;
  VoidCallback? _noNetworkCallback;
  VoidCallback? _sessionExpiredCallback;
  VoidCallback? _networkTimeOutCallback;
  String _ac201fd270c3b96beab24f2829780ab2 = '';
  String _711817bec723df45dfc2d8 = '';
  late CacheOptions cacheOptions;

  NetworkHelper(
      {
        required this.appVersion,
      required this.apiVersion,
      required this.apiKey,
      this.tenantId,
      required this.hmacKey,
      this.environment,
      required this.baseUrl});

  Future<Map<String, String>> _requestHeaders(
      {required String apiSignature}) async {
    Map<String, String> headers = <String, String>{};
    headers['Cache-Control'] = 'no-cache';
    headers['Accept'] = 'application/json';
    headers['Content-Type'] = 'application/json; charset=utf-8';
    headers['Content-Encoding'] = 'application/gzip';
    // headers['Accept-Encoding'] = 'application/gzip';
    headers['appVersion'] = appVersion;
    headers['apiVersion'] = apiVersion;
    headers['Access-Control-Allow-Credentials'] = 'true';
    headers['Tenant-Id'] = tenantId ?? apiKey;
    headers['X-Ca-Key'] = apiKey;
    headers['X-Ca-Signature'] = apiSignature;
    if (environment != null) {
      headers['Environment'] = environment!;
    }

    cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.noCache,
      hitCacheOnErrorExcept: [],
    );

    _ac201fd270c3b96beab24f2829780ab2 = SecurityHelper.openString(
        const String.fromEnvironment('ac201fd270c3b96beab24f2829780ab2'));

    _711817bec723df45dfc2d8 = SecurityHelper.openString(
        const String.fromEnvironment('bb6c406f3376f8e8fe999116abd69a9990c04b72')
    );
    return headers;
  }

  set setNoNetworkCallback(VoidCallback cb) {
    _noNetworkCallback = cb;
  }

  set setSessionExpiredCallback(VoidCallback cb) {
    _sessionExpiredCallback = cb;
  }

  set setNetworkTimeOutCallback(VoidCallback cb) {
    _networkTimeOutCallback = cb;
  }

  String _generateApiSignature({required String method, required Uri uri}) {
    var text = _generateCompotitionKey(method, uri);
    return SecurityHelper().hmacSha256Signature(text, hmacKey);
    // var plainKey = utf8.encode(text);
    // var hmac = Hmac(sha256, utf8.encode(hmacKey));
    // var digest = hmac.convert(plainKey);
    // return base64Encode(digest.bytes);
  }

  String _generateCompotitionKey(String method, Uri uri) {
    return '$method\napplication/json\n\napplication/json; charset=utf-8\n\n${uri.path}';
  }

  String _generateApiRequestSignature({Map<String, dynamic>? body}) {
    if (_ac201fd270c3b96beab24f2829780ab2.isEmpty ||
        body == null ||
        body.isEmpty) {
      return '';
    }
    String jsonBody = jsonEncode(body);
    var result = SecurityHelper().hmacSha256Signature(
        jsonBody.toLowerCase().replaceAll(RegExp(r'\s'), ''),
        _ac201fd270c3b96beab24f2829780ab2);
    return result;
  }

  Future<Response> post(Uri uri,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParams,
      bool withCredentials = true}) async {
    String apiSignature = _generateApiSignature(method: "POST", uri: uri);

    Map<String, String> headers =
        await _requestHeaders(apiSignature: apiSignature);
    headers.addAll({
      'ac201fd270c3b96beab24f2829780ab2':
          _generateApiRequestSignature(body: body)
    });
    Dio client = await DioAdapter(headers: headers).dio();
    client.interceptors.add(CertificatePinningInterceptor(allowedSHAFingerprints : [_711817bec723df45dfc2d8]));
    client.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    if (!kReleaseMode) {
      client.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ));
    }

    var responseJson;
    // try {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print('no network');
      if (_noNetworkCallback != null) {
        _noNetworkCallback!();
      }
      throw NoNetwork('Unauthorized');
    }

    final response = await client
        .post('${uri.origin}${uri.path}',
            options: Options(
              headers: headers,
            ),
            data: jsonEncode(body),
            queryParameters: queryParams)
        .onError((error, stackTrace) {
      if (error is DioException) {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          if (_networkTimeOutCallback != null) {
            _networkTimeOutCallback!();
          }
          throw TimeoutException('TimeoutException');
        }
        return _response(error.response);
      }
      responseJson = Response(
          statusMessage: 'Error at ${uri.path}',
          statusCode: 555,
          requestOptions: RequestOptions(path: uri.path));
      return responseJson;
    }).whenComplete(() {
      client.close();
    });
    responseJson = _response(response);
    return responseJson;
  }

  Future<Response> get(Uri uri,
      {Map<String, dynamic>? queryParams, bool withCredentials = true}) async {
    String apiSignature = _generateApiSignature(method: "GET", uri: uri);
    Map<String, String> headers =
        await _requestHeaders(apiSignature: apiSignature);
    Dio client = await DioAdapter(headers: headers).dio();
    client.interceptors.add(CertificatePinningInterceptor(allowedSHAFingerprints : [_711817bec723df45dfc2d8]));
    client.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    if (!kReleaseMode) {
      client.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ));
    }

    var responseJson;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print('no network');
      if (_noNetworkCallback != null) {
        _noNetworkCallback!();
      }
      throw NoNetwork('NoNetwork');
    }

    final response = await client
        .get('${uri.origin}${uri.path}',
            options: Options(
              headers: headers,
            ),
            queryParameters: queryParams)
        .onError((error, stackTrace) {
      if (error is DioException) {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          if (_networkTimeOutCallback != null) {
            _networkTimeOutCallback!();
          }

          throw TimeoutException('RequestTimeout');
        }
        return _response(error.response);
      }
      responseJson = Response(
          statusMessage: 'Error at ${uri.path}',
          statusCode: 555,
          requestOptions: RequestOptions(path: uri.path));
      return responseJson;
    }).whenComplete(() {
      client.close();
    });
    responseJson = _response(response);

    return responseJson;
  }

  dynamic _response(Response? response) {
    if (response == null) {
      throw NullResponse('NullResponse');
    }
    switch (response.statusCode) {
      case 200:
        DioAdapter().setCookie(response.headers['Set-Cookie'].toString());
        return response;

      case 201:
        if (kDebugMode) {
          print('Created');
        }
        DioAdapter().setCookie(response.headers['Set-Cookie'].toString());
        return response;
      case 400:
        if (kDebugMode) {
          print('Bad Request');
        }

        if (response.data is Map) {
          var br = ApiBaseResponse.fromJson(response.data);
          if (br.status != null) {
            var ce = CustomException('BadRequest',
                responseCode: br.status?.responseCode,
                backendDescription: Intl.getCurrentLocale() == 'id'
                    ? br.status?.idDescription.replaceAll('_', ' ')
                    : br.status?.enDescription.replaceAll('_', ' '),
                backendMessage: Intl.getCurrentLocale() == 'id'
                    ? br.status?.idMessage.replaceAll('_', ' ')
                    : br.status?.enMessage.replaceAll('_', ' '));

            if (ce.responseCode == ResponseCodeEnum.sessionExpired &&
                _sessionExpiredCallback != null) {
              _sessionExpiredCallback!();
            }
            throw ce;
          }
        }
        throw BadRequest('BadRequest');
      case 401:
      case 440:
        if (kDebugMode) {
          print('Unauthorized Request');
        }
        if (response.data is Map) {
          var br = ApiBaseResponse.fromJson(response.data);
          if (br.status != null) {
            var ce = CustomException('Unauthorized',
                responseCode: br.status?.responseCode,
                backendDescription: Intl.getCurrentLocale() == 'id'
                    ? br.status?.idDescription.replaceAll('_', ' ')
                    : br.status?.enDescription.replaceAll('_', ' '),
                backendMessage: Intl.getCurrentLocale() == 'id'
                    ? br.status?.idMessage.replaceAll('_', ' ')
                    : br.status?.enMessage.replaceAll('_', ' '));

            if (ce.responseCode == ResponseCodeEnum.sessionExpired &&
                _sessionExpiredCallback != null) {
              _sessionExpiredCallback!();
            }
            throw ce;
          }
        }
        throw Unauthorized('Unauthorized');
      case 403:
        if (kDebugMode) {
          print('Forbidden');
        }
        if (response.data is Map) {
          var br = ApiBaseResponse.fromJson(response.data);
          if (br.status != null) {
            var ce = CustomException('Forbidden',
                responseCode: br.status?.responseCode,
                backendDescription: Intl.getCurrentLocale() == 'id'
                    ? br.status?.idDescription.replaceAll('_', ' ')
                    : br.status?.enDescription.replaceAll('_', ' '),
                backendMessage: Intl.getCurrentLocale() == 'id'
                    ? br.status?.idMessage.replaceAll('_', ' ')
                    : br.status?.enMessage.replaceAll('_', ' '));

            throw ce;
          }
        }
        throw Forbidden('Forbidden');
      case 498:
        if (_sessionExpiredCallback != null) {
          _sessionExpiredCallback!();
        }
        throw Forbidden('Forbidden');
      // break;
      case 404:
        if (kDebugMode) {
          print('Not Found');
        }

        if (response.data is Map) {
          var br = ApiBaseResponse.fromJson(response.data);
          if (br.status != null) {
            var ce = CustomException('NotFound',
                responseCode: br.status?.responseCode,
                backendDescription: Intl.getCurrentLocale() == 'id'
                    ? br.status?.idDescription.replaceAll('_', ' ')
                    : br.status?.enDescription.replaceAll('_', ' '),
                backendMessage: Intl.getCurrentLocale() == 'id'
                    ? br.status?.idMessage.replaceAll('_', ' ')
                    : br.status?.enMessage.replaceAll('_', ' '));

            throw ce;
          }
        }

        throw NotFound('NotFound');
      case 408:
        if (_networkTimeOutCallback != null) {
          _networkTimeOutCallback!();
        }
        throw RequestTimeout('RequestTimeout');
      case 500:
        if (kDebugMode) {
          print('Server Error');
        }
        throw InternalServerError('InternalServerError');
      case 503:
        if (kDebugMode) {
          print('ServiceUnavailable');
        }
        throw ServiceUnavailable('ServiceUnavailable');
      case 502:
        throw BadGateway("BadGateway");
      case 504:
        if (_networkTimeOutCallback != null) {
          _networkTimeOutCallback!();
        }
        throw ApiGatewayTimeout("ApiGatewayTimeout");
      case 524:
        if (_networkTimeOutCallback != null) {
          _networkTimeOutCallback!();
        }
        throw GatewayTimeout("Gateway Timeout");
      case 550:
        throw PartnerServiceError("Partner Service Error");
      default:
        throw UnknownError('UnknownError (${response.statusCode})');
    }
  }

  String getBaseUrl() {
    return baseUrl;
  }
}
