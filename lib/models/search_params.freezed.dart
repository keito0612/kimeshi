// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchParams {

 double get lat; double get lng; String? get budget; String? get genre; int get radius; List<String> get excludeIds; int get limit;
/// Create a copy of SearchParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchParamsCopyWith<SearchParams> get copyWith => _$SearchParamsCopyWithImpl<SearchParams>(this as SearchParams, _$identity);

  /// Serializes this SearchParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchParams&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.radius, radius) || other.radius == radius)&&const DeepCollectionEquality().equals(other.excludeIds, excludeIds)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,budget,genre,radius,const DeepCollectionEquality().hash(excludeIds),limit);

@override
String toString() {
  return 'SearchParams(lat: $lat, lng: $lng, budget: $budget, genre: $genre, radius: $radius, excludeIds: $excludeIds, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $SearchParamsCopyWith<$Res>  {
  factory $SearchParamsCopyWith(SearchParams value, $Res Function(SearchParams) _then) = _$SearchParamsCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, String? budget, String? genre, int radius, List<String> excludeIds, int limit
});




}
/// @nodoc
class _$SearchParamsCopyWithImpl<$Res>
    implements $SearchParamsCopyWith<$Res> {
  _$SearchParamsCopyWithImpl(this._self, this._then);

  final SearchParams _self;
  final $Res Function(SearchParams) _then;

/// Create a copy of SearchParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? budget = freezed,Object? genre = freezed,Object? radius = null,Object? excludeIds = null,Object? limit = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as int,excludeIds: null == excludeIds ? _self.excludeIds : excludeIds // ignore: cast_nullable_to_non_nullable
as List<String>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchParams].
extension SearchParamsPatterns on SearchParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchParams value)  $default,){
final _that = this;
switch (_that) {
case _SearchParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchParams value)?  $default,){
final _that = this;
switch (_that) {
case _SearchParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  String? budget,  String? genre,  int radius,  List<String> excludeIds,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchParams() when $default != null:
return $default(_that.lat,_that.lng,_that.budget,_that.genre,_that.radius,_that.excludeIds,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  String? budget,  String? genre,  int radius,  List<String> excludeIds,  int limit)  $default,) {final _that = this;
switch (_that) {
case _SearchParams():
return $default(_that.lat,_that.lng,_that.budget,_that.genre,_that.radius,_that.excludeIds,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  String? budget,  String? genre,  int radius,  List<String> excludeIds,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _SearchParams() when $default != null:
return $default(_that.lat,_that.lng,_that.budget,_that.genre,_that.radius,_that.excludeIds,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchParams implements SearchParams {
  const _SearchParams({required this.lat, required this.lng, this.budget, this.genre, this.radius = 1000, final  List<String> excludeIds = const [], this.limit = 20}): _excludeIds = excludeIds;
  factory _SearchParams.fromJson(Map<String, dynamic> json) => _$SearchParamsFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  String? budget;
@override final  String? genre;
@override@JsonKey() final  int radius;
 final  List<String> _excludeIds;
@override@JsonKey() List<String> get excludeIds {
  if (_excludeIds is EqualUnmodifiableListView) return _excludeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_excludeIds);
}

@override@JsonKey() final  int limit;

/// Create a copy of SearchParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchParamsCopyWith<_SearchParams> get copyWith => __$SearchParamsCopyWithImpl<_SearchParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchParams&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.radius, radius) || other.radius == radius)&&const DeepCollectionEquality().equals(other._excludeIds, _excludeIds)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,budget,genre,radius,const DeepCollectionEquality().hash(_excludeIds),limit);

@override
String toString() {
  return 'SearchParams(lat: $lat, lng: $lng, budget: $budget, genre: $genre, radius: $radius, excludeIds: $excludeIds, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$SearchParamsCopyWith<$Res> implements $SearchParamsCopyWith<$Res> {
  factory _$SearchParamsCopyWith(_SearchParams value, $Res Function(_SearchParams) _then) = __$SearchParamsCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, String? budget, String? genre, int radius, List<String> excludeIds, int limit
});




}
/// @nodoc
class __$SearchParamsCopyWithImpl<$Res>
    implements _$SearchParamsCopyWith<$Res> {
  __$SearchParamsCopyWithImpl(this._self, this._then);

  final _SearchParams _self;
  final $Res Function(_SearchParams) _then;

/// Create a copy of SearchParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? budget = freezed,Object? genre = freezed,Object? radius = null,Object? excludeIds = null,Object? limit = null,}) {
  return _then(_SearchParams(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as int,excludeIds: null == excludeIds ? _self._excludeIds : excludeIds // ignore: cast_nullable_to_non_nullable
as List<String>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
