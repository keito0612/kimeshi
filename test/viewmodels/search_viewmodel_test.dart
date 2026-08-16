import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kimeshi/models/restaurant.dart';
import 'package:kimeshi/repositories/settings_repository.dart';
import 'package:kimeshi/services/i_restaurant_search_service.dart';
import 'package:kimeshi/viewmodels/search_viewmodel.dart';
import 'package:kimeshi/viewmodels/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockRestaurantSearchService extends Mock
    implements IRestaurantSearchService {}

class MockRef extends Mock implements Ref {}

void main() {
  late SettingsRepository settingsRepository;
  late MockRestaurantSearchService mockSearchService;
  late MockRef mockRef;

  final testRestaurant = Restaurant(
    id: '1',
    name: 'テスト店舗',
    address: '東京都渋谷区1-1-1',
    lat: 35.6581,
    lng: 139.7017,
    budget: '1000円〜2000円',
    genre: '和食',
    hotpepperUrl: 'https://www.hotpepper.jp/test',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    settingsRepository = SettingsRepository(prefs);
    mockSearchService = MockRestaurantSearchService();
    mockRef = MockRef();

    when(
      () => mockRef.read(restaurantSearchServiceProvider),
    ).thenReturn(mockSearchService);
  });

  group('SearchState', () {
    test('should have default values', () {
      const state = SearchState();

      expect(state.isLoading, false);
      expect(state.restaurant, isNull);
      expect(state.remainingCount, 0);
      expect(state.errorMessage, isNull);
      expect(state.excludeIds, isEmpty);
      expect(state.selectedBudget, isNull);
      expect(state.selectedGenre, isNull);
      expect(state.radius, 1000);
      expect(state.limit, 20);
    });

    test('copyWith should update specified fields', () {
      const state = SearchState();
      final updated = state.copyWith(
        isLoading: true,
        selectedBudget: '2000',
        radius: 500,
      );

      expect(updated.isLoading, true);
      expect(updated.selectedBudget, '2000');
      expect(updated.radius, 500);
      expect(updated.selectedGenre, isNull); // unchanged
    });

    test('copyWith with clearBudget should set budget to null', () {
      final state = const SearchState().copyWith(selectedBudget: '2000');
      final cleared = state.copyWith(clearBudget: true);

      expect(cleared.selectedBudget, isNull);
    });

    test('copyWith with clearGenre should set genre to null', () {
      final state = const SearchState().copyWith(selectedGenre: 'japanese');
      final cleared = state.copyWith(clearGenre: true);

      expect(cleared.selectedGenre, isNull);
    });

    test('copyWith with clearRestaurant should set restaurant to null', () {
      final state = SearchState(restaurant: testRestaurant);
      final cleared = state.copyWith(clearRestaurant: true);

      expect(cleared.restaurant, isNull);
    });

    test('copyWith with clearError should set errorMessage to null', () {
      final state = const SearchState().copyWith(
        errorMessage: 'Error occurred',
      );
      final cleared = state.copyWith(clearError: true);

      expect(cleared.errorMessage, isNull);
    });
  });

  group('SearchViewModel', () {
    test('should initialize with default settings', () {
      final viewModel = SearchViewModel(mockRef, settingsRepository);

      expect(viewModel.state.selectedBudget, isNull);
      expect(viewModel.state.selectedGenre, isNull);
      expect(viewModel.state.radius, 1000);
      expect(viewModel.state.limit, 20);
    });

    test('setBudget should update selectedBudget', () {
      final viewModel = SearchViewModel(mockRef, settingsRepository);

      viewModel.setBudget('2000');

      expect(viewModel.state.selectedBudget, '2000');
    });

    test('setGenre should update selectedGenre', () {
      final viewModel = SearchViewModel(mockRef, settingsRepository);

      viewModel.setGenre('japanese');

      expect(viewModel.state.selectedGenre, 'japanese');
    });

    test('setRadius should update radius', () {
      final viewModel = SearchViewModel(mockRef, settingsRepository);

      viewModel.setRadius(500);

      expect(viewModel.state.radius, 500);
    });

    test('search should update state with restaurant on success', () async {
      when(
        () => mockSearchService.findNext(
          budget: any(named: 'budget'),
          genre: any(named: 'genre'),
          radius: any(named: 'radius'),
          excludeIds: any(named: 'excludeIds'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => (testRestaurant, 5));

      final viewModel = SearchViewModel(mockRef, settingsRepository);
      viewModel.setBudget('2000');
      viewModel.setGenre('japanese');
      viewModel.setRadius(20);

      await viewModel.search();

      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.restaurant, testRestaurant);
      expect(viewModel.state.remainingCount, 5);
      expect(viewModel.state.radius, 20);
      expect(viewModel.state.errorMessage, isNull);
    });

    test('search should update state with error on failure', () async {
      when(
        () => mockSearchService.findNext(
          budget: any(named: 'budget'),
          genre: any(named: 'genre'),
          radius: any(named: 'radius'),
          excludeIds: any(named: 'excludeIds'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(Exception('Network error'));

      final viewModel = SearchViewModel(mockRef, settingsRepository);

      await viewModel.search();

      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.restaurant, isNull);
      expect(viewModel.state.errorMessage, contains('Network error'));
    });

    test(
      'skipAndFindNext should add current restaurant to excludeIds',
      () async {
        when(
          () => mockSearchService.findNext(
            budget: any(named: 'budget'),
            genre: any(named: 'genre'),
            radius: any(named: 'radius'),
            excludeIds: any(named: 'excludeIds'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => (testRestaurant, 5));

        final viewModel = SearchViewModel(mockRef, settingsRepository);

        // First search
        await viewModel.search();
        expect(viewModel.state.restaurant, testRestaurant);

        // Setup for skip
        final newRestaurant = testRestaurant.copyWith(id: '2', name: '新しい店舗');
        when(
          () => mockSearchService.findNext(
            budget: any(named: 'budget'),
            genre: any(named: 'genre'),
            radius: any(named: 'radius'),
            excludeIds: any(named: 'excludeIds'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => (newRestaurant, 4));

        // Skip and find next
        await viewModel.skipAndFindNext();

        expect(viewModel.state.excludeIds, contains('1'));
        expect(viewModel.state.restaurant?.id, '2');
      },
    );

    test('skipAndFindNext should do nothing if no restaurant', () async {
      final viewModel = SearchViewModel(mockRef, settingsRepository);

      await viewModel.skipAndFindNext();

      expect(viewModel.state.excludeIds, isEmpty);
      verifyNever(
        () => mockSearchService.findNext(
          budget: any(named: 'budget'),
          genre: any(named: 'genre'),
          radius: any(named: 'radius'),
          excludeIds: any(named: 'excludeIds'),
          limit: any(named: 'limit'),
        ),
      );
    });

    test('reset should restore to initial state', () async {
      when(
        () => mockSearchService.findNext(
          budget: any(named: 'budget'),
          genre: any(named: 'genre'),
          radius: any(named: 'radius'),
          excludeIds: any(named: 'excludeIds'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => (testRestaurant, 5));

      final viewModel = SearchViewModel(mockRef, settingsRepository);
      viewModel.setBudget('2000');
      viewModel.setGenre('japanese');
      viewModel.setRadius(500);
      await viewModel.search();

      viewModel.reset();

      expect(viewModel.state.selectedBudget, isNull);
      expect(viewModel.state.selectedGenre, isNull);
      expect(viewModel.state.radius, 1000);
      expect(viewModel.state.restaurant, isNull);
      expect(viewModel.state.excludeIds, isEmpty);
    });
  });
}
