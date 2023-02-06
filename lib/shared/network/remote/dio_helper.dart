import 'package:dio/dio.dart';
import 'package:news_app/shared/components/constants.dart';

import '../local/cache_helper.dart';

class DioHelper {
  static Dio dio = Dio();
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData(
      {required String url,
      String lang = 'en',
      String? token,
      Map<String, dynamic>? query}) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': CacheHelper.getData(key: 'token'),
      'Content-Type': 'application/json',
    };
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData(
      {Map<String, dynamic>? query,
      String lang = 'en',
      String? token,
      required String url,
      required Map<String, dynamic> data}) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    return await dio.post(url, data: data);
  }

  static Future<Response> putData(
      {Map<String, dynamic>? query,
      String lang = 'en',
      String? token,
      required String url,
      required Map<String, dynamic> data}) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    return await dio.put(url, data: data, queryParameters: query);
  }
}
