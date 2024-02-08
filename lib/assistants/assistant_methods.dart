import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:portu_go_passenger/global/global.dart';
import 'package:portu_go_passenger/models/passenger_model.dart';

class AssistantMethods {

  static void getCurrentOnlinePassengerInfo() async {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference passengersRef = FirebaseDatabase
    .instance
    .ref()
    .child("passengers")
    .child(currentFirebaseUser!.uid);
    passengersRef.once().then((snap) {
      if(snap.snapshot.value != null) {
        passengerModelCurrentInfo = PassengerModel.fromSnapshot(snap.snapshot);
      }
    });
  }
}