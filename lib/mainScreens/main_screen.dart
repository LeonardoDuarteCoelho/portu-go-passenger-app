import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portu_go_passenger/assistants/assistant_geofire.dart';
import 'package:portu_go_passenger/assistants/assistant_methods.dart';
import 'package:portu_go_passenger/authenticationScreens/login_screen.dart';
import 'package:portu_go_passenger/components/button.dart';
import 'package:portu_go_passenger/components/hamburger_button.dart';
import 'package:portu_go_passenger/components/location_permission_warning.dart';
import 'package:portu_go_passenger/components/navigation_drawer.dart';
import 'package:portu_go_passenger/components/progress_dialog.dart';
import 'package:portu_go_passenger/constants.dart';
import 'package:portu_go_passenger/global/global.dart';
import 'package:portu_go_passenger/infoHandler/app_info.dart';
import 'package:portu_go_passenger/mainScreens/rate_driver_screen.dart';
import 'package:portu_go_passenger/mainScreens/search_places_screen.dart';
import 'package:portu_go_passenger/mainScreens/select_nearest_available_drivers_screen.dart';
import 'package:portu_go_passenger/models/direction_route_details.dart';
import 'package:portu_go_passenger/models/nearby_available_drivers.dart';
import 'package:provider/provider.dart';
import '../assistants/assistant_google_map_theme.dart';
import '../components/fare_amount_collection_dialog.dart';
import '../models/directions.dart';
import '../splashScreen/splash_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

/// WARNINGS FROM FLUTTER: Ignore the warnings from Flutter!
class _MainScreenState extends State<MainScreen> {
  bool ifUserGrantedLocationPermission = true; // Whether the app shows a warning telling the user to enable access to location or not.
  bool showRouteConfirmationOptions = false; // Show the user options to confirm or deny the pick-up-to-drop-off route.
  bool ifRouteIsConfirmed = false; // Check if user confirmed the route for selected destination.
  String? pickUpLocationText;
  String? dropOffLocationText;
  String passengerName = '';
  String passengerEmail = '';
  String passengerPhone = '';
  double requestRideContainerHeight = 260; // Request ride container's height.
  double mapControlsContainerHeight = 300; // Map controls' height.
  double waitingDriverResponseContainerHeight = 0;
  double tripPanelContainerHeight = 0;
  LocationPermission? _locationPermission;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<NearbyAvailableDrivers> nearbyAvailableDriversList = [];
  static const CameraPosition _dummyLocation = CameraPosition(
    target: LatLng(0, 0), // Placeholder location when app's still locating user.
    zoom: 17,
  );
  Position? geolocatorPosition;
  LatLng? latitudeAndLongitudePosition;
  Position? passengerCurrentPosition;
  CameraPosition? cameraPosition;
  var geolocator = Geolocator();
  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;
  dynamic responseFromSearchScreen;
  DirectionRouteDetails? directionRouteDetails;
  List<LatLng> polylineCoordinatesList = [];
  Set<Polyline> polylineSet = {};
  LatLngBounds? latLngBounds;
  Set<Marker> markersSet = {};
  bool nearbyAvailableDriverKeysLoaded = false;
  double locateNearDriversRadius = 10;
  BitmapDescriptor? nearbyAvailableDriverIcon;
  DatabaseReference? driversRef;
  DatabaseReference? rideRequestRef;
  Map? originLocationMap;
  Map? destinationLocationMap;
  Map? passengerInformationMap;
  Marker? originMarker;
  Marker? destinationMarker;
  Marker? eachNearbyAvailableDriverMarker;
  LatLng? originLatitudeAndLongitude;
  LatLng? destinationLatitudeAndLongitude;
  Directions? originPosition;
  Directions? destinationPosition;
  String? selectedDriverRegistrationToken;
  String driverRideStatus = AppStrings.driverIsComing;
  StreamSubscription<DatabaseEvent>? streamSubscriptionRideRequestInfoDuringTrip;
  double? driverLatitudeDuringTrip;
  double? driverLongitudeDuringTrip;
  LatLng? driverCurrentPositionDuringTrip;
  String rideRequestStatus = '';
  bool requestPositionInfo = true;
  LatLng? passengerPickUpLatitudeAndLongitude;
  LatLng? passengerDropOffLatitudeAndLongitude;
  DirectionRouteDetails? directionRouteDetailsDuringTrip;
  String tripDuration = '';
  IconData? driverIcon = Icons.person;
  Color? driverIconColor = AppColors.indigo7;
  double tripPrice = 0;

