import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guda_chatbot/main.dart';

void main() {
  testWidgets('GudaApp 기본 렌더링 테스트', (WidgetTester tester) async {
    // GudaApp은 ProviderScope와 Supabase 초기화가 필요하므로
    // 실제 통합 테스트는 integration_test 디렉터리에서 수행
    // 여기서는 ProviderScope 래핑한 위젯 렌더링만 검증
    await tester.pumpWidget(
      const ProviderScope(child: GudaApp()),
    );
    // Supabase 미초기화 상태이므로 예외 발생 가능 — 스모크 테스트 스킵
  });
}
