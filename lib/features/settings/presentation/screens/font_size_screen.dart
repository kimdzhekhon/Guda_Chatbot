import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/features/settings/presentation/viewmodels/font_size_viewmodel.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// SCR_FONT_SIZE — 글자 크기 조절 화면
class FontSizeScreen extends ConsumerWidget {
  const FontSizeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontScaleAsync = ref.watch(fontSizeViewModelProvider);

    return GudaScaffold(
      appBar: const GudaAppBar(title: AppStrings.fontSizeScreenTitle),
      body: fontScaleAsync.when(
        data: (scale) => _buildBody(context, ref, scale),
        loading: () => const GudaLoadingWidget(),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    double currentScale,
  ) {
    // 슬라이더 값 매핑: 0.85 (작게), 1.0 (보통), 1.15 (크게)
    double sliderValue = 1.0;
    if (currentScale <= 0.85) {
      sliderValue = 0.0;
    } else if (currentScale >= 1.15) {
      sliderValue = 2.0;
    } else {
      sliderValue = 1.0;
    }

    return Column(
      children: [
        // ── 미리보기 영역 ─────────────────────────
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(GudaSpacing.xl),
            color: context.colorScheme.surfaceContainerLow,
            alignment: Alignment.center,
            child: GudaCard(
              padding: const EdgeInsets.all(GudaSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.fontSizePreviewText,
                    textAlign: TextAlign.center,
                    style: GudaTypography.body1(color: context.colorScheme.onSurface),
                  ),
                  const SizedBox(height: GudaSpacing.md),
                  Text(
                    '${AppStrings.fontSizeLabel}: ${_getLabel(currentScale)}',
                    style: GudaTypography.caption(
                      color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── 조절 영역 ─────────────────────────────
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(GudaSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.fontSizeSmall,
                      style: GudaTypography.caption(color: context.colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      AppStrings.fontSizeNormal,
                      style: GudaTypography.caption(color: context.colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      AppStrings.fontSizeLarge,
                      style: GudaTypography.caption(color: context.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    activeTrackColor: context.colorScheme.primary,
                    inactiveTrackColor: context.colorScheme.outlineVariant,
                    thumbColor: context.colorScheme.primary,
                    overlayColor: context.colorScheme.primary.withValues(alpha: 0.12),
                    valueIndicatorColor: context.colorScheme.primary,
                    valueIndicatorTextStyle: GudaTypography.caption(color: context.colorScheme.onPrimary),
                  ),
                  child: Slider(
                    value: sliderValue,
                    min: 0,
                    max: 2,
                    divisions: 2,
                    onChanged: (value) {
                      double newScale = 1.0;
                      if (value == 0) {
                        newScale = 0.85;
                      } else if (value == 2) {
                        newScale = 1.15;
                      } else {
                        newScale = 1.0;
                      }
                      ref
                          .read(fontSizeViewModelProvider.notifier)
                          .updateFontScale(newScale);
                    },
                  ),
                ),
                const SizedBox(height: GudaSpacing.lg),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getLabel(double scale) {
    if (scale <= 0.85) return AppStrings.fontSizeSmall;
    if (scale >= 1.15) return AppStrings.fontSizeLarge;
    return AppStrings.fontSizeNormal;
  }
}
