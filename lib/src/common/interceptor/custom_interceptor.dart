import 'package:dio/dio.dart';

class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Naver-Client-Id'] = 'obG9tY07CllOzlnt8s4K';
    options.headers['X-Naver-Client-Secret'] = '8JQqI09puZ';
    super.onRequest(options, handler);
  }
}
