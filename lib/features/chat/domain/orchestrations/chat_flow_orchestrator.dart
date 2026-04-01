import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';

/// 채팅 플로우 오케스트레이터 — 여러 도메인 로직이 결합된 복합 흐름 제어
/// (Anti-Gravity Rule 5.2 준수)
class ChatFlowOrchestrator {
  /// 새로운 채팅 시작 시 필요한 초기 상태 및 데이터 조합
  static Map<String, dynamic> prepareNewChat({
    required ClassicType type,
  }) {
    // 1. 유형별 초기 페이즈 결정
    final initialPhase = type == ClassicType.tripitaka
        ? 'input' // 팔만대장경은 바로 입력
        : 'selection'; // 나머지는 궤 선택부터
        
    // 2. 초기화에 필요한 설정값 반환
    return {
      'phase': initialPhase,
      'shouldClearHexagram': true,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }
}
