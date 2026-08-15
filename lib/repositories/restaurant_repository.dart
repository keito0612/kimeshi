import '../core/api/api_client.dart';
import '../core/exceptions/app_exception.dart';
import '../models/restaurant.dart';
import '../models/search_params.dart';
import 'i_restaurant_repository.dart';

class RestaurantRepository implements IRestaurantRepository {
  final ApiClient _apiClient;

  RestaurantRepository(this._apiClient);

  @override
  Future<(Restaurant?, int)> suggest(SearchParams params) async {
    // 座標のバリデーション
    if (params.lat.isNaN || params.lng.isNaN) {
      throw const LocationException(message: '有効な位置情報がありません');
    }

    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/restaurants/suggest',
        queryParameters: {
          'lat': params.lat,
          'lng': params.lng,
          if (params.budget != null) 'budget': params.budget,
          if (params.genre != null && params.genre != 'all')
            'genre': params.genre,
          'radius': params.radius,
          if (params.excludeIds.isNotEmpty)
            'exclude': params.excludeIds.join(','),
          'limit': params.limit,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const NoResultException();
      }

      // successフラグの確認
      final success = data['success'] as bool? ?? true;
      if (!success) {
        final errorMessage = data['message'] as String? ?? 'エラーが発生しました';
        throw ApiException(message: errorMessage);
      }

      final restaurantData = data['restaurant'];
      final remainingCount = data['remaining_count'] as int? ?? 0;

      if (restaurantData == null) {
        throw const NoResultException();
      }

      final restaurant = Restaurant.fromJson(
        restaurantData as Map<String, dynamic>,
      );

      return (restaurant, remainingCount);
    } catch (e) {
      if (e is AppException) rethrow;
      throw const ApiException();
    }
  }
}
