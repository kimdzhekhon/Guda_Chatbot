// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Conversation {

/// Supabase 대화 UUID
 String get id;/// 대화 제목 (첫 메시지 기반 자동 생성)
 String get title;/// 주제 코드 (고전 유형)
 ClassicType get topicCode;/// 소유자 사용자 ID
 String get userId;/// 마지막 메시지 미리보기
 String? get lastMessagePreview;/// 메시지 총 개수
 int get messageCount;/// 생성 일시
 DateTime get createdAt;/// 최종 메시지 일시
 DateTime get lastMessageAt;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.topicCode, topicCode) || other.topicCode == topicCode)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastMessagePreview, lastMessagePreview) || other.lastMessagePreview == lastMessagePreview)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,topicCode,userId,lastMessagePreview,messageCount,createdAt,lastMessageAt);

@override
String toString() {
  return 'Conversation(id: $id, title: $title, topicCode: $topicCode, userId: $userId, lastMessagePreview: $lastMessagePreview, messageCount: $messageCount, createdAt: $createdAt, lastMessageAt: $lastMessageAt)';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
 String id, String title, ClassicType topicCode, String userId, String? lastMessagePreview, int messageCount, DateTime createdAt, DateTime lastMessageAt
});




}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? topicCode = null,Object? userId = null,Object? lastMessagePreview = freezed,Object? messageCount = null,Object? createdAt = null,Object? lastMessageAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,topicCode: null == topicCode ? _self.topicCode : topicCode // ignore: cast_nullable_to_non_nullable
as ClassicType,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,lastMessagePreview: freezed == lastMessagePreview ? _self.lastMessagePreview : lastMessagePreview // ignore: cast_nullable_to_non_nullable
as String?,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  ClassicType topicCode,  String userId,  String? lastMessagePreview,  int messageCount,  DateTime createdAt,  DateTime lastMessageAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.title,_that.topicCode,_that.userId,_that.lastMessagePreview,_that.messageCount,_that.createdAt,_that.lastMessageAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  ClassicType topicCode,  String userId,  String? lastMessagePreview,  int messageCount,  DateTime createdAt,  DateTime lastMessageAt)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.id,_that.title,_that.topicCode,_that.userId,_that.lastMessagePreview,_that.messageCount,_that.createdAt,_that.lastMessageAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  ClassicType topicCode,  String userId,  String? lastMessagePreview,  int messageCount,  DateTime createdAt,  DateTime lastMessageAt)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.title,_that.topicCode,_that.userId,_that.lastMessagePreview,_that.messageCount,_that.createdAt,_that.lastMessageAt);case _:
  return null;

}
}

}

/// @nodoc


class _Conversation implements Conversation {
  const _Conversation({required this.id, required this.title, required this.topicCode, required this.userId, this.lastMessagePreview, this.messageCount = 0, required this.createdAt, required this.lastMessageAt});
  

/// Supabase 대화 UUID
@override final  String id;
/// 대화 제목 (첫 메시지 기반 자동 생성)
@override final  String title;
/// 주제 코드 (고전 유형)
@override final  ClassicType topicCode;
/// 소유자 사용자 ID
@override final  String userId;
/// 마지막 메시지 미리보기
@override final  String? lastMessagePreview;
/// 메시지 총 개수
@override@JsonKey() final  int messageCount;
/// 생성 일시
@override final  DateTime createdAt;
/// 최종 메시지 일시
@override final  DateTime lastMessageAt;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.topicCode, topicCode) || other.topicCode == topicCode)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastMessagePreview, lastMessagePreview) || other.lastMessagePreview == lastMessagePreview)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,topicCode,userId,lastMessagePreview,messageCount,createdAt,lastMessageAt);

@override
String toString() {
  return 'Conversation(id: $id, title: $title, topicCode: $topicCode, userId: $userId, lastMessagePreview: $lastMessagePreview, messageCount: $messageCount, createdAt: $createdAt, lastMessageAt: $lastMessageAt)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, ClassicType topicCode, String userId, String? lastMessagePreview, int messageCount, DateTime createdAt, DateTime lastMessageAt
});




}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? topicCode = null,Object? userId = null,Object? lastMessagePreview = freezed,Object? messageCount = null,Object? createdAt = null,Object? lastMessageAt = null,}) {
  return _then(_Conversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,topicCode: null == topicCode ? _self.topicCode : topicCode // ignore: cast_nullable_to_non_nullable
as ClassicType,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,lastMessagePreview: freezed == lastMessagePreview ? _self.lastMessagePreview : lastMessagePreview // ignore: cast_nullable_to_non_nullable
as String?,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
