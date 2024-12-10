// import 'package:dio/adapter_browser.dart';
import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dio_adapter_skeleton.dart';

class DioAdapter extends DioAdapterSkeleton {

  final Map<String, String>? headers;

  DioAdapter({this.headers});

  @override
  Future<Dio> dio() async {
    headers!['Channel'] = 'web';
    headers!['Language'] = await getUserLanguage();

    int connectionTimeout =  int.tryParse(dotenv.env['httpconnectiontimeoutms'] ?? '30000') ?? 30000 ;
    int receiveTimeout =  int.tryParse(dotenv.env['httpreceivetimeoutms'] ?? '30000') ?? 30000 ;

    BaseOptions options = BaseOptions(
      connectTimeout: Duration(milliseconds: connectionTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      headers: headers
    );


    var dio = Dio(options);
    var adapter = BrowserHttpClientAdapter();
    adapter.withCredentials = true;
    dio.httpClientAdapter = adapter;
    return dio;    
  }

  @override
  void setCookie(String? cookie) {
    // TODO: implement setCookie
  }
}