import '../models/restaurant.dart';
import '../models/search_params.dart';
import '../repositories/i_location_repository.dart';
import '../repositories/i_restaurant_repository.dart';
import 'i_restaurant_search_service.dart';

class RestaurantSearchService implements IRestaurantSearchService {
  final ILocationRepository _locationRepository;
  final IRestaurantRepository _restaurantRepository;

  RestaurantSearchService(this._locationRepository, this._restaurantRepository);

  @override
  Future<(Restaurant?, int)> findNext({
    String? budget,
    String? genre,
    int radius = 1000,
    List<String> excludeIds = const [],
    int limit = 20,
  }) async {
    // 1. 現在地を取得
    final location = await _locationRepository.getCurrentLocation();
    // 2. 検索パラメータを作成
    final params = SearchParams(
      lat: location.lat,
      lng: location.lng,
      budget: budget,
      genre: genre,
      radius: radius,
      excludeIds: excludeIds,
      limit: limit,
    );

    // 3. 店舗を検索
    return await _restaurantRepository.suggest(params);
  }
}
