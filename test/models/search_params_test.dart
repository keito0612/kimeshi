import 'package:flutter_test/flutter_test.dart';
import 'package:kimeshi/models/search_params.dart';

void main() {
  group('SearchParams', () {
    test('should create SearchParams with required fields', () {
      final params = SearchParams(
        lat: 35.6581,
        lng: 139.7017,
      );

      expect(params.lat, 35.6581);
      expect(params.lng, 139.7017);
      expect(params.budget, isNull);
      expect(params.genre, isNull);
      expect(params.radius, 1000); // default value
      expect(params.excludeIds, isEmpty);
      expect(params.limit, 20); // default value
    });

    test('should create SearchParams with all fields', () {
      final params = SearchParams(
        lat: 35.6581,
        lng: 139.7017,
        budget: '2000',
        genre: 'japanese',
        radius: 500,
        excludeIds: ['id1', 'id2'],
        limit: 30,
      );

      expect(params.lat, 35.6581);
      expect(params.lng, 139.7017);
      expect(params.budget, '2000');
      expect(params.genre, 'japanese');
      expect(params.radius, 500);
      expect(params.excludeIds, ['id1', 'id2']);
      expect(params.limit, 30);
    });

    test('should create SearchParams from JSON', () {
      final json = {
        'lat': 35.6581,
        'lng': 139.7017,
        'budget': '2000',
        'genre': 'japanese',
        'radius': 500,
        'excludeIds': ['id1', 'id2'],
        'limit': 30,
      };

      final params = SearchParams.fromJson(json);

      expect(params.lat, 35.6581);
      expect(params.lng, 139.7017);
      expect(params.budget, '2000');
      expect(params.genre, 'japanese');
      expect(params.radius, 500);
      expect(params.limit, 30);
    });

    test('should convert SearchParams to JSON', () {
      final params = SearchParams(
        lat: 35.6581,
        lng: 139.7017,
        budget: '2000',
        genre: 'japanese',
        radius: 500,
        limit: 30,
      );

      final json = params.toJson();

      expect(json['lat'], 35.6581);
      expect(json['lng'], 139.7017);
      expect(json['budget'], '2000');
      expect(json['genre'], 'japanese');
      expect(json['radius'], 500);
      expect(json['limit'], 30);
    });

    test('should support equality', () {
      final params1 = SearchParams(lat: 35.6581, lng: 139.7017);
      final params2 = SearchParams(lat: 35.6581, lng: 139.7017);

      expect(params1, equals(params2));
    });

    test('should support copyWith', () {
      final params = SearchParams(lat: 35.6581, lng: 139.7017);
      final updated = params.copyWith(budget: '3000', radius: 2000);

      expect(updated.budget, '3000');
      expect(updated.radius, 2000);
      expect(updated.lat, 35.6581);
      expect(updated.lng, 139.7017);
    });
  });
}
