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
  FutureOr<PersonaType> build() async {
    // AuthViewModel의 상태를 구독하여 현재 사용자의 페르소나 정보를 가져옴
    final authState = ref.watch(authViewModelProvider);
    
    final user = authState.dataOrNull;
    return user?.persona ?? PersonaType.wise;
  }

  /// 모든 가용 페르소나 목록 반환
  List<Persona> get personas => [
    const Persona(
      id: PersonaType.wise,
      name: AppStrings.personaWiseName,
      description: AppStrings.personaWiseDesc,
      addedPrompt: AppPersonas.wisePrompt,
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
  PersonaType get currentPersona => state.value ?? PersonaType.wise;

  /// 페르소나 변경 및 저장 (AuthViewModel을 통해 DB 업데이트)
  Future<void> updatePersona(PersonaType personaType) async {
    // 즉시 상태 반영 (Optimistic UI)
    state = AsyncValue.data(personaType);
    
    // AuthViewModel을 통해 DB 업데이트 호출
    await ref.read(authViewModelProvider.notifier).updatePersona(personaType);
  }
}
