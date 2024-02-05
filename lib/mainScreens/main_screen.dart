import 'package:flutter/material.dart';
import 'package:portu_go_passenger/authenticationScreens/login_screen.dart';
import 'package:portu_go_passenger/components/button.dart';
import 'package:portu_go_passenger/constants.dart';
import 'package:portu_go_passenger/global/global.dart';

class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
          text: AppStrings.signOut,
          onPressed: () {
            fAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c) => const LogInScreen()));
          }
      ),
    );
  }
}
