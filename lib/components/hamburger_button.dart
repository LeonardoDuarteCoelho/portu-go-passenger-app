import 'package:flutter/material.dart';
import 'package:portu_go_passenger/constants.dart';

class CustomHamburgerButton extends StatelessWidget {
  final double topPosition;
  final double? leftPosition;
  final double? rightPosition;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final IconData icon;

  const CustomHamburgerButton({
    Key? key,
    required this.topPosition,
    this.leftPosition,
    this.rightPosition,
    this.backgroundColor = AppColors.indigo7,
    this.iconColor = AppColors.white,
    required this.onTap,
    required this.icon,
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