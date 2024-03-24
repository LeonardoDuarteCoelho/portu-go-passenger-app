import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel
{
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? tripPrice;
  String? carModel;
  String? carNumber;
  String? carColor;
  String? carType;
  String? driverName;
  String? passengerId;

  TripsHistoryModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.carModel,
    this.carNumber,
    this.carColor,
    this.carType,
    this.driverName,
    this.passengerId,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot)
  {
    time = (dataSnapshot.value as Map)['time'];
    originAddress = (dataSnapshot.value as Map)['originAddress'];
    destinationAddress = (dataSnapshot.value as Map)['destinationAddress'];
    status = (dataSnapshot.value as Map)['status'];
    tripPrice = (dataSnapshot.value as Map)['tripPrice'];
    carModel = (dataSnapshot.value as Map)['driverCarInfo']['carModel'];
    carNumber = (dataSnapshot.value as Map)['driverCarInfo']['carNumber'];
    carColor = (dataSnapshot.value as Map)['driverCarInfo']['carColor'];
    carType = (dataSnapshot.value as Map)['driverCarInfo']['carType'];
    driverName = (dataSnapshot.value as Map)['driverName'];
    passengerId = (dataSnapshot.value as Map)['passengerId'];
  }
}