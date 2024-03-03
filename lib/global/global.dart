import 'package:firebase_auth/firebase_auth.dart';
import 'package:portu_go_passenger/models/passenger_model.dart';

import '../models/direction_route_details.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
PassengerModel? passengerModelCurrentInfo;
List driversList = []; // Driver keys info list.
DirectionRouteDetails? tripDirectionRouteDetails;

