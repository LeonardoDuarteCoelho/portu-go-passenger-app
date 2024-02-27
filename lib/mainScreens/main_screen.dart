import 'dart:async';

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
import 'package:app_settings/app_settings.dart';
import 'package:portu_go_passenger/infoHandler/app_info.dart';
import 'package:portu_go_passenger/main.dart';
import 'package:portu_go_passenger/mainScreens/search_places_screen.dart';
import 'package:portu_go_passenger/models/direction_route_details.dart';
import 'package:portu_go_passenger/models/nearby_available_drivers.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import '../splashScreen/splash_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

/// ABOUT THE 'const' PREFIX WARNINGS FROM FLUTTER: We need the Text
/// widgets to not be constant since user destinations may change and,
/// consequently, the strings displayed by the Text widgets will have
/// to change.
///
/// Ignore the warnings from Flutter and DO NOT set the Text widgets as
/// constant!
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
  LocationPermission? _locationPermission;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<NearbyAvailableDrivers> nearbyAvailableDriversList = [];

  // Geolocator variables:
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

  // Map route variables:
  dynamic responseFromSearchScreen;
  DirectionRouteDetails? directionRouteDetails;
  List<LatLng> polylineCoordinatesList = [];
  Set<Polyline> polylineSet = {};
  LatLngBounds? latLngBounds;
  Set<Marker> markersSet = {};

  // Geofire variables:
  bool nearbyAvailableDriverKeysLoaded = false;
  double locateNearDriversRadius = 10;
  BitmapDescriptor? nearbyAvailableDriverIcon;

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

  setGoogleMapThemeToBlack (bool changeToBlackTheme) {
    if(changeToBlackTheme) {
      newGoogleMapController?.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
    }
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
  findPassengerPosition () async {
    geolocatorPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    passengerCurrentPosition = geolocatorPosition;
    latitudeAndLongitudePosition = LatLng(
        passengerCurrentPosition!.latitude,
        passengerCurrentPosition!.longitude
    );
    // Adjusting camera based on the user's current position:
    cameraPosition = CameraPosition(
        target: latitudeAndLongitudePosition!,
        bearing: passengerCurrentPosition!.heading,
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
  }

  Widget setShowRouteConfirmationOptions(bool showOptions, bool routeIsConfirmed) {
    if(showOptions && !routeIsConfirmed) {
      return Column(
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: 'confirm_route',
            backgroundColor: AppColors.success,
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
                markersSet.clear();
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
    nearbyAvailableDriversList = AssistantGeofire.nearbyAvailableDriversList;
    searchNearestAvailableDrivers();
  }

  searchNearestAvailableDrivers() async {
    // If there's no drivers available for the passenger...
    if(nearbyAvailableDriversList.isEmpty) {
      Fluttertoast.showToast(msg: AppStrings.noAvailableDriversNearby);
      Fluttertoast.showToast(msg: AppStrings.waitToRequestRideAgain);
      return;
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
                setGoogleMapThemeToBlack(false);
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
                                AppStrings.yourLocation,
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
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.gray5,
                      ),
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
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.gray5,
                      ),
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
    var originPosition = Provider.of<AppInfo>(context, listen: false).passengerPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).passengerDropOffLocation;
    LatLng originLatitudeAndLongitude;
    LatLng destinationLatitudeAndLongitude;

    originLatitudeAndLongitude = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    destinationLatitudeAndLongitude = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(context: context, builder: (BuildContext context) => ProgressDialog(message: AppStrings.loading3));
    directionRouteDetails = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatitudeAndLongitude, destinationLatitudeAndLongitude);
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
    if(originLatitudeAndLongitude.latitude > destinationLatitudeAndLongitude.latitude
    && originLatitudeAndLongitude.longitude > destinationLatitudeAndLongitude.longitude) {
      latLngBounds = LatLngBounds(
        southwest: destinationLatitudeAndLongitude,
        northeast: originLatitudeAndLongitude
      );
    } else if(originLatitudeAndLongitude.longitude > destinationLatitudeAndLongitude.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(originLatitudeAndLongitude.latitude, destinationLatitudeAndLongitude.longitude),
        northeast: LatLng(destinationLatitudeAndLongitude.latitude, originLatitudeAndLongitude.longitude),
      );
    } else if(originLatitudeAndLongitude.latitude > destinationLatitudeAndLongitude.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(destinationLatitudeAndLongitude.latitude, originLatitudeAndLongitude.longitude),
        northeast: LatLng(originLatitudeAndLongitude.latitude, destinationLatitudeAndLongitude.longitude),
      );
    } else {
      latLngBounds = LatLngBounds(
          southwest: originLatitudeAndLongitude,
          northeast: destinationLatitudeAndLongitude
      );
    }
    // Adjusting camera for better displaying the polyline-based route:
    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds!, AppSpaceValues.space11));

    Marker originMarker = Marker(
      markerId: const MarkerId('originMarkerId'),
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: AppStrings.yourLocation),
      position: originLatitudeAndLongitude,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationMarkerId'),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: AppStrings.destination),
      position: destinationLatitudeAndLongitude,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });
  }

  initializeGeofireListener() {
    Geofire.initialize('activeDrivers');
    // The third parameter present in the 'queryAtLocation()' method represents the number of kilometers Geofire must act upon.
    // For instance, if we put the value "5" on this parameter, it will detect drivers on a 5 kilometer radius from the passenger's location.
    Geofire.queryAtLocation(passengerCurrentPosition!.latitude, passengerCurrentPosition!.longitude, locateNearDriversRadius)!.listen((map) {
      print(map);
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
            if(nearbyAvailableDriverKeysLoaded) displayNearbyAvailableDriversOnTheMap();
            break;

          // 'onKeyExited' can be translated to "whenever any driver becomes unavailable/enters offline mode".
          case Geofire.onKeyExited:
            AssistantGeofire.deleteOfflineDriverFromNearbyAvailableDriversList(map['key']);
            displayNearbyAvailableDriversOnTheMap();
            break;

          // 'onKeyMoved' will be called whenever the driver's location moves.
          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDriver = NearbyAvailableDrivers(); // Instantiating nearby available drivers as an object.
            nearbyAvailableDriver.driverLocationLatitude = map['latitude']; // Picking up the nearby available driver's latitude.
            nearbyAvailableDriver.driverLocationLongitude = map['longitude']; // Picking up the nearby available driver's longitude.
            nearbyAvailableDriver.driverId = map['key']; // Picking up the nearby available driver's ID.
            AssistantGeofire.updateNearbyAvailableDriverLocation(nearbyAvailableDriver);
            displayNearbyAvailableDriversOnTheMap();
            break;

          // 'onGeoQueryReady' will display all of those nearby available drivers.
          case Geofire.onGeoQueryReady:
            nearbyAvailableDriverKeysLoaded = true;
            displayNearbyAvailableDriversOnTheMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayNearbyAvailableDriversOnTheMap() {
    setState(() {
      markersSet.clear();
      Set<Marker> driversMarkerSet = Set<Marker>(); // NB: Ignore Flutter's suggestion.

      for(NearbyAvailableDrivers eachDriver in AssistantGeofire.nearbyAvailableDriversList) {
        LatLng eachNearbyAvailableDriverPosition = LatLng(eachDriver.driverLocationLatitude!, eachDriver.driverLocationLongitude!);
        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachNearbyAvailableDriverPosition,
          icon: nearbyAvailableDriverIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
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