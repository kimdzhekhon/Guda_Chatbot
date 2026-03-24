// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationDto {

 String get id; String get title;@JsonKey(name: 'classic_type') String get classicType;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'last_message_preview') String? get lastMessagePreview;@JsonKey(name: 'message_count') int get messageCount;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationDtoCopyWith<ConversationDto> get copyWith => _$ConversationDtoCopyWithImpl<ConversationDto>(this as ConversationDto, _$identity);

  /// Serializes this ConversationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.classicType, classicType) || other.classicType == classicType)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastMessagePreview, lastMessagePreview) || other.lastMessagePreview == lastMessagePreview)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,classicType,userId,lastMessagePreview,messageCount,createdAt,updatedAt);

@override
String toString() {
  return 'ConversationDto(id: $id, title: $title, classicType: $classicType, userId: $userId, lastMessagePreview: $lastMessagePreview, messageCount: $messageCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ConversationDtoCopyWith<$Res>  {
  factory $ConversationDtoCopyWith(ConversationDto value, $Res Function(ConversationDto) _then) = _$ConversationDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'classic_type') String classicType,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'last_message_preview') String? lastMessagePreview,@JsonKey(name: 'message_count') int messageCount,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class _$ConversationDtoCopyWithImpl<$Res>
    implements $ConversationDtoCopyWith<$Res> {
  _$ConversationDtoCopyWithImpl(this._self, this._then);

  final ConversationDto _self;
  final $Res Function(ConversationDto) _then;

/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? classicType = null,Object? userId = null,Object? lastMessagePreview = freezed,Object? messageCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,classicType: null == classicType ? _self.classicType : classicType // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,lastMessagePreview: freezed == lastMessagePreview ? _self.lastMessagePreview : lastMessagePreview // ignore: cast_nullable_to_non_nullable
as String?,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationDto].
extension ConversationDtoPatterns on ConversationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationDto value)  $default,){
final _that = this;
switch (_that) {
case _ConversationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationDto value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'classic_type')  String classicType, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'last_message_preview')  String? lastMessagePreview, @JsonKey(name: 'message_count')  int messageCount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationDto() when $default != null:
return $default(_that.id,_that.title,_that.classicType,_that.userId,_that.lastMessagePreview,_that.messageCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'classic_type')  String classicType, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'last_message_preview')  String? lastMessagePreview, @JsonKey(name: 'message_count')  int messageCount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ConversationDto():
return $default(_that.id,_that.title,_that.classicType,_that.userId,_that.lastMessagePreview,_that.messageCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'classic_type')  String classicType, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'last_message_preview')  String? lastMessagePreview, @JsonKey(name: 'message_count')  int messageCount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ConversationDto() when $default != null:
return $default(_that.id,_that.title,_that.classicType,_that.userId,_that.lastMessagePreview,_that.messageCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationDto extends ConversationDto {
  const _ConversationDto({required this.id, required this.title, @JsonKey(name: 'classic_type') required this.classicType, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'last_message_preview') this.lastMessagePreview, @JsonKey(name: 'message_count') this.messageCount = 0, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _ConversationDto.fromJson(Map<String, dynamic> json) => _$ConversationDtoFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(name: 'classic_type') final  String classicType;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'last_message_preview') final  String? lastMessagePreview;
@override@JsonKey(name: 'message_count') final  int messageCount;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationDtoCopyWith<_ConversationDto> get copyWith => __$ConversationDtoCopyWithImpl<_ConversationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.classicType, classicType) || other.classicType == classicType)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastMessagePreview, lastMessagePreview) || other.lastMessagePreview == lastMessagePreview)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,classicType,userId,lastMessagePreview,messageCount,createdAt,updatedAt);

@override
String toString() {
  return 'ConversationDto(id: $id, title: $title, classicType: $classicType, userId: $userId, lastMessagePreview: $lastMessagePreview, messageCount: $messageCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ConversationDtoCopyWith<$Res> implements $ConversationDtoCopyWith<$Res> {
  factory _$ConversationDtoCopyWith(_ConversationDto value, $Res Function(_ConversationDto) _then) = __$ConversationDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'classic_type') String classicType,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'last_message_preview') String? lastMessagePreview,@JsonKey(name: 'message_count') int messageCount,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class __$ConversationDtoCopyWithImpl<$Res>
    implements _$ConversationDtoCopyWith<$Res> {
  __$ConversationDtoCopyWithImpl(this._self, this._then);

  final _ConversationDto _self;
  final $Res Function(_ConversationDto) _then;

/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? classicType = null,Object? userId = null,Object? lastMessagePreview = freezed,Object? messageCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ConversationDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,classicType: null == classicType ? _self.classicType : classicType // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,lastMessagePreview: freezed == lastMessagePreview ? _self.lastMessagePreview : lastMessagePreview // ignore: cast_nullable_to_non_nullable
as String?,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
