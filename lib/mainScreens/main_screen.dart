import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portu_go_passenger/assistants/assistant_methods.dart';
import 'package:portu_go_passenger/authenticationScreens/login_screen.dart';
import 'package:portu_go_passenger/components/button.dart';
import 'package:portu_go_passenger/components/hamburger_button.dart';
import 'package:portu_go_passenger/components/navigation_drawer.dart';
import 'package:portu_go_passenger/components/zoom_controls.dart';
import 'package:portu_go_passenger/constants.dart';
import 'package:portu_go_passenger/global/global.dart';

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
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Position? geolocatorPosition;
  LatLng? latitudeAndLongitudePosition;
  Position? passengerCurrentPosition;
  CameraPosition? cameraPosition;
  var geolocator = Geolocator();
  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // Height of the "request ride" container:
  double requestRideContainerHeight = 300;

  @override
  void initState() {
    super.initState();
  }

  navigateToLogInScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (c) => const LogInScreen()));
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

  // Function that'll give the user's current position on the map:
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
        zoom: 14
    );
    // Updating camera position:
    newGoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
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
          // UI for the map:
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setGoogleMapThemeToBlack(false);
              findPassengerPosition();
            },
          ),

          CustomZoomControls(
            mapController: newGoogleMapController!,
            positionBottom: 320,
            positionLeft: AppSpaceValues.space3,
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

/***************************************************************************************************/

          // UI for searching location:
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
                      Row(
                        children: [
                          const Icon(
                            Icons.person_pin_circle_outlined,
                            size: AppSpaceValues.space4,
                            color: AppColors.indigo7,
                          ),

                          const SizedBox(width: AppSpaceValues.space3),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.whereToPickUpPassenger,
                                style: const TextStyle(
                                  color: AppColors.gray9,
                                  fontSize: AppFontSizes.ml,
                                  fontWeight: AppFontWeights.light,
                                ),
                              ),
                              Text(
                                AppStrings.currentLocation,
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

                      const SizedBox(height: AppSpaceValues.space2),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.gray5,
                      ),
                      const SizedBox(height: AppSpaceValues.space2),

                      // "... To Y destination."
                      Row(
                        children: [
                          const Icon(
                            Icons.edit_location_outlined,
                            size: AppSpaceValues.space4,
                            color: AppColors.indigo7,
                          ),
                          const SizedBox(width: AppSpaceValues.space3),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.whereIsTheUserDestination,
                                style: const TextStyle(
                                  color: AppColors.gray9,
                                  fontSize: AppFontSizes.ml,
                                  fontWeight: AppFontWeights.light,
                                ),
                              ),
                              Text(
                                AppStrings.selectedDestination,
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
        ],
      ),
    );
  }
}


