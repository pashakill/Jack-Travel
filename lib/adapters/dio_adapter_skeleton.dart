import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

 abstract class DioAdapterSkeleton {
  
  Future<Dio> dio();
  void setCookie(String? cookie);


  Future<String> getUserLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? language;
    try {
      language = pref.getString('languageUser');
    } catch (e) {
      // return 'id';
    }
    return language ?? 'id';
  }
}