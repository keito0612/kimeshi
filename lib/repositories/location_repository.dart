import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import '../core/exceptions/app_exception.dart';
import '../models/location.dart';
import 'i_location_repository.dart';

class LocationRepository implements ILocationRepository {
  @override
  Future<Location> getCurrentLocation() async {
    try {
      // 位置情報サービスの確認
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const LocationException(message: '位置情報サービスが無効です');
      }

      // パーミッション確認
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const LocationException(message: '位置情報の権限が拒否されました');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationException(message: '位置情報の権限が永久に拒否されています');
      }

      // 現在地取得
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // 住所取得（オプション）
      String? address;
      try {
        final placemarks = await geocoding.Geocoding().placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          address =
              '${place.administrativeArea ?? ''}${place.locality ?? ''}${place.subLocality ?? ''}';
        }
      } catch (_) {
        throw NetworkException();
      }

      // 座標が有効かチェック
      if (position.latitude.isNaN || position.longitude.isNaN) {
        throw const LocationException(message: '有効な位置情報を取得できませんでした');
      }

      return Location(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      // Error logged silently - actual exception is thrown below
      throw const LocationException();
    }
  }
}
