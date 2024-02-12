import 'package:flutter/material.dart';
import 'package:portu_go_passenger/components/list_tile.dart';

import '../authenticationScreens/login_screen.dart';
import '../constants.dart';
import '../global/global.dart';

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
  static const Color headerText = AppColors.white;
  static const Color headerIcon = AppColors.white;
  static const Color headerBackground = AppColors.indigo7;
  static const Color headerBackgroundFooter = AppColors.indigo2;
  static const Color bodyIcon = AppColors.gray9;
  static const Color bodyText = AppColors.gray9;

  navigateToLogInScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (c) => const LogInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Drawer's header:
          Container(
            height: 165,
            color: headerBackgroundFooter,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: headerBackground),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 50,
                    color: headerIcon
                  ),

                  const SizedBox(width: AppSpaceValues.space3),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account's name:
                      Container(
                        width: 190,
                        child: Text(
                          widget.name.toString(),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            height: AppLineHeights.ml,
                            fontSize: AppFontSizes.ml,
                            color: headerText,
                            fontWeight: AppFontWeights.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpaceValues.space3),

                      // Account's email:
                      Container(
                        width: 190,
                        child: Text(
                          widget.email.toString(),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            height: AppLineHeights.ml,
                            fontSize: AppFontSizes.s,
                            color: headerText,
                            fontWeight: AppFontWeights.regular,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpaceValues.space2),

                      // Account's phone:
                      Container(
                        width: 190,
                        child: Text(
                          widget.phone.toString(),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: const TextStyle(
                            height: AppLineHeights.m,
                            fontSize: AppFontSizes.s,
                            color: headerText,
                            fontWeight: AppFontWeights.regular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpaceValues.space2),

          // Drawer's body:
          CustomListTile(
              onTap: () { print("test"); },
              text: AppStrings.history,
              textColor: bodyText,
              iconPadding: AppSpaceValues.space5,
              icon: Icons.history,
              iconSize: AppSpaceValues.space4,
          ),
          CustomListTile(
            onTap: () { print("test"); },
            text: AppStrings.profile,
            textColor: bodyText,
            iconPadding: AppSpaceValues.space5,
            icon: Icons.person,
            iconSize: AppSpaceValues.space4,
          ),
          CustomListTile(
            onTap: () { print("test"); },
            text: AppStrings.news,
            textColor: bodyText,
            iconPadding: AppSpaceValues.space5,
            icon: Icons.info_outline,
            iconSize: AppSpaceValues.space4,
          ),
          CustomListTile(
            onTap: () {
              fAuth.signOut();
              navigateToLogInScreen();
            },
            text: AppStrings.signOut,
            textColor: bodyText,
            iconPadding: AppSpaceValues.space5,
            icon: Icons.logout,
            iconSize: AppSpaceValues.space4,
          ),
        ],
      ),
    );
  }
}
