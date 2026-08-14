// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => _Restaurant(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  budget: json['budget'] as String,
  genre: json['genre'] as String,
  imageUrl: json['image_url'] as String?,
  hotpepperUrl: json['hotpepper_url'] as String,
);

Map<String, dynamic> _$RestaurantToJson(_Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'budget': instance.budget,
      'genre': instance.genre,
      'image_url': instance.imageUrl,
      'hotpepper_url': instance.hotpepperUrl,
    };
