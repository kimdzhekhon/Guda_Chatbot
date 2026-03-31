import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// 회원 가입 프로세스 단계를 표시하는 인디케이터 (정렬 및 디자인 개선 버전)
class GudaStepIndicator extends StatelessWidget {
  const GudaStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
    required this.labels,
  }) : assert(labels.length == totalSteps);

  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 연결선 레이어 (배경)
        Positioned(
          top: 15, // 숫자 원(32px)의 중앙 높이 보정 (16 - height/2)
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (MediaQuery.of(context).size.width - GudaSpacing.xl * 2) / (totalSteps * 2),
            ),
            child: Row(
              children: List.generate(totalSteps - 1, (index) {
                final isCompleted = index + 1 < currentStep;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16), // 원의 반경만큼 마진 추가 (침범 방지)
                    height: 2,
                    color: isCompleted
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                );
              }),
            ),
          ),
        ),
        // 2. 단계 아이템 레이어 (숫자 원 + 라벨)
        Row(
          children: List.generate(totalSteps, (index) {
            final stepNumber = index + 1;
            final isActive = stepNumber <= currentStep;
            final isCurrent = stepNumber == currentStep;

            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 숫자 원
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent
                          ? Colors.white
                          : (isActive
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.1)),
                      border: isCurrent
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$stepNumber',
                        style: GudaTypography.captionBold(
                          color: isCurrent 
                              ? GudaColors.primary // 하얀 배경에는 남색 글씨
                              : (isActive ? Colors.white : Colors.white24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: GudaSpacing.xs),
                  // 라벨 (수직 정렬을 위해 고정 높이 적용)
                  SizedBox(
                    height: 24,
                    child: Center(
                      child: Text(
                        labels[index],
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: isCurrent
                            ? GudaTypography.captionBold(color: Colors.white)
                            : GudaTypography.caption(
                                color: isActive
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : Colors.white.withValues(alpha: 0.3),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
