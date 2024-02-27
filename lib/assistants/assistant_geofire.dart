import '../models/nearby_available_drivers.dart';

class AssistantGeofire {
  static List<NearbyAvailableDrivers> nearbyAvailableDriversList = [];

  /// This method deletes objects from 'nearbyAvailableDriversList' object list.
  static void deleteOfflineDriverFromNearbyAvailableDriversList(String driverId) {
    int indexNumber = nearbyAvailableDriversList.indexWhere((element) => element.driverId == driverId);
    nearbyAvailableDriversList.removeAt(indexNumber);
  }

  /// This method will update the nearby available driver location.
  static void updateNearbyAvailableDriverLocation(NearbyAvailableDrivers nearbyAvailableDriverUpdatedLocation) {
    int indexNumber = nearbyAvailableDriversList.indexWhere((element) => element.driverId == nearbyAvailableDriverUpdatedLocation.driverId);
    // Updating the new latitude and longitude of this nearby available driver:
    nearbyAvailableDriversList[indexNumber].driverLocationLatitude = nearbyAvailableDriverUpdatedLocation.driverLocationLatitude;
    nearbyAvailableDriversList[indexNumber].driverLocationLongitude = nearbyAvailableDriverUpdatedLocation.driverLocationLongitude;
  }
}