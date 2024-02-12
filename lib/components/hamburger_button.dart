import 'package:flutter/material.dart';
import 'package:portu_go_passenger/constants.dart';

class CustomHamburgerButton extends StatelessWidget {
  final double topPosition;
  final double? leftPosition;
  final double? rightPosition;
  final VoidCallback onTap;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  const CustomHamburgerButton({
    Key? key,
    required this.topPosition,
    this.leftPosition,
    this.rightPosition,
    required this.onTap,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPosition,
      left: leftPosition,
      right: rightPosition,
      child: GestureDetector(
        onTap: onTap, // Use the VoidCallback onTap function here
        child: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}