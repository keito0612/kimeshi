import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_params.freezed.dart';
part 'search_params.g.dart';

@freezed
abstract class SearchParams with _$SearchParams {
  const factory SearchParams({
    required double lat,
    required double lng,
    String? budget,
    String? genre,
    @Default(1000) int radius,
    @Default([]) List<String> excludeIds,
  }) = _SearchParams;

  factory SearchParams.fromJson(Map<String, dynamic> json) =>
      _$SearchParamsFromJson(json);
}
