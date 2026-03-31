import 'package:guda_chatbot/core/constants/app_personas.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'persona_viewmodel.g.dart';

/// 페르소나 상태 관리 (Riverpod Notifier)
@Riverpod(keepAlive: true)
class PersonaNotifier extends _$PersonaNotifier {
  @override
  UiState<PersonaType> build() {
    final authState = ref.watch(authViewModelProvider);
    
    // AuthViewModel의 상태를 PersonaType 상태로 변환
    return authState.when(
      loading: () => const UiLoading(),
      success: (user) => UiSuccess(user?.persona ?? PersonaType.basic),
      error: (msg, code) => UiError(msg, errorCode: code),
    );
  }

  /// 모든 가용 페르소나 목록 반환
  List<Persona> get personas => [
    const Persona(
      id: PersonaType.basic,
      name: AppStrings.personaWiseName,
      description: AppStrings.personaWiseDesc,
      addedPrompt: AppPersonas.basicPrompt,
    ),
    const Persona(
      id: PersonaType.friendly,
      name: AppStrings.personaFriendlyName,
      description: AppStrings.personaFriendlyDesc,
      addedPrompt: AppPersonas.friendlyPrompt,
    ),
    const Persona(
      id: PersonaType.strict,
      name: AppStrings.personaStrictName,
      description: AppStrings.personaStrictDesc,
      addedPrompt: AppPersonas.strictPrompt,
    ),
  ];

  /// 현재 선택된 페르소나 타입
  PersonaType get currentPersona => state.dataOrNull ?? PersonaType.basic;

  /// 페르소나 변경 및 저장 (AuthViewModel을 통해 DB 업데이트)
  Future<void> updatePersona(PersonaType personaType) async {
    // 즉시 상태 반영 (Optimistic UI)
    state = UiSuccess(personaType);
    
    try {
      // AuthViewModel을 통해 DB 업데이트 호출
      await ref.read(authViewModelProvider.notifier).updatePersona(personaType);
    } catch (e) {
      // 실패 시 상태 복원 (AuthViewModel이 이전 상태로 복구하므로 이를 반영하기 위해 build 재호출 유도 가능하지만
      // 여기서는 명시적으로 에러 처리)
      state = UiError(e.toString());
    }
  }
}
