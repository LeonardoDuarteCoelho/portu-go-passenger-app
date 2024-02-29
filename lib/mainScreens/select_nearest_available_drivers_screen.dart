import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portu_go_passenger/global/global.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../constants.dart';

class SelectNearestAvailableDriversScreen extends StatefulWidget {
  const SelectNearestAvailableDriversScreen({super.key});

  @override
  State<SelectNearestAvailableDriversScreen> createState() => _SelectNearestAvailableDriversScreenState();
}

class _SelectNearestAvailableDriversScreenState extends State<SelectNearestAvailableDriversScreen> {
  String goCarTypeImageName = 'car-go-type-four-doors.png';
  String primeCarTypeImageName = 'car-prime-type-four-doors.png';
  String imageNameToBeInserted = '';
  double carTypeIconWidth = 100;
  int maxNumberOfRatingStarts = 5;

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
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: driversList.length,
        itemBuilder: (BuildContext context, int index) {
          // Based on the car type showed on the database, the image displayed will vary.
          if(driversList[index]['carInfo']['carType'] == 'GO') {
            imageNameToBeInserted = goCarTypeImageName;
          } else if(driversList[index]['carInfo']['carType'] == 'Prime') {
            imageNameToBeInserted = primeCarTypeImageName;
          }

          return Card(
            color: Colors.white,
            elevation: 2,
            shadowColor: AppColors.gray7,
            margin: const EdgeInsets.only(
              left: AppSpaceValues.space2,
              top: AppSpaceValues.space2,
              right: AppSpaceValues.space2,
            ),
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(AppSpaceValues.space1),
                child: Image.asset(
                  'images/$imageNameToBeInserted',
                  width: carTypeIconWidth,
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    rating: 3.5,
                    color: AppColors.indigo9,
                    borderColor: AppColors.indigo9,
                    allowHalfRating: true,
                    starCount: maxNumberOfRatingStarts,
                    size: AppSpaceValues.space4,
                  ),

                  const SizedBox(height: AppSpaceValues.space1),

                  Text(
                    driversList[index]['carInfo']['carModel'],
                    style: const TextStyle(
                      fontSize: AppFontSizes.sm,
                      color: AppColors.gray9,
                      fontWeight: AppFontWeights.regular,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
