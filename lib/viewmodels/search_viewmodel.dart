import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/restaurant.dart';
import '../repositories/settings_repository.dart';
import 'providers.dart';

// 検索状態
class SearchState {
  final bool isLoading;
  final Restaurant? restaurant;
  final int remainingCount;
  final String? errorMessage;
  final List<String> excludeIds;
  final String? selectedBudget;
  final String? selectedGenre;
  final int radius;
  final int limit;

  const SearchState({
    this.isLoading = false,
    this.restaurant,
    this.remainingCount = 0,
    this.errorMessage,
    this.excludeIds = const [],
    this.selectedBudget,
    this.selectedGenre,
    this.radius = 1000,
    this.limit = 20,
  });

  SearchState copyWith({
    bool? isLoading,
    Restaurant? restaurant,
    int? remainingCount,
    String? errorMessage,
    List<String>? excludeIds,
    String? selectedBudget,
    String? selectedGenre,
    int? radius,
    int? limit,
    bool clearRestaurant = false,
    bool clearError = false,
    bool clearBudget = false,
    bool clearGenre = false,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      restaurant: clearRestaurant ? null : (restaurant ?? this.restaurant),
      remainingCount: remainingCount ?? this.remainingCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      excludeIds: excludeIds ?? this.excludeIds,
      selectedBudget:
          clearBudget ? null : (selectedBudget ?? this.selectedBudget),
      selectedGenre: clearGenre ? null : (selectedGenre ?? this.selectedGenre),
      radius: radius ?? this.radius,
      limit: limit ?? this.limit,
    );
  }
}

// ViewModel
class SearchViewModel extends StateNotifier<SearchState> {
  final Ref _ref;
  final SettingsRepository _settings;

  SearchViewModel(this._ref, this._settings)
      : super(SearchState(
          selectedBudget: _settings.defaultBudget,
          selectedGenre: _settings.defaultGenre,
          radius: _settings.defaultRadius,
          limit: _settings.defaultSearchLimit,
        ));

  void setBudget(String? budget) {
    state = state.copyWith(selectedBudget: budget);
  }

  void setGenre(String? genre) {
    state = state.copyWith(selectedGenre: genre);
  }

  void setRadius(int radius) {
    state = state.copyWith(radius: radius);
  }

  Future<void> search() async {
    state = state.copyWith(isLoading: true, clearError: true, excludeIds: []);

    try {
      final service = _ref.read(restaurantSearchServiceProvider);
      final (restaurant, remainingCount) = await service.findNext(
        budget: state.selectedBudget,
        genre: state.selectedGenre,
        radius: state.radius,
        excludeIds: state.excludeIds,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoading: false,
        restaurant: restaurant,
        remainingCount: remainingCount,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> skipAndFindNext() async {
    if (state.restaurant == null) return;

    final newExcludeIds = [...state.excludeIds, state.restaurant!.id];
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearRestaurant: true,
      excludeIds: newExcludeIds,
    );

    try {
      final service = _ref.read(restaurantSearchServiceProvider);
      final (restaurant, remainingCount) = await service.findNext(
        budget: state.selectedBudget,
        genre: state.selectedGenre,
        radius: state.radius,
        excludeIds: newExcludeIds,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoading: false,
        restaurant: restaurant,
        remainingCount: remainingCount,
      );
    } catch (e) {
      // お店が見つからない場合はrestaurantをnullのままにする
      state = state.copyWith(isLoading: false, remainingCount: 0);
    }
  }

  void reset() {
    state = SearchState(
      selectedBudget: _settings.defaultBudget,
      selectedGenre: _settings.defaultGenre,
      radius: _settings.defaultRadius,
      limit: _settings.defaultSearchLimit,
    );
  }

  /// デフォルト設定を再読み込み
  void reloadDefaults() {
    state = state.copyWith(
      selectedBudget: _settings.defaultBudget,
      selectedGenre: _settings.defaultGenre,
      radius: _settings.defaultRadius,
      limit: _settings.defaultSearchLimit,
      clearBudget: _settings.defaultBudget == null,
      clearGenre: _settings.defaultGenre == null,
    );
  }
}

// Provider
final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, SearchState>((ref) {
      final settings = ref.read(settingsRepositoryProvider);
      return SearchViewModel(ref, settings);
    });
