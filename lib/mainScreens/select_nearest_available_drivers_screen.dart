import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portu_go_passenger/assistants/assistant_methods.dart';
import 'package:portu_go_passenger/global/global.dart';
import 'package:portu_go_passenger/mainScreens/main_screen.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../constants.dart';

class SelectNearestAvailableDriversScreen extends StatefulWidget {
  DatabaseReference? rideRequestRef;
  SelectNearestAvailableDriversScreen({ super.key, this.rideRequestRef });

  @override
  State<SelectNearestAvailableDriversScreen> createState() => _SelectNearestAvailableDriversScreenState();
}

class _SelectNearestAvailableDriversScreenState extends State<SelectNearestAvailableDriversScreen> {
  String goCarTypeImageName = 'car-go-type-four-doors.png';
  String primeCarTypeImageName = 'car-prime-type-four-doors.png';
  String imageNameToBeInserted = '';
  double carTypeIconWidth = 100;
  String fareAmount = '';
  double primeTypeCarFareAmountIncrease = 1.15; // This value will be multiplied by the standard billing fee, making Prime-type cars more expensive.

  @override
  void initState() {
    super.initState();
  }

  String tripDurationTreatedText() {
    if(tripDirectionRouteDetails != null) {
      String durationText = tripDirectionRouteDetails!.durationText!;
      // Replace 'hours' and 'hour' with 'horas', and 'hora', respectively
      String treatedDurationText = durationText.replaceAll('hours', 'horas').replaceAll('hour', 'hora');

      // Find the index of 'hora' or 'horas' to keep everything before it
      int hourIndex = treatedDurationText.indexOf('hora');
      if(hourIndex != -1) {
        // Add 4 or 5 to include 'hora' or 'horas' in the result
        int endIndex = treatedDurationText.contains('horas') ? hourIndex + 5 : hourIndex + 4;
        treatedDurationText = treatedDurationText.substring(0, endIndex);
      }
      return treatedDurationText;
    } else {
      return '';
    }
  }

  // Based on the car type showed on the database, the image displayed and the fare amount charged will vary.
  getCarTypeAndSetCarImageAndFareAmount(int index) {
    if(tripDirectionRouteDetails != null) {
      if(driversList[index]['carInfo']['carType'] == AppStrings.goCarType) {
        imageNameToBeInserted = goCarTypeImageName;
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionRouteDetails!)).toStringAsFixed(2);
      } else if(driversList[index]['carInfo']['carType'] == AppStrings.primeCarType) {
        imageNameToBeInserted = primeCarTypeImageName;
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionRouteDetails!) * primeTypeCarFareAmountIncrease).toStringAsFixed(2);
      }
    }
    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray4,
      appBar: AppBar(
        backgroundColor: AppColors.indigo7,
        title: const Text(
          AppStrings.nearbyDrivers,
          style: TextStyle(
              fontSize: AppFontSizes.l,
              color: AppColors.white,
              fontWeight: AppFontWeights.medium
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          iconSize: AppSpaceValues.space4,
          onPressed: () {
            widget.rideRequestRef!.remove();
            driversList.clear();
            Navigator.pop(context);
            // Navigator.push(context, MaterialPageRoute(builder: (c) => const MainScreen()));
          },
        ),
      ),
      body: ListView.builder(
        itemCount: driversList.length,
        itemBuilder: (BuildContext context, int index) {
          getCarTypeAndSetCarImageAndFareAmount(index);

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDriverId = driversList[index]['id'].toString();
              });
              driversList.clear();
              Navigator.pop(context, AppStrings.chosenDriver);
            },
            child: Card(
              color: Colors.white,
              elevation: 2,
              shadowColor: AppColors.gray7,
              margin: const EdgeInsets.only(
                left: AppSpaceValues.space1,
                top: AppSpaceValues.space2,
                right: AppSpaceValues.space1,
              ),
              child: ListTile(
                leading: Image.asset(
                  'images/$imageNameToBeInserted',
                  width: carTypeIconWidth,
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driversList[index]['name'],
                      style: const TextStyle(
                        fontSize: AppFontSizes.ml,
                        color: AppColors.gray9,
                        fontWeight: AppFontWeights.semiBold,
                        height: AppLineHeights.ml
                      ),
                    ),
            
                    SmoothStarRating(
                      rating: (driversList[index]['ratings'] == null) ? 0 : driversList[index]['ratings'],
                      color: AppColors.indigo9,
                      borderColor: AppColors.indigo9,
                      allowHalfRating: false,
                      starCount: maxNumberOfRatingStarts,
                      size: AppSpaceValues.space3,
                    ),
            
                    const SizedBox(height: AppSpaceValues.space1),
            
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 62,
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '${AppStrings.carModel}:',
                                    style: TextStyle(
                                        fontSize: AppFontSizes.sm,
                                        color: AppColors.gray9,
                                        fontWeight: AppFontWeights.semiBold,
                                        height: AppLineHeights.ml
                                    ),
                                  ),
            
                                  Text(
                                    driversList[index]['carInfo']['carModel'],
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: AppFontSizes.sm,
                                        color: AppColors.gray9,
                                        fontWeight: AppFontWeights.regular,
                                        height: AppLineHeights.ml
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
            
                        const SizedBox(width: AppSpaceValues.space1),
            
                        SizedBox(
                          height: 62,
                          width: 80,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: AppSpaceValues.space3,
                                  ),
            
                                  const SizedBox(width: AppSpaceValues.space1),
            
                                  Text(
                                    tripDirectionRouteDetails != null ? tripDirectionRouteDetails!.distanceText! : '',
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.sm,
                                      color: AppColors.gray9,
                                      fontWeight: AppFontWeights.regular,
                                    ),
                                  ),
                                ],
                              ),
            
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timelapse,
                                    size: AppSpaceValues.space3,
                                  ),
            
                                  const SizedBox(width: AppSpaceValues.space1),
            
                                  Text(
                                    tripDurationTreatedText(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.sm,
                                      color: AppColors.gray9,
                                      fontWeight: AppFontWeights.regular,
                                      height: AppLineHeights.m
                                    ),
                                  ),
                                ],
                              ),
            
                              Row(
                                children: [
                                  const Icon(
                                    Icons.euro,
                                    size: AppSpaceValues.space3,
                                  ),
            
                                  const SizedBox(width: AppSpaceValues.space1),
            
                                  Text(
                                    fareAmount,
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.sm,
                                      color: AppColors.gray9,
                                      fontWeight: AppFontWeights.regular,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
