import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../splashScreen/splash_screen.dart';
import 'button.dart';

class LocationPermissionWarning extends StatelessWidget {
  const LocationPermissionWarning({super.key});

  @override
  Widget build(BuildContext context) {

    navigateToSplashScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (c) => const SplashScreen()));
    }

    return Positioned.fill(
      child: Container(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(AppSpaceValues.space3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off_outlined,
                color: AppColors.indigo7,
                size: AppSpaceValues.space9,
              ),

              const SizedBox(height: AppSpaceValues.space2),

              const Text(
                AppStrings.permissionDenied,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.indigo7,
                    fontSize: AppFontSizes.xxl,
                    fontWeight: AppFontWeights.semiBold
                ),
              ),

              const SizedBox(height: AppSpaceValues.space6),

              const Text(
                AppStrings.permissionIsNecessaryForApp,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.gray9,
                  fontSize: AppFontSizes.ml,
                  height: AppLineHeights.ml,
                  fontWeight: AppFontWeights.regular,
                ),
              ),

              const SizedBox(height: AppSpaceValues.space4),

              const Text(
                AppStrings.enablingPermissionStepOne,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColors.gray9,
                    fontSize: AppFontSizes.m,
                    height: AppLineHeights.ml,
                    fontWeight: AppFontWeights.semiBold
                ),
              ),

              const SizedBox(height: AppSpaceValues.space2),

              const Text(
                AppStrings.enablingPermissionStepTwo,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColors.gray9,
                    fontSize: AppFontSizes.m,
                    height: AppLineHeights.ml,
                    fontWeight: AppFontWeights.semiBold
                ),
              ),

              const SizedBox(height: AppSpaceValues.space2),

              const Text(
                AppStrings.enablingPermissionStepThree,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.gray9,
                    fontSize: AppFontSizes.m,
                    height: AppLineHeights.ml,
                    fontWeight: AppFontWeights.semiBold
                ),
              ),

              const SizedBox(height: AppSpaceValues.space2),

              const Text(
                AppStrings.enablingPermissionStepFour,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.gray9,
                    fontSize: AppFontSizes.m,
                    height: AppLineHeights.ml,
                    fontWeight: AppFontWeights.semiBold
                ),
              ),

              const SizedBox(height: AppSpaceValues.space2),

              const Text(
                AppStrings.enablingPermissionStepFive,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.gray9,
                    fontSize: AppFontSizes.m,
                    height: AppLineHeights.ml,
                    fontWeight: AppFontWeights.semiBold
                ),
              ),

              const SizedBox(height: AppSpaceValues.space6),

              CustomButton(
                text: AppStrings.enablePermission,
                icon: Icons.settings,
                backgroundColor: AppColors.gray2,
                textColor: AppColors.gray9,
                onPressed: () => AppSettings.openAppSettings(),
              ),

              const SizedBox(height: AppSpaceValues.space4),

              CustomButton(
                text: AppStrings.restartApp,
                icon: Icons.restart_alt,
                onPressed: () { navigateToSplashScreen(); },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
