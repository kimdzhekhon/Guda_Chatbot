// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageDto {

 int get id;@JsonKey(name: 'chat_rooms_id') String get chatRoomId;@JsonKey(name: 'sender_role') String get senderRole; String get content;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageDtoCopyWith<MessageDto> get copyWith => _$MessageDtoCopyWithImpl<MessageDto>(this as MessageDto, _$identity);

  /// Serializes this MessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.chatRoomId, chatRoomId) || other.chatRoomId == chatRoomId)&&(identical(other.senderRole, senderRole) || other.senderRole == senderRole)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chatRoomId,senderRole,content,createdAt);

@override
String toString() {
  return 'MessageDto(id: $id, chatRoomId: $chatRoomId, senderRole: $senderRole, content: $content, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MessageDtoCopyWith<$Res>  {
  factory $MessageDtoCopyWith(MessageDto value, $Res Function(MessageDto) _then) = _$MessageDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'chat_rooms_id') String chatRoomId,@JsonKey(name: 'sender_role') String senderRole, String content,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$MessageDtoCopyWithImpl<$Res>
    implements $MessageDtoCopyWith<$Res> {
  _$MessageDtoCopyWithImpl(this._self, this._then);

  final MessageDto _self;
  final $Res Function(MessageDto) _then;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? chatRoomId = null,Object? senderRole = null,Object? content = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,chatRoomId: null == chatRoomId ? _self.chatRoomId : chatRoomId // ignore: cast_nullable_to_non_nullable
as String,senderRole: null == senderRole ? _self.senderRole : senderRole // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageDto].
extension MessageDtoPatterns on MessageDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageDto value)  $default,){
final _that = this;
switch (_that) {
case _MessageDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'chat_rooms_id')  String chatRoomId, @JsonKey(name: 'sender_role')  String senderRole,  String content, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.id,_that.chatRoomId,_that.senderRole,_that.content,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'chat_rooms_id')  String chatRoomId, @JsonKey(name: 'sender_role')  String senderRole,  String content, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _MessageDto():
return $default(_that.id,_that.chatRoomId,_that.senderRole,_that.content,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'chat_rooms_id')  String chatRoomId, @JsonKey(name: 'sender_role')  String senderRole,  String content, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.id,_that.chatRoomId,_that.senderRole,_that.content,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageDto extends MessageDto {
  const _MessageDto({required this.id, @JsonKey(name: 'chat_rooms_id') required this.chatRoomId, @JsonKey(name: 'sender_role') required this.senderRole, required this.content, @JsonKey(name: 'created_at') required this.createdAt}): super._();
  factory _MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'chat_rooms_id') final  String chatRoomId;
@override@JsonKey(name: 'sender_role') final  String senderRole;
@override final  String content;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageDtoCopyWith<_MessageDto> get copyWith => __$MessageDtoCopyWithImpl<_MessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.chatRoomId, chatRoomId) || other.chatRoomId == chatRoomId)&&(identical(other.senderRole, senderRole) || other.senderRole == senderRole)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chatRoomId,senderRole,content,createdAt);

