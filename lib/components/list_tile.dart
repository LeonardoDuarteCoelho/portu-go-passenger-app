import 'package:flutter/material.dart';
import 'package:portu_go_passenger/constants.dart';

class CustomListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color textColor;
  final double iconPadding;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;

  const CustomListTile({
    Key? key,
    required this.onTap,
    required this.text,
    required this.textColor,
    required this.iconPadding,
    required this.icon,
    required this.iconSize,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: SizedBox(
          width: iconPadding,
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
        title: Text(
          text,
          style: TextStyle(
              color: textColor,
              fontSize: AppFontSizes.m,
              fontWeight: AppFontWeights.medium
          ),
        ),
      ),
    );
  }
}
