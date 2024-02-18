import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:portu_go_passenger/global/global.dart';
import 'package:portu_go_passenger/global/map_api_key.dart';
import 'package:portu_go_passenger/infoHandler/app_info.dart';
import 'package:portu_go_passenger/models/directions.dart';
import 'package:portu_go_passenger/models/passenger_model.dart';
import 'package:portu_go_passenger/assistants/assistant_request.dart';
import 'package:portu_go_passenger/infoHandler/app_info.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoordinates(Position position, context) async {
    String apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    String humanReadableAddress = '';
    var requestResponse = await AssistantRequest.receiveRequest(apiUrl);

    // If the request response doesn't return as any of the possible error messages...
    if(requestResponse != AppStrings.connectToApiError) {
      // Response that will contain the human-readable address. This syntax is used to navigate inside a JSON file.
      // (for more info check documentation: https://developers.google.com/maps/documentation/geocoding/start)
      humanReadableAddress = requestResponse['results'][0]['formatted_address'];
      // Storing the passenger's readable address data:
      Directions passengerPickUpAddress = Directions();
      passengerPickUpAddress.locationLatitude = position.latitude;
      passengerPickUpAddress.locationLongitude = position.longitude;
      passengerPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpAddress(passengerPickUpAddress);
    }
    return humanReadableAddress;
  }

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