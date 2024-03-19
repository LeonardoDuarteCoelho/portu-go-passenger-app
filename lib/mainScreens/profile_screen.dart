import 'package:flutter/material.dart';
import 'package:portu_go_passenger/components/profile_info_design_ui.dart';
import 'package:portu_go_passenger/global/global.dart';

import '../constants.dart';
import 'main_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.indigo7,
        title: const Text(
          AppStrings.profile,
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
            Navigator.push(context, MaterialPageRoute(builder: (c) => const MainScreen()));
          },
        ),
      ),
      backgroundColor: AppColors.gray3,
      body: Padding(
        padding: const EdgeInsets.all(AppSpaceValues.space3),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                passengerModelCurrentInfo!.name!,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppFontSizes.xxl,
                  color: AppColors.gray9,
                  fontWeight: AppFontWeights.medium,
                  height: AppLineHeights.ml
                ),
              ),

              const SizedBox(height: AppSpaceValues.space3, child:
                Divider(color: AppColors.gray7)
              ),
              const SizedBox(height: AppSpaceValues.space5),

              InfoDesignUI(
                textInfo: passengerModelCurrentInfo!.phone!,
                icon: Icons.phone,
              ),
              InfoDesignUI(
                textInfo: passengerModelCurrentInfo!.email!,
                icon: Icons.email,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
