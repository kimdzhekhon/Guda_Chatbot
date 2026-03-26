import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/domain/orchestrations/chat_flow_orchestrator.dart';

part 'home_viewmodel.g.dart';

enum CardPhase {
  selection, // 궤 선택/던지기 선택 단계
  animating, // 궤 던지는 애니메이션 단계
  input, // 질문 입력 단계
}

class HomeState {
  final String? activeConversationId;
  final ClassicType selectedClassicType;
  final CardPhase phase;
  final Hexagram? selectedHexagram;

  HomeState({
    this.activeConversationId,
    required this.selectedClassicType,
    this.phase = CardPhase.selection,
    this.selectedHexagram,
  });

  HomeState copyWith({
    String? activeConversationId,
    ClassicType? selectedClassicType,
    CardPhase? phase,
    Hexagram? selectedHexagram,
    bool clearActiveConversation = false,
  }) {
    return HomeState(
      activeConversationId: clearActiveConversation
          ? null
          : (activeConversationId ?? this.activeConversationId),
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
    _initializeByClassicType(type, clearActiveConversation: true);
  }

  void _initializeByClassicType(ClassicType type,
      {bool clearActiveConversation = false}) {
    final config = ChatFlowOrchestrator.prepareNewChat(type: type);
    state = state.copyWith(
      selectedClassicType: type,
      clearActiveConversation: clearActiveConversation,
      phase: config['phase'] == 'input' ? CardPhase.input : CardPhase.selection,
      selectedHexagram: null,
    );
  }

  void selectConversation(Conversation conversation) {
    state = state.copyWith(
      activeConversationId: conversation.id,
      selectedClassicType: conversation.classicType,
      phase: CardPhase.input,
    );
  }

  void startNewChat() {
    final type = state.selectedClassicType;
    _initializeByClassicType(type);
    
    // Note: In a real app, we might want to keep the mock ID generation 
    // or call the repository to create a new conversation.
    // For now, focusing on state initialization consistency.
  }

  void clearActiveConversation() {
    state = state.copyWith(clearActiveConversation: true);
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
