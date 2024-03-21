import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:portu_go_passenger/components/list_tile.dart';
import 'package:portu_go_passenger/mainScreens/profile_screen.dart';
import 'package:portu_go_passenger/mainScreens/trips_history_screen.dart';
import 'package:portu_go_passenger/splashScreen/splash_screen.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Color headerText = AppColors.white;
  Color headerIcon = AppColors.white;
  Color headerBackground = AppColors.indigo7;
  Color headerBackgroundFooter = AppColors.indigo2;
  Color bodyIcon = AppColors.gray9;
  Color bodyText = AppColors.gray9;

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
              decoration: BoxDecoration(color: headerBackground),
              child: Row(
                children: [
                  Icon(
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
                      SizedBox(
                        width: 190,
                        child: Text(
                          widget.name.toString(),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            height: AppLineHeights.ml,
                            fontSize: AppFontSizes.ml,
                            color: headerText,
                            fontWeight: AppFontWeights.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpaceValues.space3),

                      // Account's email:
                      SizedBox(
                        width: 190,
                        child: Text(
                          widget.email.toString(),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            height: AppLineHeights.ml,
                            fontSize: AppFontSizes.s,
                            color: headerText,
                            fontWeight: AppFontWeights.regular,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpaceValues.space2),

                      // Account's phone:
                      SizedBox(
                        width: 190,
                        child: Text(
                          widget.phone.toString(),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: TextStyle(
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const TripsHistoryScreen()));
              },
              text: AppStrings.history,
              textColor: bodyText,
              iconPadding: AppSpaceValues.space5,
              icon: Icons.history,
            iconColor: bodyIcon,
            iconSize: AppSpaceValues.space4,
          ),

          CustomListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const ProfileScreen()));
            },
            text: AppStrings.profile,
            textColor: bodyText,
            iconPadding: AppSpaceValues.space5,
            icon: Icons.person_outline,
            iconColor: bodyIcon,
            iconSize: AppSpaceValues.space4,
          ),

          CustomListTile(
            onTap: () {
              launchUrl(
                Uri.parse(portuGoWebsiteUrl),
                mode: LaunchMode.inAppBrowserView
              );
            },
            text: AppStrings.aboutUs,
            textColor: bodyText,
            iconPadding: AppSpaceValues.space5,
            icon: Icons.info_outline,
            iconColor: bodyIcon,
            iconSize: AppSpaceValues.space4,
          ),

          CustomListTile(
            onTap: () {
              setState(() {
                ifDarkThemeIsActive ? ifDarkThemeIsActive = false : ifDarkThemeIsActive = true;
              });
              ifDarkThemeIsActive ? Fluttertoast.showToast(msg: AppStrings.darkModeNowOn) : Fluttertoast.showToast(msg: AppStrings.lightModeNowOn);
              Restart.restartApp();
            },
            text: ifDarkThemeIsActive ? AppStrings.lightMode : AppStrings.darkMode,
            textColor: bodyText,
            iconPadding: AppSpaceValues.space5,
            icon: ifDarkThemeIsActive ? Icons.light_mode_outlined : Icons.nightlight_outlined,
            iconColor: bodyIcon,
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
            iconColor: bodyIcon,
            iconSize: AppSpaceValues.space4,
          ),
        ],
      ),
    );
  }
}
