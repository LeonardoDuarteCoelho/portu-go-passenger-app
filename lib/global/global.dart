import 'package:firebase_auth/firebase_auth.dart';
import 'package:portu_go_passenger/models/passenger_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
PassengerModel? passengerModelCurrentInfo;
bool ifUserSearchesPickUpLocation = false;
bool ifUserSearchesDropOffLocation = false;