// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_viewmodels.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rpcInvoker)
final rpcInvokerProvider = RpcInvokerProvider._();

final class RpcInvokerProvider
    extends $FunctionalProvider<RpcInvoker, RpcInvoker, RpcInvoker>
    with $Provider<RpcInvoker> {
  RpcInvokerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rpcInvokerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rpcInvokerHash();

  @$internal
  @override
  $ProviderElement<RpcInvoker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RpcInvoker create(Ref ref) {
    return rpcInvoker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RpcInvoker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RpcInvoker>(value),
    );
  }
}

String _$rpcInvokerHash() => r'f54e8985e5a0afc7f9e4b08245e1e8ef2774c37a';

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
    r'e2df67fb8e5f1b6096879091231132a38e42bbf0';

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
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
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'1ceb781606c32bf3199cb12c95ef1e8456624fca';

@ProviderFor(getConversationsUseCase)
final getConversationsUseCaseProvider = GetConversationsUseCaseProvider._();

final class GetConversationsUseCaseProvider
    extends
        $FunctionalProvider<
          GetConversationsUseCase,
          GetConversationsUseCase,
          GetConversationsUseCase
        >
    with $Provider<GetConversationsUseCase> {
  GetConversationsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getConversationsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getConversationsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetConversationsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetConversationsUseCase create(Ref ref) {
    return getConversationsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetConversationsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetConversationsUseCase>(value),
    );
  }
}

String _$getConversationsUseCaseHash() =>
    r'9173743ed614aeebab66e8f1939c5a4cea807f90';

@ProviderFor(createConversationUseCase)
final createConversationUseCaseProvider = CreateConversationUseCaseProvider._();

final class CreateConversationUseCaseProvider
    extends
        $FunctionalProvider<
          CreateConversationUseCase,
          CreateConversationUseCase,
          CreateConversationUseCase
        >
    with $Provider<CreateConversationUseCase> {
  CreateConversationUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createConversationUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createConversationUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateConversationUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateConversationUseCase create(Ref ref) {
    return createConversationUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateConversationUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateConversationUseCase>(value),
    );
  }
}

String _$createConversationUseCaseHash() =>
    r'a4f561cdb6d37845b2efdc910a7352f62e27f762';

@ProviderFor(deleteConversationUseCase)
final deleteConversationUseCaseProvider = DeleteConversationUseCaseProvider._();

final class DeleteConversationUseCaseProvider
    extends
        $FunctionalProvider<
          DeleteConversationUseCase,
          DeleteConversationUseCase,
          DeleteConversationUseCase
        >
    with $Provider<DeleteConversationUseCase> {
  DeleteConversationUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteConversationUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteConversationUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteConversationUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeleteConversationUseCase create(Ref ref) {
    return deleteConversationUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteConversationUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteConversationUseCase>(value),
    );
  }
}

String _$deleteConversationUseCaseHash() =>
    r'b00181c604761783c29950d821237f3e281628bb';

@ProviderFor(getMessagesUseCase)
final getMessagesUseCaseProvider = GetMessagesUseCaseProvider._();

final class GetMessagesUseCaseProvider
    extends
        $FunctionalProvider<
          GetMessagesUseCase,
          GetMessagesUseCase,
          GetMessagesUseCase
        >
    with $Provider<GetMessagesUseCase> {
  GetMessagesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMessagesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMessagesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetMessagesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetMessagesUseCase create(Ref ref) {
    return getMessagesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMessagesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMessagesUseCase>(value),
    );
  }
}

String _$getMessagesUseCaseHash() =>
    r'ced351a3c01c94e98ca05227b9c76e883955c7ff';

@ProviderFor(sendMessageUseCase)
final sendMessageUseCaseProvider = SendMessageUseCaseProvider._();

final class SendMessageUseCaseProvider
    extends
        $FunctionalProvider<
          SendMessageUseCase,
          SendMessageUseCase,
          SendMessageUseCase
        >
    with $Provider<SendMessageUseCase> {
  SendMessageUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendMessageUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendMessageUseCaseHash();

  @$internal
  @override
  $ProviderElement<SendMessageUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SendMessageUseCase create(Ref ref) {
    return sendMessageUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendMessageUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendMessageUseCase>(value),
    );
  }
}

String _$sendMessageUseCaseHash() =>
    r'55850c09b954fe0a47d8b252a0ff70bb6cd6e22b';

@ProviderFor(ChatListViewModel)
final chatListViewModelProvider = ChatListViewModelProvider._();

final class ChatListViewModelProvider
    extends $NotifierProvider<ChatListViewModel, UiState<List<Conversation>>> {
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

String _$chatListViewModelHash() => r'327d49d790e2e6a7cb1247280c44a675e6de03a7';

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

@ProviderFor(sortedConversations)
final sortedConversationsProvider = SortedConversationsProvider._();

final class SortedConversationsProvider
    extends
        $FunctionalProvider<
          List<Conversation>,
          List<Conversation>,
          List<Conversation>
        >
    with $Provider<List<Conversation>> {
  SortedConversationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sortedConversationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sortedConversationsHash();

  @$internal
  @override
  $ProviderElement<List<Conversation>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<Conversation> create(Ref ref) {
    return sortedConversations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Conversation> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Conversation>>(value),
    );
  }
}

String _$sortedConversationsHash() =>
    r'91168d36a13fb58cf8f30ad5a7d32170db6a2552';

@ProviderFor(ChatRoomViewModel)
final chatRoomViewModelProvider = ChatRoomViewModelFamily._();

final class ChatRoomViewModelProvider
    extends $NotifierProvider<ChatRoomViewModel, UiState<List<Message>>> {
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

String _$chatRoomViewModelHash() => r'af0c0d3e1bf4b05cd304b42717b52d0a4b27e386';

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

  ChatRoomViewModelProvider call(String chatRoomId) =>
      ChatRoomViewModelProvider._(argument: chatRoomId, from: this);

  @override
  String toString() => r'chatRoomViewModelProvider';
}

abstract class _$ChatRoomViewModel extends $Notifier<UiState<List<Message>>> {
  late final _$args = ref.$arg as String;
  String get chatRoomId => _$args;

  UiState<List<Message>> build(String chatRoomId);
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
