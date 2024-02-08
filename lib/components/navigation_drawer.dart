import 'package:flutter/material.dart';

import '../constants.dart';

class CustomNavigationDrawer extends StatefulWidget {
  String? name;
  String? email;
  String? phone;

  CustomNavigationDrawer({ this.name, this.email, this.phone });

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

/// ABOUT THE 'const' PREFIX WARNINGS FROM FLUTTER: We need the Text
/// widgets to not be constant because the user can change accounts and,
/// consequently, the user's data displayed by the Text widgets will have
/// to change.
///
/// Ignore the warnings from Flutter and DO NOT set the Text widgets as
/// constant!
class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Drawer's header:
          Container(
            height: 165,
            color: AppColors.gray4,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.gray9),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.gray4
                  ),

                  const SizedBox(width: AppSpaceValues.space3),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Account's name:
                      Text(
                        widget.name.toString(),
                        style: const TextStyle(
                          fontSize: AppFontSizes.m,
                          color: AppColors.gray4,
                          fontWeight: AppFontWeights.bold,
                        ),
                      ),

                      // Account's email:
                      Text(
                        widget.email.toString(),
                        style: const TextStyle(
                          fontSize: AppFontSizes.s,
                          color: AppColors.gray4,
                          fontWeight: AppFontWeights.regular,
                        ),
                      ),

                      // Account's phone:
                      Text(
                        widget.phone.toString(),
                        style: const TextStyle(
                          fontSize: AppFontSizes.s,
                          color: AppColors.gray4,
                          fontWeight: AppFontWeights.regular,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Drawer's body:

        ],
      ),
    );
  }
}
