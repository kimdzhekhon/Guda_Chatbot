import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_tile.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';

/// SCR_LICENSE — 커스텀 라이선스 화면
/// 사용자가 명시적으로 사용하는 주요 라이브러리와 폰트만 큐레이션하여 표시합니다.
class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GudaAppBar(title: AppStrings.licenseLabel),
      body: ListView(
        children: [
          _buildSectionHeader(context, '디자인 자산 (Design Assets)'),
          _buildLicenseTile(context, 'Noto Serif KR', 'SIL Open Font License 1.1'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'Inter Font Family', 'SIL Open Font License 1.1'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'Lottie Animations', 'MIT License'),
          
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildSectionHeader(context, '프레임워크 및 상태 관리 (Framework)'),
          _buildLicenseTile(context, 'Flutter SDK', 'BSD 3-Clause License'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'Riverpod / riverpod_annotation', 'MIT License'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'GoRouter', 'MIT License'),
          
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildSectionHeader(context, '인프라 및 유틸리티 (Infrastructure)'),
          _buildLicenseTile(context, 'Supabase Flutter SDK', 'MIT License'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'Dio (HTTP Client)', 'MIT License'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'Google Fonts', 'Apache License 2.0'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'Flutter Markdown', 'BSD 3-Clause License'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'Freezed / Json Serializable', 'MIT License'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'Flutter Secure Storage', 'BSD 3-Clause License'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'Share Plus / UUID', 'BSD / MIT License'),
          const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
          _buildLicenseTile(context, 'Google / Apple / Kakao SignIn', 'Mixed Licenses'),
          
          const SizedBox(height: GudaSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GudaSpacing.xl,
        GudaSpacing.xl,
        GudaSpacing.xl,
        GudaSpacing.sm,
      ),
      child: Text(
        title,
        style: GudaTypography.heading3(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildLicenseTile(BuildContext context, String name, String licenseType) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GudaTile(
      title: name,
      subtitle: Text(
        licenseType,
        style: GudaTypography.caption(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
      ),
      onTap: () {
        // 상세 라이선스 텍스트는 간소화를 위해 안내 다이얼로그로 대체하거나 
        // 필요한 경우 나중에 확장 가능합니다.
        _showLicenseDetail(context, name, licenseType);
      },
    );
  }

  void _showLicenseDetail(BuildContext context, String name, String licenseType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name, style: GudaTypography.heading3()),
        content: SingleChildScrollView(
          child: Text(
            '$name은 $licenseType 하에 배포되는 배포물입니다.\n\n'
            '상세 라이선스 전문은 해당 오픈소스 저장소에서 확인하실 수 있습니다.',
            style: GudaTypography.body2(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.confirmLabel),
          ),
        ],
      ),
    );
  }
}
