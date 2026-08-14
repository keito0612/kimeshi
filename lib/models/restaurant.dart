import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant.freezed.dart';
part 'restaurant.g.dart';

@freezed
abstract class Restaurant with _$Restaurant {
  const factory Restaurant({
    required String id,
    required String name,
    required String address,
    required double lat,
    required double lng,
    required String budget,
    required String genre,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'hotpepper_url') required String hotpepperUrl,
  }) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
}
