// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchParams _$SearchParamsFromJson(Map<String, dynamic> json) =>
    _SearchParams(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      budget: json['budget'] as String?,
      genre: json['genre'] as String?,
      radius: (json['radius'] as num?)?.toInt() ?? 1000,
      excludeIds:
          (json['excludeIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SearchParamsToJson(_SearchParams instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'budget': instance.budget,
      'genre': instance.genre,
      'radius': instance.radius,
      'excludeIds': instance.excludeIds,
    };
