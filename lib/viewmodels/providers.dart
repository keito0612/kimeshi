import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_client.dart';
import '../repositories/i_location_repository.dart';
import '../repositories/i_restaurant_repository.dart';
import '../repositories/location_repository.dart';
import '../repositories/restaurant_repository.dart';
import '../repositories/settings_repository.dart';
import '../services/i_restaurant_search_service.dart';
import '../services/restaurant_search_service.dart';

// SharedPreferences Provider (main.dartで初期化する)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

// API Client
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Repositories
final locationRepositoryProvider = Provider<ILocationRepository>((ref) {
  return LocationRepository();
});

final restaurantRepositoryProvider = Provider<IRestaurantRepository>((ref) {
  return RestaurantRepository(ref.read(apiClientProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.read(sharedPreferencesProvider));
});

// Services
final restaurantSearchServiceProvider = Provider<IRestaurantSearchService>((ref) {
  return RestaurantSearchService(
    ref.read(locationRepositoryProvider),
    ref.read(restaurantRepositoryProvider),
  );
});
