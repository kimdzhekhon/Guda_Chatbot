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

 String get title;@JsonKey(name: 'classic_type') String get classicType;@JsonKey(name: 'user_id') String get userId;
/// Create a copy of CreateConversationRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateConversationRequestDtoCopyWith<CreateConversationRequestDto> get copyWith => _$CreateConversationRequestDtoCopyWithImpl<CreateConversationRequestDto>(this as CreateConversationRequestDto, _$identity);

  /// Serializes this CreateConversationRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateConversationRequestDto&&(identical(other.title, title) || other.title == title)&&(identical(other.classicType, classicType) || other.classicType == classicType)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,classicType,userId);

@override
String toString() {
  return 'CreateConversationRequestDto(title: $title, classicType: $classicType, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $CreateConversationRequestDtoCopyWith<$Res>  {
  factory $CreateConversationRequestDtoCopyWith(CreateConversationRequestDto value, $Res Function(CreateConversationRequestDto) _then) = _$CreateConversationRequestDtoCopyWithImpl;
@useResult
$Res call({
 String title,@JsonKey(name: 'classic_type') String classicType,@JsonKey(name: 'user_id') String userId
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
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? classicType = null,Object? userId = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,classicType: null == classicType ? _self.classicType : classicType // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'classic_type')  String classicType, @JsonKey(name: 'user_id')  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateConversationRequestDto() when $default != null:
return $default(_that.title,_that.classicType,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'classic_type')  String classicType, @JsonKey(name: 'user_id')  String userId)  $default,) {final _that = this;
switch (_that) {
case _CreateConversationRequestDto():
return $default(_that.title,_that.classicType,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @JsonKey(name: 'classic_type')  String classicType, @JsonKey(name: 'user_id')  String userId)?  $default,) {final _that = this;
switch (_that) {
case _CreateConversationRequestDto() when $default != null:
return $default(_that.title,_that.classicType,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateConversationRequestDto implements CreateConversationRequestDto {
  const _CreateConversationRequestDto({required this.title, @JsonKey(name: 'classic_type') required this.classicType, @JsonKey(name: 'user_id') required this.userId});
  factory _CreateConversationRequestDto.fromJson(Map<String, dynamic> json) => _$CreateConversationRequestDtoFromJson(json);

@override final  String title;
@override@JsonKey(name: 'classic_type') final  String classicType;
@override@JsonKey(name: 'user_id') final  String userId;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateConversationRequestDto&&(identical(other.title, title) || other.title == title)&&(identical(other.classicType, classicType) || other.classicType == classicType)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,classicType,userId);

@override
String toString() {
  return 'CreateConversationRequestDto(title: $title, classicType: $classicType, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$CreateConversationRequestDtoCopyWith<$Res> implements $CreateConversationRequestDtoCopyWith<$Res> {
  factory _$CreateConversationRequestDtoCopyWith(_CreateConversationRequestDto value, $Res Function(_CreateConversationRequestDto) _then) = __$CreateConversationRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String title,@JsonKey(name: 'classic_type') String classicType,@JsonKey(name: 'user_id') String userId
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
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? classicType = null,Object? userId = null,}) {
  return _then(_CreateConversationRequestDto(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,classicType: null == classicType ? _self.classicType : classicType // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SaveMessageRequestDto {

@JsonKey(name: 'conversation_id') String get conversationId; String get content; String get role;
/// Create a copy of SaveMessageRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveMessageRequestDtoCopyWith<SaveMessageRequestDto> get copyWith => _$SaveMessageRequestDtoCopyWithImpl<SaveMessageRequestDto>(this as SaveMessageRequestDto, _$identity);

  /// Serializes this SaveMessageRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveMessageRequestDto&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.content, content) || other.content == content)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,content,role);

@override
String toString() {
  return 'SaveMessageRequestDto(conversationId: $conversationId, content: $content, role: $role)';
}


}

/// @nodoc
abstract mixin class $SaveMessageRequestDtoCopyWith<$Res>  {
  factory $SaveMessageRequestDtoCopyWith(SaveMessageRequestDto value, $Res Function(SaveMessageRequestDto) _then) = _$SaveMessageRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conversation_id') String conversationId, String content, String role
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
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? content = null,Object? role = null,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id')  String conversationId,  String content,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveMessageRequestDto() when $default != null:
return $default(_that.conversationId,_that.content,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id')  String conversationId,  String content,  String role)  $default,) {final _that = this;
switch (_that) {
case _SaveMessageRequestDto():
return $default(_that.conversationId,_that.content,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'conversation_id')  String conversationId,  String content,  String role)?  $default,) {final _that = this;
switch (_that) {
case _SaveMessageRequestDto() when $default != null:
return $default(_that.conversationId,_that.content,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaveMessageRequestDto implements SaveMessageRequestDto {
  const _SaveMessageRequestDto({@JsonKey(name: 'conversation_id') required this.conversationId, required this.content, required this.role});
  factory _SaveMessageRequestDto.fromJson(Map<String, dynamic> json) => _$SaveMessageRequestDtoFromJson(json);

@override@JsonKey(name: 'conversation_id') final  String conversationId;
@override final  String content;
@override final  String role;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveMessageRequestDto&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.content, content) || other.content == content)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,content,role);

@override
String toString() {
  return 'SaveMessageRequestDto(conversationId: $conversationId, content: $content, role: $role)';
}


}

/// @nodoc
abstract mixin class _$SaveMessageRequestDtoCopyWith<$Res> implements $SaveMessageRequestDtoCopyWith<$Res> {
  factory _$SaveMessageRequestDtoCopyWith(_SaveMessageRequestDto value, $Res Function(_SaveMessageRequestDto) _then) = __$SaveMessageRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'conversation_id') String conversationId, String content, String role
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
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? content = null,Object? role = null,}) {
  return _then(_SaveMessageRequestDto(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
