import 'package:flutter_test/flutter_test.dart';
import 'package:kimeshi/models/restaurant.dart';

void main() {
  group('Restaurant', () {
    test('should create Restaurant from constructor', () {
      final restaurant = Restaurant(
        id: '1',
        name: 'テスト店舗',
        address: '東京都渋谷区1-1-1',
        lat: 35.6581,
        lng: 139.7017,
        budget: '1000円〜2000円',
        genre: '和食',
        imageUrl: 'https://example.com/image.jpg',
        hotpepperUrl: 'https://www.hotpepper.jp/test',
      );

      expect(restaurant.id, '1');
      expect(restaurant.name, 'テスト店舗');
      expect(restaurant.address, '東京都渋谷区1-1-1');
      expect(restaurant.lat, 35.6581);
      expect(restaurant.lng, 139.7017);
      expect(restaurant.budget, '1000円〜2000円');
      expect(restaurant.genre, '和食');
      expect(restaurant.imageUrl, 'https://example.com/image.jpg');
      expect(restaurant.hotpepperUrl, 'https://www.hotpepper.jp/test');
    });

    test('should create Restaurant with null imageUrl', () {
      final restaurant = Restaurant(
        id: '1',
        name: 'テスト店舗',
        address: '東京都渋谷区1-1-1',
        lat: 35.6581,
        lng: 139.7017,
        budget: '1000円〜2000円',
        genre: '和食',
        hotpepperUrl: 'https://www.hotpepper.jp/test',
      );

      expect(restaurant.imageUrl, isNull);
    });

    test('should create Restaurant from JSON', () {
      final json = {
        'id': '1',
        'name': 'テスト店舗',
        'address': '東京都渋谷区1-1-1',
        'lat': 35.6581,
        'lng': 139.7017,
        'budget': '1000円〜2000円',
        'genre': '和食',
        'image_url': 'https://example.com/image.jpg',
        'hotpepper_url': 'https://www.hotpepper.jp/test',
      };

      final restaurant = Restaurant.fromJson(json);

      expect(restaurant.id, '1');
      expect(restaurant.name, 'テスト店舗');
      expect(restaurant.imageUrl, 'https://example.com/image.jpg');
      expect(restaurant.hotpepperUrl, 'https://www.hotpepper.jp/test');
    });

    test('should convert Restaurant to JSON', () {
      final restaurant = Restaurant(
        id: '1',
        name: 'テスト店舗',
        address: '東京都渋谷区1-1-1',
        lat: 35.6581,
        lng: 139.7017,
        budget: '1000円〜2000円',
        genre: '和食',
        imageUrl: 'https://example.com/image.jpg',
        hotpepperUrl: 'https://www.hotpepper.jp/test',
      );

      final json = restaurant.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'テスト店舗');
      expect(json['image_url'], 'https://example.com/image.jpg');
      expect(json['hotpepper_url'], 'https://www.hotpepper.jp/test');
    });

    test('should support equality', () {
      final restaurant1 = Restaurant(
        id: '1',
        name: 'テスト店舗',
        address: '東京都渋谷区1-1-1',
        lat: 35.6581,
        lng: 139.7017,
        budget: '1000円〜2000円',
        genre: '和食',
        hotpepperUrl: 'https://www.hotpepper.jp/test',
      );

      final restaurant2 = Restaurant(
        id: '1',
        name: 'テスト店舗',
        address: '東京都渋谷区1-1-1',
        lat: 35.6581,
        lng: 139.7017,
        budget: '1000円〜2000円',
        genre: '和食',
        hotpepperUrl: 'https://www.hotpepper.jp/test',
      );

      expect(restaurant1, equals(restaurant2));
    });

    test('should support copyWith', () {
      final restaurant = Restaurant(
        id: '1',
        name: 'テスト店舗',
        address: '東京都渋谷区1-1-1',
        lat: 35.6581,
        lng: 139.7017,
        budget: '1000円〜2000円',
        genre: '和食',
        hotpepperUrl: 'https://www.hotpepper.jp/test',
      );

      final updated = restaurant.copyWith(name: '更新店舗');

      expect(updated.name, '更新店舗');
      expect(updated.id, '1'); // 他のフィールドは変更なし
    });
  });
}
