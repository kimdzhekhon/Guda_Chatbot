import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/core/network/retry_interceptor.dart';

/// Guda 인증 인터셉터 — 모든 요청에 Supabase 세션 토큰 자동 첨부
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    handler.next(options);
  }
}

/// Guda 로깅 인터셉터 — 개발 환경 API 요청/응답 로깅
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('[HTTP] ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('[HTTP Error] ${err.response?.statusCode} ${err.message}');
    handler.next(err);
  }
}

/// DioClient — Guda 앱 단일 Dio 클라이언트
/// 모든 외부 HTTP 통신은 이 클라이언트를 통해 수행
class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();

  late final Dio _dio;

  /// 클라이언트 초기화 (앱 부트스트랩 시 1회 호출)
  void initialize({required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      RetryInterceptor(dio: _dio),
      LoggingInterceptor(),
    ]);
  }

  Dio get dio => _dio;
}