  @override
  void initState() {
    super.initState();
    checkLocationPermissionStatus();
  }

  setNavigatorPop() {
    Navigator.pop(context);
  }

  navigateToLogInScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (c) => const LogInScreen()));
  }

  navigateToSplashScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (c) => const SplashScreen()));
  }

  checkLocationPermissionStatus() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.always || _locationPermission == LocationPermission.whileInUse) {
      setState(() {
        ifUserGrantedLocationPermission = true;
      });
    } else {
      setState(() {
        ifUserGrantedLocationPermission = false;
      });
    }
  }
  
  Future<String> getHumanReadableAddress() async {
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(passengerCurrentPosition!, context);
    return humanReadableAddress;
  }

  // Method that'll give the user's current position on the map:
  findPassengerPosition() async {
    geolocatorPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    passengerCurrentPosition = geolocatorPosition;
    latitudeAndLongitudePosition = LatLng(
        passengerCurrentPosition!.latitude,
        passengerCurrentPosition!.longitude
    );
    // Adjusting camera based on the user's current position:
    cameraPosition = CameraPosition(
        target: latitudeAndLongitudePosition!,
        zoom: 17
    );
    // Updating camera position:
    newGoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
    getHumanReadableAddress();
    // Updating passenger's info for navigation drawer:
    passengerName = passengerModelCurrentInfo!.name!;
    passengerEmail = passengerModelCurrentInfo!.email!;
    passengerPhone = passengerModelCurrentInfo!.phone!;
    initializeGeofireListener();
    AssistantMethods.readTripIdKeys(context);
  }

  Widget setShowRouteConfirmationOptions(bool showOptions, bool routeIsConfirmed) {
    if(showOptions && !routeIsConfirmed) {
      return Column(
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: 'confirm_route',
            backgroundColor: AppColors.success5,
            onPressed: () {
              setState(() {
                ifRouteIsConfirmed = true;
              });
            },
            child: const Icon(
              Icons.check,
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: AppSpaceValues.space1),

          FloatingActionButton(
            mini: true,
            heroTag: 'cancel_route',
            backgroundColor: AppColors.error,
            onPressed: () {
              setState(() {
                markersSet.removeWhere((marker) => marker.markerId.value == 'originMarkerId' || marker.markerId.value == 'destinationMarkerId');
                polylineSet.clear();
                showRouteConfirmationOptions = false;
                ifRouteIsConfirmed = false;
                dropOffLocationText = AppStrings.selectDestination;
              });
            },
            child: const Icon(
              Icons.close,
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: AppSpaceValues.space3),
        ],
      );
    } else {
      return const Column();
    }
  }

  saveRideRequestInfo() {
    rideRequestRef = FirebaseDatabase.instance.ref().child('rideRequests').push(); // Setting ride request info reference into the database.
    var originLocation = Provider.of<AppInfo>(context, listen: false).passengerPickUpLocation; // Getting the passenger's pick up location.
    var destinationLocation = Provider.of<AppInfo>(context, listen: false).passengerDropOffLocation; // Getting the passenger's drop off location.
    originLocationMap = {
      'latitude': originLocation!.locationLatitude.toString(),
      'longitude': originLocation.locationLongitude.toString(),
    }; // Setting an object to store the passenger's origin location info.
    destinationLocationMap = {
      'latitude': destinationLocation!.locationLatitude.toString(),
      'longitude': destinationLocation.locationLongitude.toString(),
    }; // Setting an object to store the passenger's destination location info.
    passengerInformationMap = {
      'origin': originLocationMap,
      'originAddress': originLocation.locationName,
      'destination': destinationLocationMap,
      'destinationAddress': destinationLocation.locationName,
      'originToDestinationDistance': directionRouteDetails!.distanceText,
      'originToDestinationDuration': directionRouteDetails!.durationText,
      'time': DateTime.now().toString(),
      'passengerId': passengerModelCurrentInfo!.id,
      'passengerName': passengerModelCurrentInfo!.name,
      'passengerPhone': passengerModelCurrentInfo!.phone,
      'driverId': 'waiting',
    }; // Setting an object to store ALL passenger's ride request info.

    rideRequestRef!.set(passengerInformationMap); // Finally, the 'passengerInformationMap' object will be sent into the database.

    streamSubscriptionRideRequestInfoDuringTrip = rideRequestRef!.onValue.listen((eventSnapshot) async {
      if(eventSnapshot.snapshot.value == null) {
        return;
      }
      if((eventSnapshot.snapshot.value as Map)['driverCarInfo'] != null) {
        setState(() {
          driverOnTripCarModel = (eventSnapshot.snapshot.value as Map)['driverCarInfo']['carModel'].toString();
          driverOnTripCarColor = (eventSnapshot.snapshot.value as Map)['driverCarInfo']['carColor'].toString();
          driverOnTripCarNumber = (eventSnapshot.snapshot.value as Map)['driverCarInfo']['carNumber'].toString();
          driverOnTripCarType = (eventSnapshot.snapshot.value as Map)['driverCarInfo']['carType'].toString();
        });
      }
      if((eventSnapshot.snapshot.value as Map)['driverName'] != null) {
        setState(() {
          driverOnTripName = (eventSnapshot.snapshot.value as Map)['driverName'].toString();
        });
      }
      if((eventSnapshot.snapshot.value as Map)['driverPhone'] != null) {
        setState(() {
          driverOnTripPhone = (eventSnapshot.snapshot.value as Map)['driverPhone'].toString();
        });
      }
      if((eventSnapshot.snapshot.value as Map)['status'] != null) {
        rideRequestStatus = (eventSnapshot.snapshot.value as Map)['status'].toString();
      }
      if((eventSnapshot.snapshot.value as Map)['driverLocation'] != null) {
        driverLatitudeDuringTrip = double.parse((eventSnapshot.snapshot.value as Map)['driverLocation']['latitude'].toString());
        driverLongitudeDuringTrip = double.parse((eventSnapshot.snapshot.value as Map)['driverLocation']['longitude'].toString());
        driverCurrentPositionDuringTrip = LatLng(driverLatitudeDuringTrip!, driverLongitudeDuringTrip!);

        switch(rideRequestStatus) {
          case 'accepted':
            updateDurationFromDriverToPickUpLocation(driverCurrentPositionDuringTrip);
            setState(() {
              driverIcon = Icons.person_pin_circle_outlined;
              driverIconColor = AppColors.indigo7;
            });
            break;
          case 'arrived':
            setState(() {
              driverIcon = Icons.person_pin_circle_outlined;
              driverIconColor = AppColors.success5;
              driverRideStatus = AppStrings.driverHasArrived;
              tripDuration = '0 mins';
            });
            break;
          case 'onTrip':
            updateDurationFromPickUpLocationToDestination(driverCurrentPositionDuringTrip);
            setState(() {
              driverRideStatus = AppStrings.driverInboundDestination;
              driverIcon = Icons.location_on;
              driverIconColor = AppColors.error;
            });
            break;
          case 'finished':
            if((eventSnapshot.snapshot.value as Map)['tripPrice'] != null) {
              tripPrice = double.parse((eventSnapshot.snapshot.value as Map)['tripPrice'].toString());

              var response = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => FareAmountCollectionDialog(
                  tripPrice: tripPrice,
                ),
              );

              if(response == 'tripPayed') {
                Navigator.push(context, MaterialPageRoute(builder: (c) => RateDriverScreen()));
                rideRequestRef!.onDisconnect();
                streamSubscriptionRideRequestInfoDuringTrip!.cancel();
              }
            }
        }
      }
    });

    nearbyAvailableDriversList = AssistantGeofire.nearbyAvailableDriversList; // Getting nearby available drivers list.
    searchNearestAvailableDrivers();
  }

  searchNearestAvailableDrivers() async {
    // If there's no drivers available for the passenger...
    if(nearbyAvailableDriversList.isEmpty) {
      rideRequestRef!.remove();
      Fluttertoast.showToast(msg: AppStrings.noAvailableDriversNearby);
      return;
    }
    // But if there's near drivers available, we'll get their info with this method:
    await getNearestAvailableDriversInfo(nearbyAvailableDriversList);
    var response = await Navigator.push(context, MaterialPageRoute(builder: (c) => SelectNearestAvailableDriversScreen(rideRequestRef: rideRequestRef)));
    if(response == AppStrings.chosenDriver) {
      FirebaseDatabase.instance.ref().child('drivers').child(selectedDriverId!).once().then((snap) {
        if(snap.snapshot.value != null) {
          // Push notification to the selected driver:
          pushNotificationToSelectedDriver(selectedDriverId!);
          // Display an UI for waiting the driver's response:
          showWaitingResponseFromDriverUI();
          // Waiting response from driver by using a listener for event snapshot...
          FirebaseDatabase.instance.ref().child('drivers').child(selectedDriverId!).child('newRideStatus').onValue.listen((eventSnapshot) {
            // 1. If driver CANCELS ride request:
            if(eventSnapshot.snapshot.value == 'available') {
              Fluttertoast.showToast(msg: AppStrings.driverRefusedRideRequest);
            }
            // 2. If driver ACCEPTS ride request:
            if(eventSnapshot.snapshot.value == 'accepted' || eventSnapshot.snapshot.value == 'busy') {
              showTripUI();
            }
          });
        } else {
          Fluttertoast.showToast(msg: AppStrings.driverDoesNotExistError);
        }
      });
    }
  }

  // This method will send the ride request notification to the driver:
  pushNotificationToSelectedDriver(String selectedDriverId) {
    // Assigning 'rideRequestId' to 'newRideStatus' in the driver's parent node for that selected driver:
    FirebaseDatabase.instance.ref().child('drivers').child(selectedDriverId).child('newRideStatus').set(rideRequestRef!.key);
    FirebaseDatabase.instance.ref().child('drivers').child(selectedDriverId).child('token').once().then((snap) {
      if(snap.snapshot.value != null) {
        selectedDriverRegistrationToken = snap.snapshot.value.toString();
        AssistantMethods.sendNotificationToDriver(context, selectedDriverRegistrationToken!, rideRequestRef!.key.toString());
        Fluttertoast.showToast(msg: AppStrings.notificationSentToDriver);
      } else {
        Fluttertoast.showToast(msg: AppStrings.driverAuthTokenError);
        return;
      }
    });
  }

  // This method will provide us with each available nearby driver's ID and geographic coordinates:
  getNearestAvailableDriversInfo(List nearestAvailableDriversList) async {
    driversRef = FirebaseDatabase.instance.ref().child('drivers');

    for(int i = 0; i < nearestAvailableDriversList.length; i++) {
      await driversRef?.child(nearestAvailableDriversList[i].driverId.toString()).once().then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        driversList.add(driverKeyInfo);
      });
    }
    print(driversList);
  }

  showWaitingResponseFromDriverUI() {
    setState(() {
      rideRequestStatus = 'waiting';
      waitingDriverResponseContainerHeight = 260;
      mapControlsContainerHeight = 300;
      tripPanelContainerHeight = 0;
      requestRideContainerHeight = 0;
    });
  }

  showTripUI() {
    setState(() {
      tripPanelContainerHeight = 340;
      mapControlsContainerHeight = 380;
      waitingDriverResponseContainerHeight = 0;
      requestRideContainerHeight = 0;
    });
  }

  /// Gives the duration time of the trip in realtime. It gives the driver-to-passenger estimated duration
  /// (when driver is going to pick up the passenger):
  updateDurationFromDriverToPickUpLocation(driverCurrentPositionDuringTrip) async {
    if(requestPositionInfo) {
      requestPositionInfo = false;
      passengerPickUpLatitudeAndLongitude = LatLng(passengerCurrentPosition!.latitude, passengerCurrentPosition!.longitude);
      directionRouteDetailsDuringTrip = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionDuringTrip,
        passengerPickUpLatitudeAndLongitude!,
      );

      if(directionRouteDetailsDuringTrip == null) {
        return;
      }

      setState(() {
        tripDuration = directionRouteDetailsDuringTrip!.durationText.toString();
      });
      requestPositionInfo = true;
    }
  }

  /// Gives the duration time of the trip in realtime. It gives the origin-to-destination estimated duration
  /// (when driver is going from the pick up location to the drop off location):
  updateDurationFromPickUpLocationToDestination(driverCurrentPositionDuringTrip) async {
    if(requestPositionInfo) {
      requestPositionInfo = false;
      // TODO: I'm reusing this variable from another method. Remove if it breaks something.
      destinationPosition = Provider.of<AppInfo>(context, listen: false).passengerDropOffLocation;
      passengerDropOffLatitudeAndLongitude = LatLng(destinationPosition!.locationLatitude!, destinationPosition!.locationLongitude!);
      directionRouteDetailsDuringTrip = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionDuringTrip,
        passengerDropOffLatitudeAndLongitude!,
      );

      if(directionRouteDetailsDuringTrip == null) {
        return;
      }

      setState(() {
        tripDuration = directionRouteDetailsDuringTrip!.durationText.toString();
      });
      requestPositionInfo = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    createNearbyAvailableDriverMarker();

    return Scaffold(
      key: scaffoldKey,
      drawer: CustomNavigationDrawer(
        name: passengerName,
        email: passengerEmail,
        phone: passengerPhone,
      ),
      body: Stack(
        children: [

/********************************************** UI FOR THE MAP **********************************************/

          Padding(
            padding: EdgeInsets.only(bottom: requestRideContainerHeight),
            child: GoogleMap(
              initialCameraPosition: _dummyLocation,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              rotateGesturesEnabled: false,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: polylineSet,
              markers: markersSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                setGoogleMapThemeToBlack(newGoogleMapController!);
                findPassengerPosition();
              },
            ),
          ),

          // Left-screen controls:
          Positioned(
            left: AppSpaceValues.space2,
            bottom: mapControlsContainerHeight,
            child: Column(
              children: [
                // Zoom-in button:
                FloatingActionButton(
                  mini: true,
                  heroTag: 'zoom_in',
                  backgroundColor: AppColors.indigo7,
                  onPressed: () {
                    newGoogleMapController?.animateCamera(CameraUpdate.zoomIn());
                  },
                  child: const Icon(
                    Icons.add,
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: AppSpaceValues.space1),

                // Zoom-out button:
                FloatingActionButton(
                  mini: true,
                  heroTag: 'zoom_out',
                  backgroundColor: AppColors.indigo7,
                  onPressed: () {
                    newGoogleMapController?.animateCamera(CameraUpdate.zoomOut());
                  },
                  child: const Icon(
                    Icons.remove,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          // Right-screen controls:
          Positioned(
            right: AppSpaceValues.space2,
            bottom: mapControlsContainerHeight,
            child: Column(
              children: [
                // Confirm/Discard route buttons:
                setShowRouteConfirmationOptions(showRouteConfirmationOptions, ifRouteIsConfirmed),

                // My location button:
                FloatingActionButton(
                  mini: true,
                  heroTag: 'my_location',
                  backgroundColor: AppColors.indigo7,
                  onPressed: () {
                    findPassengerPosition();
                    newGoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          // Custom hamburger button for opening navigation drawer:
          CustomHamburgerButton(
            topPosition: AppSpaceValues.space5,
            backgroundColor: AppColors.indigo7,
            iconColor: AppColors.white,
            rightPosition: AppSpaceValues.space3,
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            icon: Icons.menu,
          ),

/********************************************** UI FOR SEARCHING LOCATION **********************************************/

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: requestRideContainerHeight,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpaceValues.space3,
                    vertical: AppSpaceValues.space3,
                  ),
                  child: Column(
                    children: [

                      // "From X location..."
                      Row(
                        children: [
                          const Icon(
                            Icons.person_pin_circle_outlined,
                            size: AppSpaceValues.space4,
                            color: AppColors.indigo7,
                          ),

                          const SizedBox(width: AppSpaceValues.space2),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '${AppStrings.yourLocation}:',
                                style: TextStyle(
                                  color: AppColors.gray9,
                                  fontSize: AppFontSizes.ml,
                                  fontWeight: AppFontWeights.light,
                                ),
                              ),
                              SizedBox(
                                width: requestRideContainerHeight,
                                child: Text(
                                  // Handling the pick up location name:
                                  (Provider.of<AppInfo>(context).passengerPickUpLocation != null)
                                  ? pickUpLocationText = Provider.of<AppInfo>(context).passengerPickUpLocation!.locationName!
                                  : pickUpLocationText = AppStrings.currentLocation,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: AppColors.gray9,
                                    fontSize: AppFontSizes.sm,
                                    fontWeight: AppFontWeights.regular,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpaceValues.space2),
                      const Divider(height: 1, thickness: 1, color: AppColors.gray5,),
                      const SizedBox(height: AppSpaceValues.space2),

                      // "... To Y destination."
                      GestureDetector(
                        onTap: () async {
                          responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c) => SearchPlacesScreen()));
                          if(responseFromSearchScreen == AppStrings.destinationSelected) {
                            await drawPolylineFromOriginToDestination();
                            setState(() {
                              showRouteConfirmationOptions = true;
                              ifRouteIsConfirmed = false;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit_location_outlined,
                              size: AppSpaceValues.space4,
                              color: AppColors.indigo7,
                            ),
                        
                            const SizedBox(width: AppSpaceValues.space2),
                        
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  AppStrings.whereIsTheUserDestination,
                                  style: TextStyle(
                                    color: AppColors.gray9,
                                    fontSize: AppFontSizes.ml,
                                    fontWeight: AppFontWeights.light,
                                  ),
                                ),
                                SizedBox(
                                  width: requestRideContainerHeight,
                                  child: Text(
                                    // Handling the drop off location name:
                                    (Provider.of<AppInfo>(context).passengerDropOffLocation != null && showRouteConfirmationOptions)
                                    ? dropOffLocationText = Provider.of<AppInfo>(context).passengerDropOffLocation!.locationName!
                                    : dropOffLocationText = AppStrings.selectDestination,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: AppColors.gray9,
                                      fontSize: AppFontSizes.sm,
                                      fontWeight: AppFontWeights.regular,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpaceValues.space2),
                      const Divider(height: 1, thickness: 1, color: AppColors.gray5),
                      const SizedBox(height: AppSpaceValues.space4),

                      CustomButton(
                        text: AppStrings.confirmRide,
                        btnContentSize: AppFontSizes.m,
                        textColor: AppColors.white,
                        icon: Icons.check,
                        onPressed: () {
                          if (Provider.of<AppInfo>(context, listen: false).passengerDropOffLocation != null && ifRouteIsConfirmed) {
                            saveRideRequestInfo();
                          } else if(showRouteConfirmationOptions && !ifRouteIsConfirmed) {
                            Fluttertoast.showToast(msg: AppStrings.userNeedToConfirmSelectedDestination);
                          } else {
                            Fluttertoast.showToast(msg: AppStrings.userNeedToSelectDestination);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

/******************************************** UI FOR WAITING DRIVER RESPONSE *******************************************/

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: waitingDriverResponseContainerHeight,
              decoration: const BoxDecoration(
                color: AppColors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpaceValues.space3),
                child: Column(
                  children: [
                    const Text(
                      AppStrings.loading3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSizes.xl,
                        fontWeight: AppFontWeights.bold,
                        color: AppColors.indigo7,
                      ),
                    ),

                    const SizedBox(height: AppSpaceValues.space3),

                    const Text(
                      AppStrings.waitingDriverResponse,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSizes.l,
                        fontWeight: AppFontWeights.regular,
                        color: AppColors.gray9,
                        height: AppLineHeights.ml
                      ),
                    ),

                    const SizedBox(height: AppSpaceValues.space5),

                    CustomButton(
                      text: AppStrings.cancelRequest,
                      btnContentSize: AppFontSizes.m,
                      textColor: AppColors.white,
                      backgroundColor: AppColors.error,
                      icon: Icons.close,
                      onPressed: () {
                        rideRequestRef!.remove();
                        setState(() {
                          requestRideContainerHeight = 260;
                          waitingDriverResponseContainerHeight = 0;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

/*************************************************** UI DURING TRIP ****************************************************/
  
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: tripPanelContainerHeight,
              decoration: const BoxDecoration(
                color: AppColors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpaceValues.space3,
                  vertical: AppSpaceValues.space3,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          driverIcon,
                          size: AppSpaceValues.space7,
                          color: driverIconColor,
                        ),

                        const SizedBox(width: AppSpaceValues.space2),

                        SizedBox(
                          width: 270,
                          child: Text(
                            driverRideStatus,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              color: AppColors.gray9,
                              fontSize: AppFontSizes.l,
                              fontWeight: AppFontWeights.light,
                              height: AppLineHeights.ml,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpaceValues.space2),
                    const Divider(height: 1, thickness: 1, color: AppColors.gray5),
                    const SizedBox(height: AppSpaceValues.space3),

                    Row(
                      children: [
                        const Icon(
                          Icons.directions_car,
                          size: AppSpaceValues.space4,
                          color: AppColors.gray9,
                        ),

                        const SizedBox(width: AppSpaceValues.space3),

                        SizedBox(
                          width: 290,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driverOnTripCarModel,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.gray9,
                                  fontSize: AppFontSizes.ml,
                                  fontWeight: AppFontWeights.regular,
                                ),
                              ),
                              Text(
                                'Placa $driverOnTripCarNumber, $driverOnTripCarColor',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.gray9,
                                  fontSize: AppFontSizes.ml,
                                  fontWeight: AppFontWeights.regular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpaceValues.space2),

                    Row(
                      children: [
                        const Icon(
                          Icons.timelapse,
                          size: AppSpaceValues.space4,
                          color: AppColors.gray9,
                        ),

                        const SizedBox(width: AppSpaceValues.space3),

                        Text(
                          tripDuration,
                          style: const TextStyle(
                            color: AppColors.gray9,
                            fontSize: AppFontSizes.ml,
                            fontWeight: AppFontWeights.regular,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpaceValues.space2),

                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: AppSpaceValues.space4,
                          color: AppColors.gray9,
                        ),

                        const SizedBox(width: AppSpaceValues.space3),

                        Text(
                          driverOnTripName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.gray9,
                            fontSize: AppFontSizes.ml,
                            fontWeight: AppFontWeights.regular,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpaceValues.space3),

                    Center(
                      child: CustomButton(
                        text: AppStrings.messageDriver,
                        btnContentSize: AppFontSizes.m,
                        icon: Icons.phone_android,
                        onPressed: () {

                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (!ifUserGrantedLocationPermission) ...[
            const LocationPermissionWarning(),
          ],
        ],
      ),
    );
  }

  // Method responsible for tracing the polyline-based route when the passenger selects his destination.
  Future<void> drawPolylineFromOriginToDestination() async {
    // Couldn't initialize some of the variables outside this method.
    originPosition = Provider.of<AppInfo>(context, listen: false).passengerPickUpLocation;
    destinationPosition = Provider.of<AppInfo>(context, listen: false).passengerDropOffLocation;

    originLatitudeAndLongitude = LatLng(originPosition!.locationLatitude!, originPosition!.locationLongitude!);
    destinationLatitudeAndLongitude = LatLng(destinationPosition!.locationLatitude!, destinationPosition!.locationLongitude!);

    showDialog(context: context, builder: (BuildContext context) => ProgressDialog(message: AppStrings.loading3));
    directionRouteDetails = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatitudeAndLongitude!, destinationLatitudeAndLongitude!);
    setState(() {
      tripDirectionRouteDetails = directionRouteDetails;
    });
    setNavigatorPop();

    PolylinePoints polylinePoints = PolylinePoints();
    // The below 'List' only accepts 'LatLang' values!
    List<PointLatLng> decodedPolylinePointsList = polylinePoints.decodePolyline(directionRouteDetails!.ePoints!);
    polylineCoordinatesList.clear(); // Clearing previous polyline.

    if(decodedPolylinePointsList.isNotEmpty) {
      for (var pointLatLng in decodedPolylinePointsList) {
        polylineCoordinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId('polylineId'),
        color: AppColors.indigo5,
        jointType: JointType.round,
        points: polylineCoordinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    // Conditions to better calibrate the camera so the user, when selecting his destination, can easily see the route in its entirety.
    if(originLatitudeAndLongitude!.latitude > destinationLatitudeAndLongitude!.latitude
    && originLatitudeAndLongitude!.longitude > destinationLatitudeAndLongitude!.longitude) {
      latLngBounds = LatLngBounds(
        southwest: destinationLatitudeAndLongitude!,
        northeast: originLatitudeAndLongitude!
      );
    } else if(originLatitudeAndLongitude!.longitude > destinationLatitudeAndLongitude!.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(originLatitudeAndLongitude!.latitude, destinationLatitudeAndLongitude!.longitude),
        northeast: LatLng(destinationLatitudeAndLongitude!.latitude, originLatitudeAndLongitude!.longitude),
      );
    } else if(originLatitudeAndLongitude!.latitude > destinationLatitudeAndLongitude!.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(destinationLatitudeAndLongitude!.latitude, originLatitudeAndLongitude!.longitude),
        northeast: LatLng(originLatitudeAndLongitude!.latitude, destinationLatitudeAndLongitude!.longitude),
      );
    } else {
      latLngBounds = LatLngBounds(
          southwest: originLatitudeAndLongitude!,
          northeast: destinationLatitudeAndLongitude!
      );
    }
    // Adjusting camera for better displaying the polyline-based route:
    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds!, AppSpaceValues.space11));

    originMarker = Marker(
      markerId: const MarkerId('originMarkerId'),
      infoWindow: InfoWindow(title: originPosition!.locationName, snippet: AppStrings.yourLocation),
      position: originLatitudeAndLongitude!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    destinationMarker = Marker(
      markerId: const MarkerId('destinationMarkerId'),
      infoWindow: InfoWindow(title: destinationPosition!.locationName, snippet: AppStrings.destination),
      position: destinationLatitudeAndLongitude!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markersSet.add(originMarker!);
      markersSet.add(destinationMarker!);
    });
  }

  initializeGeofireListener() {
    Geofire.initialize('activeDrivers');
    // The third parameter present in the 'queryAtLocation()' method represents the number of kilometers Geofire must act upon.
    // For instance, if we put the value "5" on this parameter, it will detect drivers on a 5 kilometer radius from the passenger's location.
    Geofire.queryAtLocation(passengerCurrentPosition!.latitude, passengerCurrentPosition!.longitude, locateNearDriversRadius)!.listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        // Latitude will be retrieved from map['latitude'].
        // Longitude will be retrieved from map['longitude'].
        // See more info in the geofire's documentation: https://pub.dev/packages/flutter_geofire
        switch (callBack) {
          // This case will pick every single available nearby driver from the database into an object,
          // using 'NearbyAvailableDrivers' model class.
          //
          // The reason why this logic is inside this case is because the 'onKeyEntered' method picks the ID for the active drivers.
          // So, 'onKeyEntered' can be translated to "whenever any driver becomes available/online".
          case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDriver = NearbyAvailableDrivers(); // Instantiating nearby available drivers as an object.
            nearbyAvailableDriver.driverLocationLatitude = map['latitude']; // Picking up the nearby available driver's latitude.
            nearbyAvailableDriver.driverLocationLongitude = map['longitude']; // Picking up the nearby available driver's longitude.
            nearbyAvailableDriver.driverId = map['key']; // Picking up the nearby available driver's ID.
            AssistantGeofire.nearbyAvailableDriversList.add(nearbyAvailableDriver); // Adding the nearby available drivers one by one to the list.
            if(nearbyAvailableDriverKeysLoaded) {
              displayNearbyAvailableDriversOnTheMap();
              setState(() {
                markersSet.add(originMarker!);
                markersSet.add(destinationMarker!);
              });
            }
            break;

          // 'onKeyExited' can be translated to "whenever any driver becomes unavailable/enters offline mode".
          case Geofire.onKeyExited:
            AssistantGeofire.deleteOfflineDriverFromNearbyAvailableDriversList(map['key']);
            displayNearbyAvailableDriversOnTheMap();
            setState(() {
              markersSet.add(originMarker!);
              markersSet.add(destinationMarker!);
            });
            break;

          // 'onKeyMoved' will be called whenever the driver's location moves.
          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDriver = NearbyAvailableDrivers(); // Instantiating nearby available drivers as an object.
            nearbyAvailableDriver.driverLocationLatitude = map['latitude']; // Picking up the nearby available driver's latitude.
            nearbyAvailableDriver.driverLocationLongitude = map['longitude']; // Picking up the nearby available driver's longitude.
            nearbyAvailableDriver.driverId = map['key']; // Picking up the nearby available driver's ID.
            AssistantGeofire.updateNearbyAvailableDriverLocation(nearbyAvailableDriver);
            displayNearbyAvailableDriversOnTheMap();
            setState(() {
              markersSet.add(originMarker!);
              markersSet.add(destinationMarker!);
            });
            break;

          // 'onGeoQueryReady' will display all of those nearby available drivers.
          case Geofire.onGeoQueryReady:
            nearbyAvailableDriverKeysLoaded = true;
            displayNearbyAvailableDriversOnTheMap();
            setState(() {
              markersSet.add(originMarker!);
              markersSet.add(destinationMarker!);
            });
            break;
        }
      }
    });
  }

  displayNearbyAvailableDriversOnTheMap() {
    setState(() {
      markersSet.removeWhere((marker) => marker.markerId.value != 'originMarkerId' || marker.markerId.value != 'destinationMarkerId');
      Set<Marker> driversMarkerSet = Set<Marker>(); // NB: Ignore Flutter's suggestion.

      for(NearbyAvailableDrivers eachDriver in AssistantGeofire.nearbyAvailableDriversList) {
        LatLng eachNearbyAvailableDriverPosition = LatLng(eachDriver.driverLocationLatitude!, eachDriver.driverLocationLongitude!);

        eachNearbyAvailableDriverMarker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachNearbyAvailableDriverPosition,
          icon: nearbyAvailableDriverIcon!,
          rotation: 360,
        );
        driversMarkerSet.add(eachNearbyAvailableDriverMarker!);
      }

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  createNearbyAvailableDriverMarker() {
    if(nearbyAvailableDriverIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2)); // Size for the available driver icon.
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'images/car.png').then((value) {
        nearbyAvailableDriverIcon = value;
      });
    }
  }
}