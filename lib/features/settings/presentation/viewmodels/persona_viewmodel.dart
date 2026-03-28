import 'package:guda_chatbot/core/constants/app_personas.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/security/storage_service.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'persona_viewmodel.g.dart';

/// 페르소나 상태 관리 (Riverpod Notifier)
@riverpod
class PersonaNotifier extends _$PersonaNotifier {
  @override
  FutureOr<String> build() async {
    final storage = ref.read(storageServiceProvider);
    return await storage.getPersonaId();
  }

  /// 모든 가용 페르소나 목록 반환
  List<Persona> get personas => [
    const Persona(
      id: 'wise',
      name: AppStrings.personaWiseName,
      description: AppStrings.personaWiseDesc,
      addedPrompt: AppPersonas.wisePrompt,
    ),
    const Persona(
      id: 'friendly',
      name: AppStrings.personaFriendlyName,
      description: AppStrings.personaFriendlyDesc,
      addedPrompt: AppPersonas.friendlyPrompt,
    ),
    const Persona(
      id: 'strict',
      name: AppStrings.personaStrictName,
      description: AppStrings.personaStrictDesc,
      addedPrompt: AppPersonas.strictPrompt,
    ),
  ];

  /// 현재 선택된 페르소나 ID (AsyncValue 형태가 아닌 동기식 접근이 필요할 때 사용)
  String get currentPersonaId => state.value ?? 'wise';

  /// 페르소나 변경 및 저장
  Future<void> updatePersona(String personaId) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setPersonaId(personaId);
    state = AsyncValue.data(personaId);
  }
}
