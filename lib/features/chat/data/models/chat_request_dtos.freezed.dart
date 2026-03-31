// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_request_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateConversationRequestDto {

 String get title;@JsonKey(name: 'topic_code') String get topicCode;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'persona_id') String get personaId;
/// Create a copy of CreateConversationRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateConversationRequestDtoCopyWith<CreateConversationRequestDto> get copyWith => _$CreateConversationRequestDtoCopyWithImpl<CreateConversationRequestDto>(this as CreateConversationRequestDto, _$identity);

  /// Serializes this CreateConversationRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateConversationRequestDto&&(identical(other.title, title) || other.title == title)&&(identical(other.topicCode, topicCode) || other.topicCode == topicCode)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.personaId, personaId) || other.personaId == personaId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,topicCode,userId,personaId);

@override
String toString() {
  return 'CreateConversationRequestDto(title: $title, topicCode: $topicCode, userId: $userId, personaId: $personaId)';
}


}

/// @nodoc
abstract mixin class $CreateConversationRequestDtoCopyWith<$Res>  {
  factory $CreateConversationRequestDtoCopyWith(CreateConversationRequestDto value, $Res Function(CreateConversationRequestDto) _then) = _$CreateConversationRequestDtoCopyWithImpl;
@useResult
$Res call({
 String title,@JsonKey(name: 'topic_code') String topicCode,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'persona_id') String personaId
});




}
/// @nodoc
class _$CreateConversationRequestDtoCopyWithImpl<$Res>
    implements $CreateConversationRequestDtoCopyWith<$Res> {
  _$CreateConversationRequestDtoCopyWithImpl(this._self, this._then);

  final CreateConversationRequestDto _self;
  final $Res Function(CreateConversationRequestDto) _then;

/// Create a copy of CreateConversationRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? topicCode = null,Object? userId = null,Object? personaId = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,topicCode: null == topicCode ? _self.topicCode : topicCode // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,personaId: null == personaId ? _self.personaId : personaId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateConversationRequestDto].
extension CreateConversationRequestDtoPatterns on CreateConversationRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateConversationRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateConversationRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateConversationRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateConversationRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateConversationRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateConversationRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'topic_code')  String topicCode, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'persona_id')  String personaId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateConversationRequestDto() when $default != null:
return $default(_that.title,_that.topicCode,_that.userId,_that.personaId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'topic_code')  String topicCode, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'persona_id')  String personaId)  $default,) {final _that = this;
switch (_that) {
case _CreateConversationRequestDto():
return $default(_that.title,_that.topicCode,_that.userId,_that.personaId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @JsonKey(name: 'topic_code')  String topicCode, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'persona_id')  String personaId)?  $default,) {final _that = this;
switch (_that) {
case _CreateConversationRequestDto() when $default != null:
return $default(_that.title,_that.topicCode,_that.userId,_that.personaId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateConversationRequestDto implements CreateConversationRequestDto {
  const _CreateConversationRequestDto({required this.title, @JsonKey(name: 'topic_code') required this.topicCode, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'persona_id') required this.personaId});
  factory _CreateConversationRequestDto.fromJson(Map<String, dynamic> json) => _$CreateConversationRequestDtoFromJson(json);

@override final  String title;
@override@JsonKey(name: 'topic_code') final  String topicCode;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'persona_id') final  String personaId;

/// Create a copy of CreateConversationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateConversationRequestDtoCopyWith<_CreateConversationRequestDto> get copyWith => __$CreateConversationRequestDtoCopyWithImpl<_CreateConversationRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateConversationRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateConversationRequestDto&&(identical(other.title, title) || other.title == title)&&(identical(other.topicCode, topicCode) || other.topicCode == topicCode)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.personaId, personaId) || other.personaId == personaId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,topicCode,userId,personaId);

@override
String toString() {
  return 'CreateConversationRequestDto(title: $title, topicCode: $topicCode, userId: $userId, personaId: $personaId)';
}


}

/// @nodoc
abstract mixin class _$CreateConversationRequestDtoCopyWith<$Res> implements $CreateConversationRequestDtoCopyWith<$Res> {
  factory _$CreateConversationRequestDtoCopyWith(_CreateConversationRequestDto value, $Res Function(_CreateConversationRequestDto) _then) = __$CreateConversationRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String title,@JsonKey(name: 'topic_code') String topicCode,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'persona_id') String personaId
});




}
/// @nodoc
class __$CreateConversationRequestDtoCopyWithImpl<$Res>
    implements _$CreateConversationRequestDtoCopyWith<$Res> {
  __$CreateConversationRequestDtoCopyWithImpl(this._self, this._then);

  final _CreateConversationRequestDto _self;
  final $Res Function(_CreateConversationRequestDto) _then;

/// Create a copy of CreateConversationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? topicCode = null,Object? userId = null,Object? personaId = null,}) {
  return _then(_CreateConversationRequestDto(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,topicCode: null == topicCode ? _self.topicCode : topicCode // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,personaId: null == personaId ? _self.personaId : personaId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SaveMessageRequestDto {

@JsonKey(name: 'chat_rooms_id') String get chatRoomId; String get content;@JsonKey(name: 'sender_role') String get senderRole;
/// Create a copy of SaveMessageRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveMessageRequestDtoCopyWith<SaveMessageRequestDto> get copyWith => _$SaveMessageRequestDtoCopyWithImpl<SaveMessageRequestDto>(this as SaveMessageRequestDto, _$identity);

  /// Serializes this SaveMessageRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveMessageRequestDto&&(identical(other.chatRoomId, chatRoomId) || other.chatRoomId == chatRoomId)&&(identical(other.content, content) || other.content == content)&&(identical(other.senderRole, senderRole) || other.senderRole == senderRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatRoomId,content,senderRole);

@override
String toString() {
  return 'SaveMessageRequestDto(chatRoomId: $chatRoomId, content: $content, senderRole: $senderRole)';
}


}

/// @nodoc
abstract mixin class $SaveMessageRequestDtoCopyWith<$Res>  {
  factory $SaveMessageRequestDtoCopyWith(SaveMessageRequestDto value, $Res Function(SaveMessageRequestDto) _then) = _$SaveMessageRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'chat_rooms_id') String chatRoomId, String content,@JsonKey(name: 'sender_role') String senderRole
});




}
/// @nodoc
class _$SaveMessageRequestDtoCopyWithImpl<$Res>
    implements $SaveMessageRequestDtoCopyWith<$Res> {
  _$SaveMessageRequestDtoCopyWithImpl(this._self, this._then);

  final SaveMessageRequestDto _self;
  final $Res Function(SaveMessageRequestDto) _then;

/// Create a copy of SaveMessageRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatRoomId = null,Object? content = null,Object? senderRole = null,}) {
  return _then(_self.copyWith(
chatRoomId: null == chatRoomId ? _self.chatRoomId : chatRoomId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,senderRole: null == senderRole ? _self.senderRole : senderRole // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveMessageRequestDto].
extension SaveMessageRequestDtoPatterns on SaveMessageRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveMessageRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveMessageRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveMessageRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _SaveMessageRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveMessageRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _SaveMessageRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'chat_rooms_id')  String chatRoomId,  String content, @JsonKey(name: 'sender_role')  String senderRole)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveMessageRequestDto() when $default != null:
return $default(_that.chatRoomId,_that.content,_that.senderRole);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'chat_rooms_id')  String chatRoomId,  String content, @JsonKey(name: 'sender_role')  String senderRole)  $default,) {final _that = this;
switch (_that) {
case _SaveMessageRequestDto():
return $default(_that.chatRoomId,_that.content,_that.senderRole);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'chat_rooms_id')  String chatRoomId,  String content, @JsonKey(name: 'sender_role')  String senderRole)?  $default,) {final _that = this;
switch (_that) {
case _SaveMessageRequestDto() when $default != null:
return $default(_that.chatRoomId,_that.content,_that.senderRole);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaveMessageRequestDto implements SaveMessageRequestDto {
  const _SaveMessageRequestDto({@JsonKey(name: 'chat_rooms_id') required this.chatRoomId, required this.content, @JsonKey(name: 'sender_role') required this.senderRole});
  factory _SaveMessageRequestDto.fromJson(Map<String, dynamic> json) => _$SaveMessageRequestDtoFromJson(json);

@override@JsonKey(name: 'chat_rooms_id') final  String chatRoomId;
@override final  String content;
@override@JsonKey(name: 'sender_role') final  String senderRole;

/// Create a copy of SaveMessageRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveMessageRequestDtoCopyWith<_SaveMessageRequestDto> get copyWith => __$SaveMessageRequestDtoCopyWithImpl<_SaveMessageRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaveMessageRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveMessageRequestDto&&(identical(other.chatRoomId, chatRoomId) || other.chatRoomId == chatRoomId)&&(identical(other.content, content) || other.content == content)&&(identical(other.senderRole, senderRole) || other.senderRole == senderRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatRoomId,content,senderRole);

@override
String toString() {
  return 'SaveMessageRequestDto(chatRoomId: $chatRoomId, content: $content, senderRole: $senderRole)';
}


}

/// @nodoc
abstract mixin class _$SaveMessageRequestDtoCopyWith<$Res> implements $SaveMessageRequestDtoCopyWith<$Res> {
  factory _$SaveMessageRequestDtoCopyWith(_SaveMessageRequestDto value, $Res Function(_SaveMessageRequestDto) _then) = __$SaveMessageRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'chat_rooms_id') String chatRoomId, String content,@JsonKey(name: 'sender_role') String senderRole
});




}
/// @nodoc
class __$SaveMessageRequestDtoCopyWithImpl<$Res>
    implements _$SaveMessageRequestDtoCopyWith<$Res> {
  __$SaveMessageRequestDtoCopyWithImpl(this._self, this._then);

  final _SaveMessageRequestDto _self;
  final $Res Function(_SaveMessageRequestDto) _then;

/// Create a copy of SaveMessageRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatRoomId = null,Object? content = null,Object? senderRole = null,}) {
  return _then(_SaveMessageRequestDto(
chatRoomId: null == chatRoomId ? _self.chatRoomId : chatRoomId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,senderRole: null == senderRole ? _self.senderRole : senderRole // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GetMessagesRequestDto {

@JsonKey(name: 'chat_rooms_id') String get chatRoomId;
/// Create a copy of GetMessagesRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetMessagesRequestDtoCopyWith<GetMessagesRequestDto> get copyWith => _$GetMessagesRequestDtoCopyWithImpl<GetMessagesRequestDto>(this as GetMessagesRequestDto, _$identity);

  /// Serializes this GetMessagesRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetMessagesRequestDto&&(identical(other.chatRoomId, chatRoomId) || other.chatRoomId == chatRoomId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatRoomId);

@override
String toString() {
  return 'GetMessagesRequestDto(chatRoomId: $chatRoomId)';
}


}

/// @nodoc
abstract mixin class $GetMessagesRequestDtoCopyWith<$Res>  {
  factory $GetMessagesRequestDtoCopyWith(GetMessagesRequestDto value, $Res Function(GetMessagesRequestDto) _then) = _$GetMessagesRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'chat_rooms_id') String chatRoomId
});




}
/// @nodoc
class _$GetMessagesRequestDtoCopyWithImpl<$Res>
    implements $GetMessagesRequestDtoCopyWith<$Res> {
  _$GetMessagesRequestDtoCopyWithImpl(this._self, this._then);

  final GetMessagesRequestDto _self;
  final $Res Function(GetMessagesRequestDto) _then;

/// Create a copy of GetMessagesRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatRoomId = null,}) {
  return _then(_self.copyWith(
chatRoomId: null == chatRoomId ? _self.chatRoomId : chatRoomId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GetMessagesRequestDto].
extension GetMessagesRequestDtoPatterns on GetMessagesRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetMessagesRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetMessagesRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetMessagesRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _GetMessagesRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetMessagesRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _GetMessagesRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'chat_rooms_id')  String chatRoomId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetMessagesRequestDto() when $default != null:
return $default(_that.chatRoomId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'chat_rooms_id')  String chatRoomId)  $default,) {final _that = this;
switch (_that) {
case _GetMessagesRequestDto():
return $default(_that.chatRoomId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'chat_rooms_id')  String chatRoomId)?  $default,) {final _that = this;
switch (_that) {
case _GetMessagesRequestDto() when $default != null:
return $default(_that.chatRoomId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetMessagesRequestDto implements GetMessagesRequestDto {
  const _GetMessagesRequestDto({@JsonKey(name: 'chat_rooms_id') required this.chatRoomId});
  factory _GetMessagesRequestDto.fromJson(Map<String, dynamic> json) => _$GetMessagesRequestDtoFromJson(json);

@override@JsonKey(name: 'chat_rooms_id') final  String chatRoomId;

/// Create a copy of GetMessagesRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetMessagesRequestDtoCopyWith<_GetMessagesRequestDto> get copyWith => __$GetMessagesRequestDtoCopyWithImpl<_GetMessagesRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetMessagesRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetMessagesRequestDto&&(identical(other.chatRoomId, chatRoomId) || other.chatRoomId == chatRoomId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatRoomId);

@override
String toString() {
  return 'GetMessagesRequestDto(chatRoomId: $chatRoomId)';
}


}

/// @nodoc
abstract mixin class _$GetMessagesRequestDtoCopyWith<$Res> implements $GetMessagesRequestDtoCopyWith<$Res> {
  factory _$GetMessagesRequestDtoCopyWith(_GetMessagesRequestDto value, $Res Function(_GetMessagesRequestDto) _then) = __$GetMessagesRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'chat_rooms_id') String chatRoomId
});




}
/// @nodoc
class __$GetMessagesRequestDtoCopyWithImpl<$Res>
    implements _$GetMessagesRequestDtoCopyWith<$Res> {
  __$GetMessagesRequestDtoCopyWithImpl(this._self, this._then);

  final _GetMessagesRequestDto _self;
  final $Res Function(_GetMessagesRequestDto) _then;

/// Create a copy of GetMessagesRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatRoomId = null,}) {
  return _then(_GetMessagesRequestDto(
chatRoomId: null == chatRoomId ? _self.chatRoomId : chatRoomId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DeleteConversationRequestDto {

@JsonKey(name: 'chat_rooms_id') String get chatRoomId;
/// Create a copy of DeleteConversationRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteConversationRequestDtoCopyWith<DeleteConversationRequestDto> get copyWith => _$DeleteConversationRequestDtoCopyWithImpl<DeleteConversationRequestDto>(this as DeleteConversationRequestDto, _$identity);

  /// Serializes this DeleteConversationRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteConversationRequestDto&&(identical(other.chatRoomId, chatRoomId) || other.chatRoomId == chatRoomId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatRoomId);

@override
String toString() {
  return 'DeleteConversationRequestDto(chatRoomId: $chatRoomId)';
}


}

/// @nodoc
abstract mixin class $DeleteConversationRequestDtoCopyWith<$Res>  {
  factory $DeleteConversationRequestDtoCopyWith(DeleteConversationRequestDto value, $Res Function(DeleteConversationRequestDto) _then) = _$DeleteConversationRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'chat_rooms_id') String chatRoomId
});




}
/// @nodoc
class _$DeleteConversationRequestDtoCopyWithImpl<$Res>
    implements $DeleteConversationRequestDtoCopyWith<$Res> {
  _$DeleteConversationRequestDtoCopyWithImpl(this._self, this._then);

  final DeleteConversationRequestDto _self;
  final $Res Function(DeleteConversationRequestDto) _then;

/// Create a copy of DeleteConversationRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatRoomId = null,}) {
  return _then(_self.copyWith(
chatRoomId: null == chatRoomId ? _self.chatRoomId : chatRoomId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteConversationRequestDto].
extension DeleteConversationRequestDtoPatterns on DeleteConversationRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteConversationRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteConversationRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteConversationRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _DeleteConversationRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteConversationRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteConversationRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'chat_rooms_id')  String chatRoomId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeleteConversationRequestDto() when $default != null:
return $default(_that.chatRoomId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'chat_rooms_id')  String chatRoomId)  $default,) {final _that = this;
switch (_that) {
case _DeleteConversationRequestDto():
return $default(_that.chatRoomId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'chat_rooms_id')  String chatRoomId)?  $default,) {final _that = this;
switch (_that) {
case _DeleteConversationRequestDto() when $default != null:
return $default(_that.chatRoomId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeleteConversationRequestDto implements DeleteConversationRequestDto {
  const _DeleteConversationRequestDto({@JsonKey(name: 'chat_rooms_id') required this.chatRoomId});
  factory _DeleteConversationRequestDto.fromJson(Map<String, dynamic> json) => _$DeleteConversationRequestDtoFromJson(json);

@override@JsonKey(name: 'chat_rooms_id') final  String chatRoomId;

/// Create a copy of DeleteConversationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteConversationRequestDtoCopyWith<_DeleteConversationRequestDto> get copyWith => __$DeleteConversationRequestDtoCopyWithImpl<_DeleteConversationRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteConversationRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteConversationRequestDto&&(identical(other.chatRoomId, chatRoomId) || other.chatRoomId == chatRoomId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatRoomId);

@override
String toString() {
  return 'DeleteConversationRequestDto(chatRoomId: $chatRoomId)';
}


}

/// @nodoc
abstract mixin class _$DeleteConversationRequestDtoCopyWith<$Res> implements $DeleteConversationRequestDtoCopyWith<$Res> {
  factory _$DeleteConversationRequestDtoCopyWith(_DeleteConversationRequestDto value, $Res Function(_DeleteConversationRequestDto) _then) = __$DeleteConversationRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'chat_rooms_id') String chatRoomId
});




}
/// @nodoc
class __$DeleteConversationRequestDtoCopyWithImpl<$Res>
    implements _$DeleteConversationRequestDtoCopyWith<$Res> {
  __$DeleteConversationRequestDtoCopyWithImpl(this._self, this._then);

  final _DeleteConversationRequestDto _self;
  final $Res Function(_DeleteConversationRequestDto) _then;

/// Create a copy of DeleteConversationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatRoomId = null,}) {
  return _then(_DeleteConversationRequestDto(
chatRoomId: null == chatRoomId ? _self.chatRoomId : chatRoomId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
