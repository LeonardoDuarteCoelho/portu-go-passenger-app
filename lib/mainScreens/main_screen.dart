import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import 'package:portu_go_passenger/mainScreens/search_places_screen.dart';
import 'package:portu_go_passenger/models/direction_route_details.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import '../splashScreen/splash_screen.dart';

class MainScreen extends StatefulWidget {

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
  LatLng? originLatitudeAndLongitude;
  LatLng? destinationLatitudeAndLongitude;
  DirectionRouteDetails? directionRouteDetails;
  List<LatLng> polylineCoordinatesList = [];
  Set<Polyline> polylineSet = {};

  bool ifUserGrantedLocationPermission = true; // Whether the app shows a warning telling the user to enable access to location or not.
  LocationPermission? _locationPermission;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double requestRideContainerHeight = 300; // Request ride container's height.
  double mapControlsContainerHeight = 310; // Map controls' height.

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
      // Show warning panel here. Since setState is called, build method will be called and can take care of showing the panel.
    }
  }
  
  Future<String> getHumanReadableAddress() async {
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(passengerCurrentPosition!, context);
    return humanReadableAddress;
  }

  // Handling the pick up location name so it may appear in the Text widget:
  handlePickUpLocationText() {
    String currentLocationText;
    if (Provider.of<AppInfo>(context).passengerPickUpLocation != null) {
      currentLocationText = Provider.of<AppInfo>(context).passengerPickUpLocation!.locationName!;
    } else {
      currentLocationText = AppStrings.selectedDestination;
    }
    return currentLocationText;
  }

  // Handling the drop off location name so it may appear in the Text widget:
  handleDropOffLocationText() {
    String currentLocationText;
    if (Provider.of<AppInfo>(context).passengerDropOffLocation != null) {
      currentLocationText = Provider.of<AppInfo>(context).passengerDropOffLocation!.locationName!;
    } else {
      currentLocationText = AppStrings.selectedDestination;
    }
    return currentLocationText;
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
        zoom: 17
    );
    // Updating camera position:
    newGoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
    getHumanReadableAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomNavigationDrawer(
        name:  passengerModelCurrentInfo!.name,
        email: passengerModelCurrentInfo!.email,
        phone: passengerModelCurrentInfo!.phone,
      ),
      body: Stack(
        children: [

          // UI FOR THE MAP:
          GoogleMap(
            initialCameraPosition: _dummyLocation,
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            polylines: polylineSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setGoogleMapThemeToBlack(false);
              findPassengerPosition();
            },
          ),

          // Zoom controls:
          Positioned(
            left: AppSpaceValues.space3,
            bottom: mapControlsContainerHeight,
            child: Column(
              children: [
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

          // My location button:
          Positioned(
            right: AppSpaceValues.space3,
            bottom: mapControlsContainerHeight,
            child: FloatingActionButton(
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

/*****************************************************************************************************/

          // UI FOR SEARCHING LOCATION:
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
                  color: AppColors.whiteTransparent90,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSpaceValues.space4),
                    topRight: Radius.circular(AppSpaceValues.space4),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpaceValues.space3,
                    vertical: AppSpaceValues.space3,
                  ),
                  child: Column(
                    children: [

                      // "From X location..."
                      GestureDetector(
                        onTap: () {
                          ifUserSearchesPickUpLocation = true;
                          ifUserSearchesDropOffLocation = false;
                          responseFromSearchScreen = Navigator.push(context, MaterialPageRoute(builder: (c) => SearchPlacesScreen()));
                        },
                        child: Row(
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
                                  AppStrings.whereToPickUpPassenger,
                                  style: TextStyle(
                                    color: AppColors.gray9,
                                    fontSize: AppFontSizes.ml,
                                    fontWeight: AppFontWeights.light,
                                  ),
                                ),
                                SizedBox(
                                  width: 280,
                                  child: Text(
                                    handlePickUpLocationText(), // Returning a string.
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
                      const SizedBox(height: AppSpaceValues.space2),

                      // "... To Y destination."
                      GestureDetector(
                        onTap: () async {
                          ifUserSearchesPickUpLocation = false;
                          ifUserSearchesDropOffLocation = true;
                          responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c) => SearchPlacesScreen()));
                          if(responseFromSearchScreen == AppStrings.destinationSelected) {
                            await drawPolylineFromOriginToDestination();
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.not_listed_location_outlined,
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
                                Text(
                                  handleDropOffLocationText(), // Returning a string.
                                  style: const TextStyle(
                                    color: AppColors.gray9,
                                    fontSize: AppFontSizes.sm,
                                    fontWeight: AppFontWeights.regular,
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

  Future<void> drawPolylineFromOriginToDestination() async {
    // Couldn't initialize some of the variables outside this method.
    var originPosition = Provider.of<AppInfo>(context, listen: false).passengerPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).passengerDropOffLocation;

    originLatitudeAndLongitude = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    destinationLatitudeAndLongitude = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(context: context, builder: (BuildContext context) => ProgressDialog(message: AppStrings.loading3));
    directionRouteDetails = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatitudeAndLongitude!, destinationLatitudeAndLongitude!);
    setNavigatorPop();

    PolylinePoints polylinePoints = PolylinePoints();
    // The below 'List' only accepts 'LatLang' values!
    List<PointLatLng> decodedPolylinePointsList = polylinePoints.decodePolyline(directionRouteDetails!.ePoints!);
    polylineCoordinatesList.clear(); // Clearing previous polyline.

    if(decodedPolylinePointsList.isNotEmpty) {
      decodedPolylinePointsList.forEach((PointLatLng pointLatLng) {
        polylineCoordinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId('PolylineID'),
        color: AppColors.indigo7,
        jointType: JointType.round,
        points: polylineCoordinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });}
}