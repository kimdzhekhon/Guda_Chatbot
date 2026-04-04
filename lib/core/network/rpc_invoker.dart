import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/app/config/app_config.dart';

/// RPC 호출의 공통 예외 클래스
class RpcException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  RpcException(this.message, {this.code, this.details});

  @override
  String toString() => '[RpcException] Code: $code, Message: $message';
}

/// 안티 그래비티 아키텍처용 범용 RPC 인보커 인터페이스
/// 모든 외부 통신(Supabase RPC, Edge Functions 등)은 이 인터페이스를 통해 수행됩니다.
abstract class RpcInvoker {
  /// 단일 RPC 호출 수행 (Request DTO -> Response DTO)
  Future<T> invoke<T>({
    required String functionName,
    Map<String, dynamic>? params,
    required T Function(Map<String, dynamic> json) fromJson,
  });

  /// 반환값이 없는 RPC 호출 수행 (Request DTO -> void)
  Future<void> invokeVoid({
    required String functionName,
    Map<String, dynamic>? params,
  });

  /// 목록 반환 RPC 호출 수행 (Request DTO → List Response DTO)
  Future<List<T>> invokeList<T>({
    required String functionName,
    Map<String, dynamic>? params,
    required T Function(Map<String, dynamic> json) fromJson,
  });

  /// 스트리밍 RPC 호출 수행 (Edge Functions 전용)
  Stream<String> invokeStream({
    required String functionName,
    Map<String, dynamic>? params,
  });
}

/// Supabase를 사용한 RpcInvoker 구현체
class SupabaseRpcInvoker implements RpcInvoker {
  SupabaseRpcInvoker() : _supabase = Supabase.instance.client;

  final SupabaseClient _supabase;
  static final _streamDio = Dio();

  @override
  Future<T> invoke<T>({
    required String functionName,
    Map<String, dynamic>? params,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    dynamic response;
    try {
      debugPrint('[RPC Call] $functionName with $params');
      response = await _supabase.rpc(functionName, params: params);

      if (response == null) {
         throw RpcException('RPC 응답이 비어있습니다.', code: 'EMPTY_RESPONSE');
      }

      // Supabase RPC는 함수 리턴 타입이 단일 행이라도 리스트로 감싸서 반환하는 경우가 많음
      final Map<String, dynamic> json;
      if (response is List) {
        if (response.isEmpty) {
          throw RpcException('RPC 결과 리스트가 비어있습니다.', code: 'EMPTY_LIST');
        }
        json = response.first as Map<String, dynamic>;
      } else if (response is Map<String, dynamic>) {
        json = response;
      } else {
        throw RpcException('알 수 없는 응답 형식입니다: ${response.runtimeType}', details: response);
      }

      return fromJson(json);
    } on PostgrestException catch (e) {
      debugPrint('[RPC Error] $e');
      throw RpcException(e.message, code: e.code, details: e.details);
    } catch (e) {
      debugPrint('[RPC Unhandled Error] $e');
      debugPrint('[RPC Raw Response Context] ${response.toString()}');
      throw RpcException('알 수 없는 통신 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> invokeVoid({
    required String functionName,
    Map<String, dynamic>? params,
  }) async {
    try {
      debugPrint('[RPC Void Call] $functionName with $params');
      await _supabase.rpc(functionName, params: params);
    } on PostgrestException catch (e) {
      debugPrint('[RPC Void Error] $e');
      throw RpcException(e.message, code: e.code, details: e.details);
    } catch (e) {
      debugPrint('[RPC Void Unhandled Error] $e');
      throw RpcException('알 수 없는 통신 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<List<T>> invokeList<T>({
    required String functionName,
    Map<String, dynamic>? params,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      debugPrint('[RPC List Call] $functionName with $params');
      final response = await _supabase.rpc(functionName, params: params);

      if (response == null) return [];

      return (response as List)
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      debugPrint('[RPC List Error] $e');
      throw RpcException(e.message, code: e.code, details: e.details);
    } catch (e) {
      debugPrint('[RPC List Unhandled Error] $e');
      throw RpcException('알 수 없는 통신 오류가 발생했습니다: $e');
    }
  }

  @override
  Stream<String> invokeStream({
    required String functionName,
    Map<String, dynamic>? params,
  }) async* {
    final stopwatch = Stopwatch()..start();
    try {
      debugPrint('[RPC Stream Call] Started: $functionName');

      final session = _supabase.auth.currentSession;
      final accessToken = session?.accessToken;
      final supabaseKey = AppConfig.supabaseAnonKey;

      final functionUrl = '${AppConfig.supabaseUrl}/functions/v1/$functionName';

      final response = await _streamDio.post<ResponseBody>(
        functionUrl,
        data: params ?? {},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? supabaseKey}',
            'apikey': supabaseKey,
          },
          responseType: ResponseType.stream,
        ),
      );

      if (response.statusCode != 200) {
        throw RpcException('스트리밍 호출 실패 (${response.statusCode})',
            code: response.statusCode.toString());
      }

      final lineBuffer = StringBuffer();
      final stream = response.data!.stream.cast<List<int>>().transform(utf8.decoder);
      await for (final chunk in stream) {
        lineBuffer.write(chunk);
        final lines = lineBuffer.toString().split('\n');

        lineBuffer.clear();
        if (!chunk.endsWith('\n')) {
          lineBuffer.write(lines.removeLast());
        }

        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;

          if (trimmed == 'data: [DONE]') {
            debugPrint('[RPC Stream Call] Completed in ${stopwatch.elapsedMilliseconds}ms');
            return;
          }

          if (trimmed.startsWith('data: ')) {
            try {
              final jsonStr = trimmed.substring(6);
              final data = jsonDecode(jsonStr) as Map<String, dynamic>;
              if (data.containsKey('text')) {
                yield data['text'] as String;
              }
            } catch (e) {
              debugPrint('[RPC Stream Parse Error] $e for line: $trimmed');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[RPC Stream Critical Error] $e');
      if (e is RpcException) rethrow;
      throw RpcException('스트리밍 중 오류 발생: $e');
    } finally {
      stopwatch.stop();
    }
  }
}
