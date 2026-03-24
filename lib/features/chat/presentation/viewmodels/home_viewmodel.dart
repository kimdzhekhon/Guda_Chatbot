import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';

part 'home_viewmodel.g.dart';

class HomeState {
  final String? activeConversationId;
  final ClassicType selectedClassicType;

  HomeState({
    this.activeConversationId,
    required this.selectedClassicType,
  });

  HomeState copyWith({
    String? activeConversationId,
    ClassicType? selectedClassicType,
    bool clearActiveConversation = false,
  }) {
    return HomeState(
      activeConversationId: clearActiveConversation ? null : (activeConversationId ?? this.activeConversationId),
      selectedClassicType: selectedClassicType ?? this.selectedClassicType,
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
    state = state.copyWith(selectedClassicType: type, clearActiveConversation: true);
  }

  void selectConversation(Conversation conversation) {
    state = state.copyWith(
      activeConversationId: conversation.id,
      selectedClassicType: conversation.classicType,
    );
  }

  void startNewChat() {
    final type = state.selectedClassicType;
    final mockConv = Conversation(
      id: 'mock-new-${DateTime.now().millisecondsSinceEpoch}',
      title: '${type.displayName} 새로운 시작',
      classicType: type,
      userId: 'mock-user',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(activeConversationId: mockConv.id);
  }

  void clearActiveConversation() {
    state = state.copyWith(clearActiveConversation: true);
  }
}
