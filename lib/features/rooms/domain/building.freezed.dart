// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'building.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Building {

 String get id; String get name;@JsonKey(name: 'total_floors') int get totalFloors;@JsonKey(name: 'svg_asset_name') String get svgAssetName;
/// Create a copy of Building
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BuildingCopyWith<Building> get copyWith => _$BuildingCopyWithImpl<Building>(this as Building, _$identity);

  /// Serializes this Building to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Building&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.totalFloors, totalFloors) || other.totalFloors == totalFloors)&&(identical(other.svgAssetName, svgAssetName) || other.svgAssetName == svgAssetName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,totalFloors,svgAssetName);

@override
String toString() {
  return 'Building(id: $id, name: $name, totalFloors: $totalFloors, svgAssetName: $svgAssetName)';
}


}

/// @nodoc
abstract mixin class $BuildingCopyWith<$Res>  {
  factory $BuildingCopyWith(Building value, $Res Function(Building) _then) = _$BuildingCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'total_floors') int totalFloors,@JsonKey(name: 'svg_asset_name') String svgAssetName
});




}
/// @nodoc
class _$BuildingCopyWithImpl<$Res>
    implements $BuildingCopyWith<$Res> {
  _$BuildingCopyWithImpl(this._self, this._then);

  final Building _self;
  final $Res Function(Building) _then;

/// Create a copy of Building
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? totalFloors = null,Object? svgAssetName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,totalFloors: null == totalFloors ? _self.totalFloors : totalFloors // ignore: cast_nullable_to_non_nullable
as int,svgAssetName: null == svgAssetName ? _self.svgAssetName : svgAssetName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Building].
extension BuildingPatterns on Building {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Building value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Building() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Building value)  $default,){
final _that = this;
switch (_that) {
case _Building():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Building value)?  $default,){
final _that = this;
switch (_that) {
case _Building() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'total_floors')  int totalFloors, @JsonKey(name: 'svg_asset_name')  String svgAssetName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Building() when $default != null:
return $default(_that.id,_that.name,_that.totalFloors,_that.svgAssetName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'total_floors')  int totalFloors, @JsonKey(name: 'svg_asset_name')  String svgAssetName)  $default,) {final _that = this;
switch (_that) {
case _Building():
return $default(_that.id,_that.name,_that.totalFloors,_that.svgAssetName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'total_floors')  int totalFloors, @JsonKey(name: 'svg_asset_name')  String svgAssetName)?  $default,) {final _that = this;
switch (_that) {
case _Building() when $default != null:
return $default(_that.id,_that.name,_that.totalFloors,_that.svgAssetName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Building implements Building {
  const _Building({required this.id, required this.name, @JsonKey(name: 'total_floors') required this.totalFloors, @JsonKey(name: 'svg_asset_name') required this.svgAssetName});
  factory _Building.fromJson(Map<String, dynamic> json) => _$BuildingFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'total_floors') final  int totalFloors;
@override@JsonKey(name: 'svg_asset_name') final  String svgAssetName;

/// Create a copy of Building
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BuildingCopyWith<_Building> get copyWith => __$BuildingCopyWithImpl<_Building>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BuildingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Building&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.totalFloors, totalFloors) || other.totalFloors == totalFloors)&&(identical(other.svgAssetName, svgAssetName) || other.svgAssetName == svgAssetName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,totalFloors,svgAssetName);

@override
String toString() {
  return 'Building(id: $id, name: $name, totalFloors: $totalFloors, svgAssetName: $svgAssetName)';
}


}

/// @nodoc
abstract mixin class _$BuildingCopyWith<$Res> implements $BuildingCopyWith<$Res> {
  factory _$BuildingCopyWith(_Building value, $Res Function(_Building) _then) = __$BuildingCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'total_floors') int totalFloors,@JsonKey(name: 'svg_asset_name') String svgAssetName
});




}
/// @nodoc
class __$BuildingCopyWithImpl<$Res>
    implements _$BuildingCopyWith<$Res> {
  __$BuildingCopyWithImpl(this._self, this._then);

  final _Building _self;
  final $Res Function(_Building) _then;

/// Create a copy of Building
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? totalFloors = null,Object? svgAssetName = null,}) {
  return _then(_Building(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,totalFloors: null == totalFloors ? _self.totalFloors : totalFloors // ignore: cast_nullable_to_non_nullable
as int,svgAssetName: null == svgAssetName ? _self.svgAssetName : svgAssetName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
