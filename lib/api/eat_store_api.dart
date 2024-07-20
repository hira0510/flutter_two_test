import 'package:dio/dio.dart';

class ApiService {
  static ApiService? _instance;
  static Dio? _dio;

  static ApiService getInstance() {
    if (_instance == null) {
      _instance = ApiService();
      _initDio();
      return _instance!;
    }
    return _instance!;
  }

  static void _initDio() {
    if (_dio == null) {
      Map<String, dynamic> headers = {
        "Content-Type": "application/json;charset=UTF-8",
      };

      _dio = Dio(BaseOptions(
          headers: headers,
          connectTimeout: 30000,
          receiveTimeout: 30000,
          responseType: ResponseType.plain
      ));
    }
  }

  Future<Response> getHttp(String  url) async {
      var response = await _dio!.get(url);
      return response;
  }
}
