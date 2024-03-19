import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:portu_go_passenger/components/button.dart';
import 'package:portu_go_passenger/constants.dart';
import 'package:restart_app/restart_app.dart';

import '../splashScreen/splash_screen.dart';

class FareAmountCollectionDialog extends StatefulWidget {
  double? tripPrice;
  FareAmountCollectionDialog({super.key, this.tripPrice});

  @override
  State<FareAmountCollectionDialog> createState() => _FareAmountCollectionDialogState();
}

class _FareAmountCollectionDialogState extends State<FareAmountCollectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpaceValues.space5),
      ),
      backgroundColor: AppColors.transparent,
      child: Container(
        margin: const EdgeInsets.all(AppSpaceValues.space1),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter, // Gradient begins at the top
            end: Alignment.bottomCenter, // And ends at the bottom
            colors: [
              AppColors.indigo7,
              AppColors.indigo5,
              AppColors.indigo7
            ],
          ),
          // color: AppColors.indigo7,
          borderRadius: BorderRadius.circular(AppSpaceValues.space5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpaceValues.space3,
            right: AppSpaceValues.space1,
            bottom: AppSpaceValues.space3,
            left: AppSpaceValues.space1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                AppStrings.tripPriceToPay,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: AppFontWeights.semiBold,
                  color: AppColors.white,
                  fontSize: AppFontSizes.l,
                ),
              ),

              const SizedBox(height: AppSpaceValues.space3),

              Text(
                '${widget.tripPrice!} ${AppStrings.euroSymbol}',
                style: const TextStyle(
                  fontWeight: AppFontWeights.bold,
                  color: AppColors.white,
                  fontSize: AppFontSizes.xxxxl,
                ),
              ),

              const SizedBox(height: AppSpaceValues.space3),

              CustomButton(
                text: AppStrings.confirmPayment,
                icon: Icons.credit_card,
                backgroundColor: AppColors.success3,
                textColor: AppColors.black,
                onPressed: () {
                  Fluttertoast.showToast(msg: AppStrings.paymentWasSuccessful);
                  Navigator.pop(context, 'tripPayed');
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
