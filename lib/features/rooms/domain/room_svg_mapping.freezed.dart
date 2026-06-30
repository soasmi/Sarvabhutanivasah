// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_svg_mapping.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomSvgMapping {

 String get id;@JsonKey(name: 'building_id') String get buildingId;@JsonKey(name: 'room_id') String get roomId;@JsonKey(name: 'svg_element_index') int get svgElementIndex;
/// Create a copy of RoomSvgMapping
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSvgMappingCopyWith<RoomSvgMapping> get copyWith => _$RoomSvgMappingCopyWithImpl<RoomSvgMapping>(this as RoomSvgMapping, _$identity);

  /// Serializes this RoomSvgMapping to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSvgMapping&&(identical(other.id, id) || other.id == id)&&(identical(other.buildingId, buildingId) || other.buildingId == buildingId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.svgElementIndex, svgElementIndex) || other.svgElementIndex == svgElementIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,buildingId,roomId,svgElementIndex);

@override
String toString() {
  return 'RoomSvgMapping(id: $id, buildingId: $buildingId, roomId: $roomId, svgElementIndex: $svgElementIndex)';
}


}

/// @nodoc
abstract mixin class $RoomSvgMappingCopyWith<$Res>  {
  factory $RoomSvgMappingCopyWith(RoomSvgMapping value, $Res Function(RoomSvgMapping) _then) = _$RoomSvgMappingCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'building_id') String buildingId,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'svg_element_index') int svgElementIndex
});




}
/// @nodoc
class _$RoomSvgMappingCopyWithImpl<$Res>
    implements $RoomSvgMappingCopyWith<$Res> {
  _$RoomSvgMappingCopyWithImpl(this._self, this._then);

  final RoomSvgMapping _self;
  final $Res Function(RoomSvgMapping) _then;

/// Create a copy of RoomSvgMapping
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? buildingId = null,Object? roomId = null,Object? svgElementIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,buildingId: null == buildingId ? _self.buildingId : buildingId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,svgElementIndex: null == svgElementIndex ? _self.svgElementIndex : svgElementIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomSvgMapping].
extension RoomSvgMappingPatterns on RoomSvgMapping {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomSvgMapping value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomSvgMapping() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomSvgMapping value)  $default,){
final _that = this;
switch (_that) {
case _RoomSvgMapping():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomSvgMapping value)?  $default,){
final _that = this;
switch (_that) {
case _RoomSvgMapping() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'building_id')  String buildingId, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'svg_element_index')  int svgElementIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomSvgMapping() when $default != null:
return $default(_that.id,_that.buildingId,_that.roomId,_that.svgElementIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'building_id')  String buildingId, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'svg_element_index')  int svgElementIndex)  $default,) {final _that = this;
switch (_that) {
case _RoomSvgMapping():
return $default(_that.id,_that.buildingId,_that.roomId,_that.svgElementIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'building_id')  String buildingId, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'svg_element_index')  int svgElementIndex)?  $default,) {final _that = this;
switch (_that) {
case _RoomSvgMapping() when $default != null:
return $default(_that.id,_that.buildingId,_that.roomId,_that.svgElementIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomSvgMapping implements RoomSvgMapping {
  const _RoomSvgMapping({required this.id, @JsonKey(name: 'building_id') required this.buildingId, @JsonKey(name: 'room_id') required this.roomId, @JsonKey(name: 'svg_element_index') required this.svgElementIndex});
  factory _RoomSvgMapping.fromJson(Map<String, dynamic> json) => _$RoomSvgMappingFromJson(json);

@override final  String id;
@override@JsonKey(name: 'building_id') final  String buildingId;
@override@JsonKey(name: 'room_id') final  String roomId;
@override@JsonKey(name: 'svg_element_index') final  int svgElementIndex;

/// Create a copy of RoomSvgMapping
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomSvgMappingCopyWith<_RoomSvgMapping> get copyWith => __$RoomSvgMappingCopyWithImpl<_RoomSvgMapping>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomSvgMappingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomSvgMapping&&(identical(other.id, id) || other.id == id)&&(identical(other.buildingId, buildingId) || other.buildingId == buildingId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.svgElementIndex, svgElementIndex) || other.svgElementIndex == svgElementIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,buildingId,roomId,svgElementIndex);

@override
String toString() {
  return 'RoomSvgMapping(id: $id, buildingId: $buildingId, roomId: $roomId, svgElementIndex: $svgElementIndex)';
}


}

/// @nodoc
abstract mixin class _$RoomSvgMappingCopyWith<$Res> implements $RoomSvgMappingCopyWith<$Res> {
  factory _$RoomSvgMappingCopyWith(_RoomSvgMapping value, $Res Function(_RoomSvgMapping) _then) = __$RoomSvgMappingCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'building_id') String buildingId,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'svg_element_index') int svgElementIndex
});




}
/// @nodoc
class __$RoomSvgMappingCopyWithImpl<$Res>
    implements _$RoomSvgMappingCopyWith<$Res> {
  __$RoomSvgMappingCopyWithImpl(this._self, this._then);

  final _RoomSvgMapping _self;
  final $Res Function(_RoomSvgMapping) _then;

/// Create a copy of RoomSvgMapping
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? buildingId = null,Object? roomId = null,Object? svgElementIndex = null,}) {
  return _then(_RoomSvgMapping(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,buildingId: null == buildingId ? _self.buildingId : buildingId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,svgElementIndex: null == svgElementIndex ? _self.svgElementIndex : svgElementIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
