// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hexagram.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Hexagram {

/// 괘 번호 (1-64)
 int get id;/// 한글 이름
 String get name;/// 한문 이름
 String get hanja;/// 6효(爻)의 상태 (이진수 문자열, 예: "111111" = 건괘)
/// 1: 양(陽) — 끊어지지 않은 선
/// 0: 음(陰) — 가운데가 끊어진 선
/// 밑에서부터 첫 번째 효가 문자열의 첫 번째 문자
 String get binary;/// 풀이 요약
 String get summary;
/// Create a copy of Hexagram
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HexagramCopyWith<Hexagram> get copyWith => _$HexagramCopyWithImpl<Hexagram>(this as Hexagram, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hexagram&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hanja, hanja) || other.hanja == hanja)&&(identical(other.binary, binary) || other.binary == binary)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,hanja,binary,summary);

@override
String toString() {
  return 'Hexagram(id: $id, name: $name, hanja: $hanja, binary: $binary, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $HexagramCopyWith<$Res>  {
  factory $HexagramCopyWith(Hexagram value, $Res Function(Hexagram) _then) = _$HexagramCopyWithImpl;
@useResult
$Res call({
 int id, String name, String hanja, String binary, String summary
});




}
/// @nodoc
class _$HexagramCopyWithImpl<$Res>
    implements $HexagramCopyWith<$Res> {
  _$HexagramCopyWithImpl(this._self, this._then);

  final Hexagram _self;
  final $Res Function(Hexagram) _then;

/// Create a copy of Hexagram
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? hanja = null,Object? binary = null,Object? summary = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hanja: null == hanja ? _self.hanja : hanja // ignore: cast_nullable_to_non_nullable
as String,binary: null == binary ? _self.binary : binary // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Hexagram].
extension HexagramPatterns on Hexagram {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hexagram value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hexagram() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hexagram value)  $default,){
final _that = this;
switch (_that) {
case _Hexagram():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hexagram value)?  $default,){
final _that = this;
switch (_that) {
case _Hexagram() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String hanja,  String binary,  String summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hexagram() when $default != null:
return $default(_that.id,_that.name,_that.hanja,_that.binary,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String hanja,  String binary,  String summary)  $default,) {final _that = this;
switch (_that) {
case _Hexagram():
return $default(_that.id,_that.name,_that.hanja,_that.binary,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String hanja,  String binary,  String summary)?  $default,) {final _that = this;
switch (_that) {
case _Hexagram() when $default != null:
return $default(_that.id,_that.name,_that.hanja,_that.binary,_that.summary);case _:
  return null;

}
}

}

/// @nodoc


class _Hexagram extends Hexagram {
  const _Hexagram({required this.id, required this.name, required this.hanja, required this.binary, required this.summary}): super._();
  

/// 괘 번호 (1-64)
@override final  int id;
/// 한글 이름
@override final  String name;
/// 한문 이름
@override final  String hanja;
/// 6효(爻)의 상태 (이진수 문자열, 예: "111111" = 건괘)
/// 1: 양(陽) — 끊어지지 않은 선
/// 0: 음(陰) — 가운데가 끊어진 선
/// 밑에서부터 첫 번째 효가 문자열의 첫 번째 문자
@override final  String binary;
/// 풀이 요약
@override final  String summary;

/// Create a copy of Hexagram
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HexagramCopyWith<_Hexagram> get copyWith => __$HexagramCopyWithImpl<_Hexagram>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hexagram&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hanja, hanja) || other.hanja == hanja)&&(identical(other.binary, binary) || other.binary == binary)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,hanja,binary,summary);

@override
String toString() {
  return 'Hexagram(id: $id, name: $name, hanja: $hanja, binary: $binary, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$HexagramCopyWith<$Res> implements $HexagramCopyWith<$Res> {
  factory _$HexagramCopyWith(_Hexagram value, $Res Function(_Hexagram) _then) = __$HexagramCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String hanja, String binary, String summary
});




}
/// @nodoc
class __$HexagramCopyWithImpl<$Res>
    implements _$HexagramCopyWith<$Res> {
  __$HexagramCopyWithImpl(this._self, this._then);

  final _Hexagram _self;
  final $Res Function(_Hexagram) _then;

/// Create a copy of Hexagram
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? hanja = null,Object? binary = null,Object? summary = null,}) {
  return _then(_Hexagram(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hanja: null == hanja ? _self.hanja : hanja // ignore: cast_nullable_to_non_nullable
as String,binary: null == binary ? _self.binary : binary // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
