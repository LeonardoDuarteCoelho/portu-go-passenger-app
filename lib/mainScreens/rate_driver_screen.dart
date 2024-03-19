import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:portu_go_passenger/components/button.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../constants.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';

class RateDriverScreen extends StatefulWidget {
  String? driverOnTripId;

  RateDriverScreen({super.key, this.driverOnTripId});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  DatabaseReference? driverRatingRef;
  double? driverPreviousRatings;
  double? driverRatingsAfterTrip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.indigo7,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpaceValues.space5),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter, // Gradient begins at the top
              end: Alignment.bottomCenter, // And ends at the bottom
              colors: [
                AppColors.gray2,
                AppColors.gray0,
                AppColors.gray0,
                AppColors.gray2
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpaceValues.space5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpaceValues.space4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  AppStrings.rateDriver,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: AppFontWeights.semiBold,
                    color: AppColors.gray9,
                    fontSize: AppFontSizes.l,
                    height: AppLineHeights.ml
                  ),
                ),

                const SizedBox(height: AppSpaceValues.space4),
                const Divider(height: 1, thickness: 1, color: AppColors.gray5),
                const SizedBox(height: AppSpaceValues.space4),

                SmoothStarRating(
                  rating: passengerRatingForDriver,
                  allowHalfRating: true,
                  starCount: maxNumberOfRatingStarts,
                  size: AppSpaceValues.space6,
                  color: AppColors.warning,
                  onRatingChanged: (starsValue) {
                    passengerRatingForDriver = starsValue;
                    switch(passengerRatingForDriver) {
                      case 1:
                        setState(() {
                          driverRatingDescription = AppStrings.driverRatingOneStar;
                        });
                        break;
                      case 2:
                        setState(() {
                          driverRatingDescription = AppStrings.driverRatingTwoStar;
                        });
                        break;
                      case 3:
                        setState(() {
                          driverRatingDescription = AppStrings.driverRatingThreeStar;
                        });
                        break;
                      case 4:
                        setState(() {
                          driverRatingDescription = AppStrings.driverRatingFourStar;
                        });
                        break;
                      case 5:
                        setState(() {
                          driverRatingDescription = AppStrings.driverRatingFiveStar;
                        });
                        break;
                    }
                  },
                ),

                const SizedBox(height: AppSpaceValues.space2),

                Text(
                  driverRatingDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: AppFontWeights.medium,
                    color: AppColors.gray9,
                    fontSize: AppFontSizes.xl,
                  ),
                ),

                const SizedBox(height: AppSpaceValues.space4),
                const Divider(height: 1, thickness: 1, color: AppColors.gray5),
                const SizedBox(height: AppSpaceValues.space4),

                CustomButton(
                  text: AppStrings.confirmDriverRating,
                  onPressed: () {
                    driverRatingRef = FirebaseDatabase.instance.ref().child('drivers').child(selectedDriverId!).child('ratings');
                    driverRatingRef!.once().then((snap) {
                      // If the driver didn't have any previous ratings...
                      if(snap.snapshot.value == null) {
                        driverRatingRef!.set(passengerRatingForDriver.toString());
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const SplashScreen()));
                      }
                      // If driver has previous ratings...
                      else {
                        driverPreviousRatings = double.parse(snap.snapshot.value.toString());
                        // Calculating the average ratings based on the new rating:
                        driverRatingsAfterTrip = (driverPreviousRatings! + passengerRatingForDriver) / 2;
                        driverRatingRef!.set(driverRatingsAfterTrip.toString());
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const SplashScreen()));
                      }
                      Fluttertoast.showToast(msg: AppStrings.thankingPassengerForSendRating);
                    });
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