@override
String toString() {
  return 'MessageDto(id: $id, chatRoomId: $chatRoomId, senderRole: $senderRole, content: $content, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MessageDtoCopyWith<$Res> implements $MessageDtoCopyWith<$Res> {
  factory _$MessageDtoCopyWith(_MessageDto value, $Res Function(_MessageDto) _then) = __$MessageDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'chat_rooms_id') String chatRoomId,@JsonKey(name: 'sender_role') String senderRole, String content,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$MessageDtoCopyWithImpl<$Res>
    implements _$MessageDtoCopyWith<$Res> {
  __$MessageDtoCopyWithImpl(this._self, this._then);

  final _MessageDto _self;
  final $Res Function(_MessageDto) _then;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? chatRoomId = null,Object? senderRole = null,Object? content = null,Object? createdAt = null,}) {
  return _then(_MessageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,chatRoomId: null == chatRoomId ? _self.chatRoomId : chatRoomId // ignore: cast_nullable_to_non_nullable
as String,senderRole: null == senderRole ? _self.senderRole : senderRole // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SendMessageRequestDto {

@JsonKey(name: 'conversation_id') String get conversationId;@JsonKey(name: 'user_message') String get userMessage;@JsonKey(name: 'classic_type') String get classicType;
/// Create a copy of SendMessageRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendMessageRequestDtoCopyWith<SendMessageRequestDto> get copyWith => _$SendMessageRequestDtoCopyWithImpl<SendMessageRequestDto>(this as SendMessageRequestDto, _$identity);

  /// Serializes this SendMessageRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendMessageRequestDto&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userMessage, userMessage) || other.userMessage == userMessage)&&(identical(other.classicType, classicType) || other.classicType == classicType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,userMessage,classicType);

@override
String toString() {
  return 'SendMessageRequestDto(conversationId: $conversationId, userMessage: $userMessage, classicType: $classicType)';
}


}

/// @nodoc
abstract mixin class $SendMessageRequestDtoCopyWith<$Res>  {
  factory $SendMessageRequestDtoCopyWith(SendMessageRequestDto value, $Res Function(SendMessageRequestDto) _then) = _$SendMessageRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conversation_id') String conversationId,@JsonKey(name: 'user_message') String userMessage,@JsonKey(name: 'classic_type') String classicType
});




}
/// @nodoc
class _$SendMessageRequestDtoCopyWithImpl<$Res>
    implements $SendMessageRequestDtoCopyWith<$Res> {
  _$SendMessageRequestDtoCopyWithImpl(this._self, this._then);

  final SendMessageRequestDto _self;
  final $Res Function(SendMessageRequestDto) _then;

/// Create a copy of SendMessageRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? userMessage = null,Object? classicType = null,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userMessage: null == userMessage ? _self.userMessage : userMessage // ignore: cast_nullable_to_non_nullable
as String,classicType: null == classicType ? _self.classicType : classicType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SendMessageRequestDto].
extension SendMessageRequestDtoPatterns on SendMessageRequestDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendMessageRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendMessageRequestDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendMessageRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _SendMessageRequestDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendMessageRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _SendMessageRequestDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_message')  String userMessage, @JsonKey(name: 'classic_type')  String classicType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendMessageRequestDto() when $default != null:
return $default(_that.conversationId,_that.userMessage,_that.classicType);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_message')  String userMessage, @JsonKey(name: 'classic_type')  String classicType)  $default,) {final _that = this;
switch (_that) {
case _SendMessageRequestDto():
return $default(_that.conversationId,_that.userMessage,_that.classicType);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_message')  String userMessage, @JsonKey(name: 'classic_type')  String classicType)?  $default,) {final _that = this;
switch (_that) {
case _SendMessageRequestDto() when $default != null:
return $default(_that.conversationId,_that.userMessage,_that.classicType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendMessageRequestDto implements SendMessageRequestDto {
  const _SendMessageRequestDto({@JsonKey(name: 'conversation_id') required this.conversationId, @JsonKey(name: 'user_message') required this.userMessage, @JsonKey(name: 'classic_type') required this.classicType});
  factory _SendMessageRequestDto.fromJson(Map<String, dynamic> json) => _$SendMessageRequestDtoFromJson(json);

@override@JsonKey(name: 'conversation_id') final  String conversationId;
@override@JsonKey(name: 'user_message') final  String userMessage;
@override@JsonKey(name: 'classic_type') final  String classicType;

/// Create a copy of SendMessageRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendMessageRequestDtoCopyWith<_SendMessageRequestDto> get copyWith => __$SendMessageRequestDtoCopyWithImpl<_SendMessageRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendMessageRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendMessageRequestDto&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userMessage, userMessage) || other.userMessage == userMessage)&&(identical(other.classicType, classicType) || other.classicType == classicType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,userMessage,classicType);

@override
String toString() {
  return 'SendMessageRequestDto(conversationId: $conversationId, userMessage: $userMessage, classicType: $classicType)';
}


}

/// @nodoc
abstract mixin class _$SendMessageRequestDtoCopyWith<$Res> implements $SendMessageRequestDtoCopyWith<$Res> {
  factory _$SendMessageRequestDtoCopyWith(_SendMessageRequestDto value, $Res Function(_SendMessageRequestDto) _then) = __$SendMessageRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'conversation_id') String conversationId,@JsonKey(name: 'user_message') String userMessage,@JsonKey(name: 'classic_type') String classicType
});




}
/// @nodoc
class __$SendMessageRequestDtoCopyWithImpl<$Res>
    implements _$SendMessageRequestDtoCopyWith<$Res> {
  __$SendMessageRequestDtoCopyWithImpl(this._self, this._then);

  final _SendMessageRequestDto _self;
  final $Res Function(_SendMessageRequestDto) _then;

/// Create a copy of SendMessageRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? userMessage = null,Object? classicType = null,}) {
  return _then(_SendMessageRequestDto(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userMessage: null == userMessage ? _self.userMessage : userMessage // ignore: cast_nullable_to_non_nullable
as String,classicType: null == classicType ? _self.classicType : classicType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
