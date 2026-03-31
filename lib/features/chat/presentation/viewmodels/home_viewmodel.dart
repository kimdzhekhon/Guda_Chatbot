import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/domain/orchestrations/chat_flow_orchestrator.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';

part 'home_viewmodel.g.dart';

enum CardPhase {
  selection, // 궤 선택/던지기 선택 단계
  animating, // 궤 던지는 애니메이션 단계
  input, // 질문 입력 단계
}

class HomeState {
  final String? activeChatRoomId;
  final ClassicType selectedClassicType;
  final CardPhase phase;
  final Hexagram? selectedHexagram;

  HomeState({
    this.activeChatRoomId,
    required this.selectedClassicType,
    this.phase = CardPhase.selection,
    this.selectedHexagram,
  });

  HomeState copyWith({
    String? activeChatRoomId,
    ClassicType? selectedClassicType,
    CardPhase? phase,
    Hexagram? selectedHexagram,
    bool clearActiveChatRoom = false,
  }) {
    return HomeState(
      activeChatRoomId: clearActiveChatRoom
          ? null
          : (activeChatRoomId ?? this.activeChatRoomId),
      selectedClassicType: selectedClassicType ?? this.selectedClassicType,
      phase: phase ?? this.phase,
      selectedHexagram: selectedHexagram ?? this.selectedHexagram,
    );
  }
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    return HomeState(selectedClassicType: ClassicType.tripitaka);
  }

  void selectClassicType(ClassicType type) {
    _initializeByClassicType(type, clearActiveChatRoom: true);
  }

  void _initializeByClassicType(ClassicType type,
      {bool clearActiveChatRoom = false}) {
    final config = ChatFlowOrchestrator.prepareNewChat(type: type);
    state = state.copyWith(
      selectedClassicType: type,
      clearActiveChatRoom: clearActiveChatRoom,
      phase: config['phase'] == 'input' ? CardPhase.input : CardPhase.selection,
      selectedHexagram: null,
    );
  }

  void selectConversation(Conversation conversation) {
    state = state.copyWith(
      activeChatRoomId: conversation.id,
      selectedClassicType: conversation.topicCode,
      phase: CardPhase.input,
    );
  }

  Future<void> startNewChat() async {
    final type = state.selectedClassicType;
    
    try {
      final useCase = ref.read(createConversationUseCaseProvider);
      final newConv = await useCase(
        title: '${type.displayName} 새 대화',
        topicCode: type.name,
      );
      
      _initializeByClassicType(type);
      state = state.copyWith(activeChatRoomId: newConv.id);
      
      // 목록 갱신 트리거 (Side effect)
      ref.read(chatListViewModelProvider.notifier).refresh();
    } catch (e) {
       // 에러 처리 (필요시 UiState 활용)
    }
  }

  void clearActiveChatRoom() {
    state = state.copyWith(clearActiveChatRoom: true);
    resetInitialPhase();
  }

  void updatePhase(CardPhase phase) {
    state = state.copyWith(phase: phase);
  }

  void selectHexagram(Hexagram? hexagram) {
    state = state.copyWith(
      selectedHexagram: hexagram,
      phase: hexagram != null ? CardPhase.input : CardPhase.selection,
    );
  }

  void resetInitialPhase() {
    _initializeByClassicType(state.selectedClassicType);
  }
}
