import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Guda 재시도 인테셉터 — 네트워크 불안정 시 자동 재시도 수행
/// (Anti-Gravity Rule 3.2 준수)
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryInterval = const Duration(seconds: 2),
  });

  final Dio dio;
  final int maxRetries;
  final Duration retryInterval;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    var attempt = 0;
    
    // 재시도 대상 에러 여부 판별
    if (_shouldRetry(err)) {
      while (attempt < maxRetries) {
        attempt++;
        debugPrint('[Retry] HTTP 요청 재시도 중... (시도 $attempt/$maxRetries)');
        
        try {
          // 일정 시간 대기 후 재시도
          await Future.delayed(retryInterval);
          
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          if (attempt >= maxRetries || !_shouldRetry(e)) {
            return handler.next(e);
          }
        }
      }
    }
    
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // 타임아웃 또는 네트워크 연결 오류 시에만 재시도
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           (err.error is SocketException);
  }
}
