import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:portu_go_passenger/global/global.dart';
import 'package:portu_go_passenger/global/map_api_key.dart';
import 'package:portu_go_passenger/infoHandler/app_info.dart';
import 'package:portu_go_passenger/models/direction_route_details.dart';
import 'package:portu_go_passenger/models/directions.dart';
import 'package:portu_go_passenger/models/passenger_model.dart';
import 'package:portu_go_passenger/assistants/assistant_request.dart';
import 'package:portu_go_passenger/infoHandler/app_info.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoordinates(Position position, context) async {
    String apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    String addressNumber = '';
    String streetName = '';
    String humanReadableAddress = '';
    var requestResponse = await AssistantRequest.receiveRequest(apiUrl);

    // If the request response doesn't return as any of the possible error messages...
    if(requestResponse != AppStrings.connectToApiError) {
      // Response that will contain the human-readable address. This syntax is used to navigate inside a JSON file.
      // (for more info check documentation: https://developers.google.com/maps/documentation/geocoding/start)
      streetName = requestResponse['results'][0]['address_components'][1]['long_name'];
      addressNumber = requestResponse['results'][0]['address_components'][0]['long_name'];
      humanReadableAddress = '$streetName $addressNumber';
      Directions passengerPickUpAddress = Directions(); // Storing the passenger's readable address data.
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

  static Future<DirectionRouteDetails?> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails = 'https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey';
    var responseDirectionsApi = await AssistantRequest.receiveRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionsApi == AppStrings.connectToApiError) {
      return null;
    }
    DirectionRouteDetails directionRouteDetails = DirectionRouteDetails();
    // For navigating this JSON file, see documentation: https://developers.google.com/maps/documentation/directions/start
    directionRouteDetails.ePoints = responseDirectionsApi['routes'][0]['overview_polyline']['points'];
    directionRouteDetails.distanceText = responseDirectionsApi['routes'][0]['legs'][0]['distance']['text'];
    directionRouteDetails.distanceValue = responseDirectionsApi['routes'][0]['legs'][0]['distance']['value'];
    directionRouteDetails.durationText = responseDirectionsApi['routes'][0]['legs'][0]['duration']['text'];
    directionRouteDetails.durationValue = responseDirectionsApi['routes'][0]['legs'][0]['duration']['value'];

    return directionRouteDetails;
  }

  /// Method responsible for calculating and setting the appropriate fare considering the distance traveled
  /// during the ride and its duration. Monetary values regarding the ride costs and the variables designed
  /// to calculate the fare are all located inside this method.
  ///
  /// Note: If you wish to modify the change of price when the passenger chooses a Prime-type car, search for
  /// variable 'primeTypeCarFareAmountIncrease'.
  static double calculateFareAmountFromOriginToDestination(DirectionRouteDetails directionRouteDetails) {
    double dollarsChargedPerMinute = 0.1; // The amount of dollars charged per minute.
    double dollarsChargedPerKilometer = 0.1; // The amount of dollars charged per kilometer.
    double dollarToEuroRatio = 0.95; // US$ 1.00  =  € 0.95

    // Billing fare formula for the ride's duration:
    double timeTraveledFareAmountPerMinute = (directionRouteDetails.durationValue! / 60) * dollarsChargedPerMinute;
    // Billing fare formula for the ride's distance:
    double timeTraveledFareAmountPerKilometer = (directionRouteDetails.distanceValue! / 1000) * dollarsChargedPerKilometer;
    // Total billing fare (US$ CURRENCY):
    double totalFareAmountInDollars = timeTraveledFareAmountPerMinute + timeTraveledFareAmountPerKilometer;
    // Total billing fare (€ CURRENCY):
    double totalFareAmountInEuros = totalFareAmountInDollars * dollarToEuroRatio;

    return double.parse(totalFareAmountInEuros.toStringAsFixed(2));
  }
}