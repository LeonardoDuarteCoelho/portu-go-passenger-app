import 'package:firebase_auth/firebase_auth.dart';
import 'package:portu_go_passenger/models/passenger_model.dart';

import '../models/direction_route_details.dart';
import '../models/nearby_available_drivers.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
PassengerModel? passengerModelCurrentInfo;
List driversList = []; // Driver keys info list.
DirectionRouteDetails? tripDirectionRouteDetails;
String? selectedDriverId = '';
String cloudMessagingUrl = 'https://fcm.googleapis.com/v1/projects/portugo-c7f05/messages:send';
String driverOnTripCarModel = '';
String driverOnTripCarColor = '';
String driverOnTripCarNumber = '';
String driverOnTripCarType = '';
String driverOnTripName = '';
String driverOnTripPhone = '';
int maxNumberOfRatingStarts = 5;
double passengerRatingForDriver = 0;
String driverRatingDescription = '';
bool ifDarkThemeIsActive = false;
int numberOfNearbyAvailableDrivers = 0;
int numberOfTripsToBeDisplayedInHistory = 0;
// TODO: Replace this placeholder URL, which is the one for the Figma project, with the real URL for the website:
const portuGoWebsiteUrl = 'https://www.figma.com/file/RoybjZ7YVGofmuPIOL3yZi/PortuGO-Layouts?type=design&node-id=0-1&mode=design&t=gbdp1JyJlpgoAWWy-0';
