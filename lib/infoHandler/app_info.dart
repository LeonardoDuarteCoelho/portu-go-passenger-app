import 'package:flutter/cupertino.dart';
import 'package:portu_go_passenger/models/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? passengerPickUpLocation, passengerDropOffLocation;

  void updatePickUpAddress(Directions passengerPickUpAddress) {
    passengerPickUpLocation = passengerPickUpAddress;
    notifyListeners();
  }

  void updateDropOffAddress(Directions passengerDropOffAddress) {
    passengerDropOffLocation = passengerDropOffAddress;
    notifyListeners();
  }
}