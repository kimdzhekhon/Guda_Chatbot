# Guda Chatbot (구다 챗봇)

> Guda — 동양 고전(팔만대장경, 주역, 구사론 등) 특화 AI 챗봇 앱

Guda Chatbot은 동양 고전의 지혜를 바탕으로 사용자와 대화하며 통찰을 제공하는 AI 챗봇 애플리케이션입니다. Flutter 안티 그래비티 아키텍처 지침을 엄격하게 준수하여 안전하고 확장성 있게 설계되었습니다.

> [!IMPORTANT]
> **보안 및 아키텍처 가이드**: 신규 기능 추가 및 데이터 통신 시 반드시 [DOCS_SECURITY.md](file:///Users/kimjaehyun/Desktop/Guda_Chatbot/DOCS_SECURITY.md)를 참고하십시오.

## 🛠 사용 기술 및 라이브러리 (Tech Stack & Libraries)

프로젝트에 사용된 프레임워크와 주요 패키지는 다음과 같이 구성되어 있습니다.

### 1. Framework & Core
- **Flutter** (SDK: `^3.11.1`): 크로스 플랫폼 UI 프레임워크
- **Dart**: 언어 및 런타임 환경

### 2. State Management & Architecture (상태 관리 및 아키텍처)
- **`flutter_riverpod`** (`^3.3.1`): 앱 전역 상태 및 의존성 주입(DI)을 위한 상태 관리 라이브러리입니다. 안전하고 테스트 가능한 코드를 작성할 수 있게 돕습니다.
- **`riverpod_annotation`** / **`riverpod_generator`**: Riverpod의 보일러플레이트 코드를 줄이고 코드 제너레이션을 통해 Type-safe한 provider를 생성합니다.
- **`freezed`** / **`freezed_annotation`**: 불변(Immutable) 데이터 모델과 Union 타입을 쉽게 작성할 수 있도록 지원하는 코드 생성 라이브러리입니다. UI 상태 모델(`UiState<T>`) 및 DTO, Entity 관리에 주로 사용됩니다.

### 3. Routing (라우팅)
- **`go_router`** (`^17.1.0`): 선언형 라우팅을 지원하며 딥링크 처리 및 라우트 가드(인증 기반 접근 제어)를 통합적으로 관리하는 데 사용됩니다.

### 4. Network & Backend (네트워크 및 백엔드)
- **`dio`** (`^5.9.2`): 강력한 HTTP 클라이언트로, 커스텀 인터셉터를 통해 RPC 통신, 로깅, 헤더 세팅(Auth Token) 등을 중앙 집중적으로 처리합니다.
- **`supabase_flutter`** (`^2.12.0`): Supabase 백엔드(PostgreSQL 기반)와의 직접적인 연동, 실시간 데이터 관리, 그리고 통합 인증을 관리합니다.

### 5. Authentication (디바이스 연동 및 인증)
- **`google_sign_in`** (`^6.2.2`): 구글 소셜 로그인 기능 연동.
- **Supabase Auth**: Apple, Kakao, Google 플랫폼 연결 및 사용자 세션 유지 관리.

### 6. Local Storage & Utilities (로컬 저장소 및 유틸리티)
- **`flutter_secure_storage`** (`^10.0.0`): 기기의 안전한 저장소(Keychain, Keystore)에 사용자의 민감 정보(세션 토큰 등)를 암호화하여 저장합니다.
- **`path_provider`** (`^2.1.5`): 파일 시스템 내의 주요 디렉토리 경로(임시 폴더, 문서 폴더 등)를 찾기 위해 사용됩니다.
- **`uuid`** (`^4.5.1`): 디바이스나 세션의 고유 식별자(UUID)를 생성하기 위해 활용됩니다.
- **`share_plus`** (`^12.0.1`): 챗봇의 응답이나 텍스트를 다른 앱으로 공유하는 기능을 제공합니다.

### 7. UI & Asset Management (UI 및 에셋 관리)
- **`flutter_markdown`** (`^0.7.6`): AI 챗봇이 반환하는 Markdown 형식의 응답을 리치 텍스트 형태로 렌더링합니다.
- **`lottie`** (`^3.3.2`): 데이터 로딩, 성공, 실패 등 사용자 경험 향상을 위한 고품질 벡터 애니메이션을 구동합니다.
- **`google_fonts`** (`^8.0.2`): 커스텀 웹 폰트를 손쉽게 적용하기 위해 사용되며, 현재 "NotoSerifKR"과 "Inter" 폰트를 로컬 에셋과 함께 혼용하여 사용 중입니다.

### 8. Code Generation (코드 생성)
- **`build_runner`** (`^2.13.1`): Freezed, JsonSerializable, Riverpod Generator 등의 코드 제너레이터 실행을 위한 도구입니다.
- **`json_serializable`** / **`json_annotation`**: DTO 모델의 JSON 직렬화/역직렬화를 자동화합니다.


## 📁 Directory Structure

프로젝트는 명확한 관심사 분리를 위해 Feature-First 기반의 레이어드 아키텍처를 따릅니다.

```plaintext
lib/
 ├─ app/           # 앱 진입, 라우터, 테마(디자인 토큰 조합), 초기화(bootstrap) 설정
 ├─ core/          # 전역 기능 (보안, 네트워크 통신 클라이언트, 디자인 시스템, 공통 UI)
 └─ features/      # 도메인별 기능 (Feature 단위 분리)
     ├─ domain/    # [순수 Dart] 비즈니스 로직(유즈케이스), 엔티티, 인터페이스
     ├─ data/      # DTO 모델, 데이터 소스, 리포지토리 구현체
     └─ presentation/ # UI 컴포넌트, 화면(Screen), Riverpod ViewModel
```

*   **Supabase 백엔드 구성 및 마이그레이션**: [supabase/README.md](file:///Users/kimjaehyun/Desktop/Guda_Chatbot/supabase/README.md)

## 🏗 Architecture & Guidelines (안티 그래비티 아키텍처 핵심)

본 프로젝트는 다음의 개발 원칙을 준수합니다.

1. **상수 및 토큰 기반 UI (하드코딩 금지)**
   - 모든 시각 요소(색상, 곡률, 여백, 그림자 등)는 `core/design_system` 하위의 토큰을 통해서만 구성됩니다.
   - 단일 디바이스용 분기 처리를 지양하며, `AppResponsiveLayout`을 통한 반응형 UI를 기본으로 합니다.
2. **엄격한 데이터 흐름 제어 (Security Hardening)**
   - API 통신 시 반드시 규격화된 DTO 모델을 통한 RPC 통신을 채택하여 외부 의존성 노출을 최소화합니다.
   - 모든 테이블은 RLS(Row Level Security)가 활성화되어 있으며, 본인 데이터 외의 무단 수정을 백엔드 수준에서 차단합니다.
   - 상세한 RPC 보안 설계는 [DOCS_SECURITY.md](file:///Users/kimjaehyun/Desktop/Guda_Chatbot/DOCS_SECURITY.md)를 확인하십시오.
3. **명확한 상태 관리**
   - `UiState<T>` (loading/success/error) 패턴을 사용하여 UI 상태를 선언적으로 관리합니다.
   - 모든 ViewModel 구현은 Riverpod을 기반으로 이루어집니다.
4. **한글 문서화 체계**
   - 모든 프로덕션 코드 주석 및 설계 문서는 한국어로 관리됩니다.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.11.1` 이상
- 연결된 Supabase 프로젝트

### Installation & Run

1. 의존성 설치
   ```bash
   flutter pub get
   ```

2. 코드 스니펫 및 직렬화 파일 자동 생성 (Freezed, Riverpod, JSON 등)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. 앱 실행
   ```bash
   flutter run
   ```
