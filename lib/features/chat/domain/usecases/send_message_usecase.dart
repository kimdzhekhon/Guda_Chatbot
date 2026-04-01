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
    PersonaType? personaId,
  }) async {
    // 1. 사용자 메시지 저장 (크레딧 차감 + 로그 기록 포함)
    final saveResult = await _repository.saveMessage(
      SaveMessageRequestDto(
        chatRoomId: chatRoomId,
        content: content,
        senderRole: 'user',
      ),
    );

    // 2. 불경(tripitaka)인 경우 로컬 키워드 매칭 검색 수행 및 로깅
    String? searchContext;
    if (topicCode == 'tripitaka') {
      try {
        final results = await _searchTripitakaLocalUseCase.execute(content);
        
        if (kDebugMode) {
          debugPrint('🔍 [Tripitaka Search] Query: "$content"');
          debugPrint('📑 Found ${results.length} matching chunks.');
          for (var i = 0; i < results.length && i < 3; i++) {
            final r = results[i];
            debugPrint('   [$i] ID: ${r.id}');
            debugPrint('       Source: ${r.metadata.source}');
            debugPrint('       Content preview: ${r.content.substring(0, 100).replaceAll('\n', ' ')}...');
          }
        }

        // AI 컨텍스트용 문자열 구성 (최대 3개)
        if (results.isNotEmpty) {
          searchContext = results.take(3).map((r) => 
            '[출처: ${r.metadata.source} / ${r.metadata.chapter}]\n${r.content}'
          ).join('\n\n---\n\n');
        }
      } catch (e) {
        debugPrint('⚠️ Error during local tripitaka search: $e');
      }
    }

    // 3. AI 응답 스트리밍 (검색 결과가 있으면 searchContext 전달)
    final stream = _repository.streamResponse(
      chatRoomId: chatRoomId,
      userMessage: content,
      topicCode: topicCode,
      personaId: personaId,
      searchContext: searchContext,
    );

    return SendMessageResponse(saveResult: saveResult, stream: stream);
  }
}
