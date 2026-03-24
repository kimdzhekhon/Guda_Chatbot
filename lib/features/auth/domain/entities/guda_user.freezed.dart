// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guda_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GudaUser {

/// Supabase 사용자 UUID
 String get id;/// 이메일 주소
 String get email;/// 표시 이름 (Google 계정 이름)
 String? get displayName;/// Google 프로필 사진 URL
 String? get photoUrl;/// 계정 생성 일시
 DateTime get createdAt;
/// Create a copy of GudaUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GudaUserCopyWith<GudaUser> get copyWith => _$GudaUserCopyWithImpl<GudaUser>(this as GudaUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GudaUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,displayName,photoUrl,createdAt);

@override
String toString() {
  return 'GudaUser(id: $id, email: $email, displayName: $displayName, photoUrl: $photoUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GudaUserCopyWith<$Res>  {
  factory $GudaUserCopyWith(GudaUser value, $Res Function(GudaUser) _then) = _$GudaUserCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? displayName, String? photoUrl, DateTime createdAt
});




}
/// @nodoc
class _$GudaUserCopyWithImpl<$Res>
    implements $GudaUserCopyWith<$Res> {
  _$GudaUserCopyWithImpl(this._self, this._then);

  final GudaUser _self;
  final $Res Function(GudaUser) _then;

/// Create a copy of GudaUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? displayName = freezed,Object? photoUrl = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GudaUser].
extension GudaUserPatterns on GudaUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GudaUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GudaUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GudaUser value)  $default,){
final _that = this;
switch (_that) {
case _GudaUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GudaUser value)?  $default,){
final _that = this;
switch (_that) {
case _GudaUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? displayName,  String? photoUrl,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GudaUser() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.photoUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? displayName,  String? photoUrl,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _GudaUser():
return $default(_that.id,_that.email,_that.displayName,_that.photoUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? displayName,  String? photoUrl,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GudaUser() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.photoUrl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _GudaUser implements GudaUser {
  const _GudaUser({required this.id, required this.email, this.displayName, this.photoUrl, required this.createdAt});
  

/// Supabase 사용자 UUID
@override final  String id;
/// 이메일 주소
@override final  String email;
/// 표시 이름 (Google 계정 이름)
@override final  String? displayName;
/// Google 프로필 사진 URL
@override final  String? photoUrl;
/// 계정 생성 일시
@override final  DateTime createdAt;

/// Create a copy of GudaUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GudaUserCopyWith<_GudaUser> get copyWith => __$GudaUserCopyWithImpl<_GudaUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GudaUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,displayName,photoUrl,createdAt);

@override
String toString() {
  return 'GudaUser(id: $id, email: $email, displayName: $displayName, photoUrl: $photoUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GudaUserCopyWith<$Res> implements $GudaUserCopyWith<$Res> {
  factory _$GudaUserCopyWith(_GudaUser value, $Res Function(_GudaUser) _then) = __$GudaUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? displayName, String? photoUrl, DateTime createdAt
});




}
/// @nodoc
class __$GudaUserCopyWithImpl<$Res>
    implements _$GudaUserCopyWith<$Res> {
  __$GudaUserCopyWithImpl(this._self, this._then);

  final _GudaUser _self;
  final $Res Function(_GudaUser) _then;

/// Create a copy of GudaUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = freezed,Object? photoUrl = freezed,Object? createdAt = null,}) {
  return _then(_GudaUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
