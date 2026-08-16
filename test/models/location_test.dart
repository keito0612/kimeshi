import 'package:flutter_test/flutter_test.dart';
import 'package:kimeshi/models/location.dart';

void main() {
  group('Location', () {
    test('should create Location from constructor', () {
      final location = Location(
        lat: 35.6581,
        lng: 139.7017,
        address: '東京都渋谷区',
      );

      expect(location.lat, 35.6581);
      expect(location.lng, 139.7017);
      expect(location.address, '東京都渋谷区');
    });

    test('should create Location with null address', () {
      final location = Location(
        lat: 35.6581,
        lng: 139.7017,
      );

      expect(location.lat, 35.6581);
      expect(location.lng, 139.7017);
      expect(location.address, isNull);
    });

    test('should create Location from JSON', () {
      final json = {
        'lat': 35.6581,
        'lng': 139.7017,
        'address': '東京都渋谷区',
      };

      final location = Location.fromJson(json);

      expect(location.lat, 35.6581);
      expect(location.lng, 139.7017);
      expect(location.address, '東京都渋谷区');
    });

    test('should convert Location to JSON', () {
      final location = Location(
        lat: 35.6581,
        lng: 139.7017,
        address: '東京都渋谷区',
      );

      final json = location.toJson();

      expect(json['lat'], 35.6581);
      expect(json['lng'], 139.7017);
      expect(json['address'], '東京都渋谷区');
    });

    test('should support equality', () {
      final location1 = Location(lat: 35.6581, lng: 139.7017);
      final location2 = Location(lat: 35.6581, lng: 139.7017);

      expect(location1, equals(location2));
    });

    test('should support copyWith', () {
      final location = Location(lat: 35.6581, lng: 139.7017);
      final updated = location.copyWith(address: '新しい住所');

      expect(updated.address, '新しい住所');
      expect(updated.lat, 35.6581);
      expect(updated.lng, 139.7017);
    });
  });
}
