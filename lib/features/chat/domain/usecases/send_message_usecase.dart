import 'package:flutter/foundation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/save_message_result.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';
import 'package:guda_chatbot/features/chat/domain/usecases/search_tripitaka_local_usecase.dart';

/// 메시지 저장 결과와 AI 스트리밍을 함께 전달하는 래퍼
class SendMessageResponse {
  const SendMessageResponse({required this.saveResult, required this.stream});

  /// 메시지 저장 + 크레딧 차감 결과
  final SaveMessageResult saveResult;

  /// AI 응답 스트리밍
  final Stream<String> stream;
}

class SendMessageUseCase {
  const SendMessageUseCase(this._repository, this._searchTripitakaLocalUseCase);
  final ChatRepository _repository;
  final SearchTripitakaLocalUseCase _searchTripitakaLocalUseCase;

  /// 메시지 저장(크레딧 차감 포함) 및 스트리밍 응답 획득
  Future<SendMessageResponse> call({
    required String chatRoomId,
    required String content,
    required String topicCode,
    String? hexagramId,
    PersonaType? personaId,
  }) async {
    // 1. 메시지 저장과 로컬 검색을 병렬 실행
    final saveFuture = _repository.saveMessage(
      SaveMessageRequestDto(
        chatRoomId: chatRoomId,
        content: content,
        senderRole: 'user',
      ),
    );

    final searchFuture = topicCode == 'tripitaka'
        ? _searchTripitakaLocal(content)
        : Future.value();

    final results = await Future.wait([saveFuture, searchFuture]);
    final saveResult = results[0] as SaveMessageResult;
    final searchContext = results[1] as String?;

    // 2. AI 응답 스트리밍
    final stream = _repository.streamResponse(
      chatRoomId: chatRoomId,
      userMessage: content,
      topicCode: topicCode,
      hexagramId: hexagramId,
      personaId: personaId,
      searchContext: searchContext,
    );

    return SendMessageResponse(saveResult: saveResult, stream: stream);
  }

  /// 불경 로컬 키워드 검색 (병렬 실행용 헬퍼)
  Future<String?> _searchTripitakaLocal(String content) async {
    try {
      final results = await _searchTripitakaLocalUseCase.execute(content);

      if (kDebugMode && results.isNotEmpty) {
        debugPrint('[Tripitaka Search] "$content" → ${results.length} chunks');
      }

      if (results.isNotEmpty) {
        return results.take(3).map((r) =>
          '[출처: ${r.metadata.source} / ${r.metadata.chapter}]\n${r.content}'
        ).join('\n\n---\n\n');
      }
    } catch (e) {
      debugPrint('[Tripitaka Search Error] $e');
    }
    return null;
  }
}
