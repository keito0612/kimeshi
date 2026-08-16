import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kimeshi/models/location.dart';
import 'package:kimeshi/models/restaurant.dart';
import 'package:kimeshi/models/search_params.dart';
import 'package:kimeshi/repositories/i_location_repository.dart';
import 'package:kimeshi/repositories/i_restaurant_repository.dart';
import 'package:kimeshi/services/restaurant_search_service.dart';

class MockLocationRepository extends Mock implements ILocationRepository {}

class MockRestaurantRepository extends Mock implements IRestaurantRepository {}

class FakeSearchParams extends Fake implements SearchParams {}

void main() {
  late MockLocationRepository mockLocationRepository;
  late MockRestaurantRepository mockRestaurantRepository;
  late RestaurantSearchService service;

  final testLocation = Location(
    lat: 35.6581,
    lng: 139.7017,
    address: '東京都渋谷区',
  );

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

  setUpAll(() {
    registerFallbackValue(FakeSearchParams());
  });

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    mockRestaurantRepository = MockRestaurantRepository();
    service = RestaurantSearchService(
      mockLocationRepository,
      mockRestaurantRepository,
    );
  });

  group('RestaurantSearchService', () {
    test('findNext should return restaurant when found', () async {
      when(() => mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => testLocation);

      when(() => mockRestaurantRepository.suggest(any()))
          .thenAnswer((_) async => (testRestaurant, 5));

      final (restaurant, count) = await service.findNext();

      expect(restaurant, testRestaurant);
      expect(count, 5);

      verify(() => mockLocationRepository.getCurrentLocation()).called(1);
      verify(() => mockRestaurantRepository.suggest(any())).called(1);
    });

    test('findNext should return null when no restaurant found', () async {
      when(() => mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => testLocation);

      when(() => mockRestaurantRepository.suggest(any()))
          .thenAnswer((_) async => (null, 0));

      final (restaurant, count) = await service.findNext();

      expect(restaurant, isNull);
      expect(count, 0);
    });

    test('findNext should pass budget parameter to repository', () async {
      when(() => mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => testLocation);

      when(() => mockRestaurantRepository.suggest(any()))
          .thenAnswer((_) async => (testRestaurant, 3));

      await service.findNext(budget: '2000');

      final captured = verify(
        () => mockRestaurantRepository.suggest(captureAny()),
      ).captured.single as SearchParams;

      expect(captured.budget, '2000');
      expect(captured.lat, testLocation.lat);
      expect(captured.lng, testLocation.lng);
    });

    test('findNext should pass genre parameter to repository', () async {
      when(() => mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => testLocation);

      when(() => mockRestaurantRepository.suggest(any()))
          .thenAnswer((_) async => (testRestaurant, 3));

      await service.findNext(genre: 'japanese');

      final captured = verify(
        () => mockRestaurantRepository.suggest(captureAny()),
      ).captured.single as SearchParams;

      expect(captured.genre, 'japanese');
    });

    test('findNext should pass radius parameter to repository', () async {
      when(() => mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => testLocation);

      when(() => mockRestaurantRepository.suggest(any()))
          .thenAnswer((_) async => (testRestaurant, 3));

      await service.findNext(radius: 500);

      final captured = verify(
        () => mockRestaurantRepository.suggest(captureAny()),
      ).captured.single as SearchParams;

      expect(captured.radius, 500);
    });

    test('findNext should pass excludeIds parameter to repository', () async {
      when(() => mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => testLocation);

      when(() => mockRestaurantRepository.suggest(any()))
          .thenAnswer((_) async => (testRestaurant, 3));

      await service.findNext(excludeIds: ['id1', 'id2']);

      final captured = verify(
        () => mockRestaurantRepository.suggest(captureAny()),
      ).captured.single as SearchParams;

      expect(captured.excludeIds, ['id1', 'id2']);
    });

    test('findNext should pass limit parameter to repository', () async {
      when(() => mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => testLocation);

      when(() => mockRestaurantRepository.suggest(any()))
          .thenAnswer((_) async => (testRestaurant, 3));

      await service.findNext(limit: 30);

      final captured = verify(
        () => mockRestaurantRepository.suggest(captureAny()),
      ).captured.single as SearchParams;

      expect(captured.limit, 30);
    });

    test('findNext should use default values when parameters not provided',
        () async {
      when(() => mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => testLocation);

      when(() => mockRestaurantRepository.suggest(any()))
          .thenAnswer((_) async => (testRestaurant, 3));

      await service.findNext();

      final captured = verify(
        () => mockRestaurantRepository.suggest(captureAny()),
      ).captured.single as SearchParams;

      expect(captured.budget, isNull);
      expect(captured.genre, isNull);
      expect(captured.radius, 1000);
      expect(captured.excludeIds, isEmpty);
      expect(captured.limit, 20);
    });

    test('findNext should throw when location repository fails', () async {
      when(() => mockLocationRepository.getCurrentLocation())
          .thenThrow(Exception('Location error'));

      expect(
        () => service.findNext(),
        throwsA(isA<Exception>()),
      );
    });

    test('findNext should throw when restaurant repository fails', () async {
      when(() => mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => testLocation);

      when(() => mockRestaurantRepository.suggest(any()))
          .thenThrow(Exception('Network error'));

      expect(
        () => service.findNext(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
