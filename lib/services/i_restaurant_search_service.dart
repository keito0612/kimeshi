import '../models/restaurant.dart';

abstract class IRestaurantSearchService {
  Future<(Restaurant?, int)> findNext({
    String? budget,
    String? genre,
    int radius,
    List<String> excludeIds,
  });
}
