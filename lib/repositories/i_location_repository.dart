import '../models/location.dart';

abstract class ILocationRepository {
  Future<Location> getCurrentLocation();
}
