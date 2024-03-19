import 'package:flutter/cupertino.dart';
import 'package:portu_go_passenger/models/directions.dart';
import 'package:portu_go_passenger/models/trips_history_model.dart';

class AppInfo extends ChangeNotifier {
  Directions? passengerPickUpLocation, passengerDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripsKeysList = [];
  List<TripsHistoryModel> tripHistoryInfoList = [];

  void updatePickUpAddress(Directions passengerPickUpAddress) {
    passengerPickUpLocation = passengerPickUpAddress;
    notifyListeners();
  }

  void updateDropOffAddress(Directions passengerDropOffAddress) {
    passengerDropOffLocation = passengerDropOffAddress;
    notifyListeners();
  }

  void updateTripsCounter(int tripsCounter) {
    countTotalTrips = tripsCounter;
    notifyListeners();
  }

  void updateTripsKeys(List<String> tripsKeysList) {
    historyTripsKeysList = tripsKeysList;
    notifyListeners();
  }

  void updateTripsHistoryInfo(TripsHistoryModel eachTripHistory) {
    tripHistoryInfoList.add(eachTripHistory);
    notifyListeners();
  }
}