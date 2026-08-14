import '../models/restaurant.dart';
import '../models/search_params.dart';

abstract class IRestaurantRepository {
  Future<(Restaurant?, int)> suggest(SearchParams params);
}
