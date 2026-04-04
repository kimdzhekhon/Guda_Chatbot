import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_section.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_tile.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/features/settings/presentation/viewmodels/persona_viewmodel.dart';

/// SCR_PERSONA_SELECTION — 페르소나 선택 화면
class PersonaSelectionScreen extends ConsumerWidget {
  const PersonaSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personaState = ref.watch(personaProvider);
    final personaNotifier = ref.read(personaProvider.notifier);

    final currentPersonaId = personaState.dataOrNull ?? PersonaType.basic;
    final personas = personaNotifier.personas;

    return GudaScaffold(
      appBar: const GudaAppBar(title: AppStrings.personaSettingTitle),
      body: ListView(
        children: [
          GudaSection(
            title: AppStrings.personaSettingDesc,
            contentPadding: EdgeInsets.zero,
            // ListView.builder 대신 Column 유지 (항목 수가 적으므로)
            // 단, .map() 체인을 직접 인덱스 접근으로 변환하여 중간 객체 생성 방지
            child: Column(
              children: [
                for (int i = 0; i < personas.length; i++) ...[
                  GudaTile(
                    title: personas[i].name,
                    subtitle: personas[i].description,
                    isSelected: personas[i].id == currentPersonaId,
                    onTap: () => personaNotifier.updatePersona(personas[i].id),
                    trailing: personas[i].id == currentPersonaId
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: context.colorScheme.primary,
                          )
                        : Icon(
                            Icons.radio_button_unchecked_rounded,
                            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                          ),
                  ),
                  if (i < personas.length - 1) const GudaDivider(),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(GudaSpacing.xl),
            child: Text(
              '페르소나를 변경하면 이후 진행되는 대화부터 적용됩니다.',
              style: GudaTypography.caption(
                color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
