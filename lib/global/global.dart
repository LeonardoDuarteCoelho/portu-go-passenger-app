import 'package:firebase_auth/firebase_auth.dart';
import 'package:portu_go_passenger/models/passenger_model.dart';

import '../models/direction_route_details.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
PassengerModel? passengerModelCurrentInfo;
List driversList = []; // Driver keys info list.
DirectionRouteDetails? tripDirectionRouteDetails;
String? selectedDriverId = '';
String cloudMessagingUrl = 'https://fcm.googleapis.com/v1/projects/portugo-c7f05/messages:send';
String cloudMessagingOAuth2 = 'Bearer ya29.a0Ad52N3-62jCM_xeMCUVFeatLtHHe2kSZXTdNd_MZwpIsrUZyXl-P-5Sqkt8O2fiL_z74HNJ3x_zrTZrmRCI087tTAWob2enLXdRGXX1a_pctUqr24_mkOAv6-zCp7GrIM1W5KflpRA0KmOsfIlan8__wkiq2ej4zC8AaCgYKAdoSARASFQHGX2Mi9T1pShkZ-yZkapgPjo793g0170';
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
// TODO: Replace this placeholder URL, which is the one for the Figma project, with the real URL for the website:
const portuGoWebsiteUrl = 'https://www.figma.com/file/RoybjZ7YVGofmuPIOL3yZi/PortuGO-Layouts?type=design&node-id=0-1&mode=design&t=gbdp1JyJlpgoAWWy-0';
