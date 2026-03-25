// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_viewmodels.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseChatDataSource)
final supabaseChatDataSourceProvider = SupabaseChatDataSourceProvider._();

final class SupabaseChatDataSourceProvider
    extends
        $FunctionalProvider<
          SupabaseChatDataSource,
          SupabaseChatDataSource,
          SupabaseChatDataSource
        >
    with $Provider<SupabaseChatDataSource> {
  SupabaseChatDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseChatDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseChatDataSourceHash();

  @$internal
  @override
  $ProviderElement<SupabaseChatDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupabaseChatDataSource create(Ref ref) {
    return supabaseChatDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseChatDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseChatDataSource>(value),
    );
  }
}

String _$supabaseChatDataSourceHash() =>
    r'f6429496d3a5718d9458e929b3d69361dbbdb46e';

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends
        $FunctionalProvider<
          ChatRepositoryImpl,
          ChatRepositoryImpl,
          ChatRepositoryImpl
        >
    with $Provider<ChatRepositoryImpl> {
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatRepositoryImpl create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepositoryImpl>(value),
    );
  }
}

String _$chatRepositoryHash() => r'eb1a21676770c2a27c3ab407e508535dc57decfe';

/// 대화 목록 상태 관리

@ProviderFor(ChatListViewModel)
final chatListViewModelProvider = ChatListViewModelProvider._();

/// 대화 목록 상태 관리
final class ChatListViewModelProvider
    extends $NotifierProvider<ChatListViewModel, UiState<List<Conversation>>> {
  /// 대화 목록 상태 관리
  ChatListViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatListViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatListViewModelHash();

  @$internal
  @override
  ChatListViewModel create() => ChatListViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UiState<List<Conversation>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UiState<List<Conversation>>>(value),
    );
  }
}

String _$chatListViewModelHash() => r'd87c1d0c13b4cdc4ed5b50bbb81ee20600fb16d1';

/// 대화 목록 상태 관리

abstract class _$ChatListViewModel
    extends $Notifier<UiState<List<Conversation>>> {
  UiState<List<Conversation>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<UiState<List<Conversation>>, UiState<List<Conversation>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                UiState<List<Conversation>>,
                UiState<List<Conversation>>
              >,
              UiState<List<Conversation>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// 특정 대화 세션 상태 관리 — 메시지 목록 + 스트리밍 응답 처리

@ProviderFor(ChatRoomViewModel)
final chatRoomViewModelProvider = ChatRoomViewModelFamily._();

/// 특정 대화 세션 상태 관리 — 메시지 목록 + 스트리밍 응답 처리
final class ChatRoomViewModelProvider
    extends $NotifierProvider<ChatRoomViewModel, UiState<List<Message>>> {
  /// 특정 대화 세션 상태 관리 — 메시지 목록 + 스트리밍 응답 처리
  ChatRoomViewModelProvider._({
    required ChatRoomViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRoomViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRoomViewModelHash();

  @override
  String toString() {
    return r'chatRoomViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatRoomViewModel create() => ChatRoomViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UiState<List<Message>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UiState<List<Message>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRoomViewModelHash() => r'd85035ee0f32915b1e4ecde993f92132b5f4a75e';

/// 특정 대화 세션 상태 관리 — 메시지 목록 + 스트리밍 응답 처리

final class ChatRoomViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatRoomViewModel,
          UiState<List<Message>>,
          UiState<List<Message>>,
          UiState<List<Message>>,
          String
        > {
  ChatRoomViewModelFamily._()
    : super(
        retry: null,
        name: r'chatRoomViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 특정 대화 세션 상태 관리 — 메시지 목록 + 스트리밍 응답 처리

  ChatRoomViewModelProvider call(String conversationId) =>
      ChatRoomViewModelProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'chatRoomViewModelProvider';
}

/// 특정 대화 세션 상태 관리 — 메시지 목록 + 스트리밍 응답 처리

abstract class _$ChatRoomViewModel extends $Notifier<UiState<List<Message>>> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  UiState<List<Message>> build(String conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<UiState<List<Message>>, UiState<List<Message>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UiState<List<Message>>, UiState<List<Message>>>,
              UiState<List<Message>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
