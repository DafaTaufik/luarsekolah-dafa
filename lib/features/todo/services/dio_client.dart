import 'package:dio/dio.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://ls-lms.zoidify.my.id/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer default-token',
        },
      ),
    );

    // Interceptors for logging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          print('HEADERS: ${options.headers}');
          if (options.data != null) {
            print('DATA: ${options.data}');
          }
          if (options.queryParameters.isNotEmpty) {
            print('QUERY PARAMS: ${options.queryParameters}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          print('DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          // Log error
          print(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          print('ERROR MESSAGE: ${error.message}');
          if (error.response?.data != null) {
            print('ERROR DATA: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
  }
}
