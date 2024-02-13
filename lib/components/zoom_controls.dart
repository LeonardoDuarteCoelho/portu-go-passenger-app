import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portu_go_passenger/constants.dart';

class CustomZoomControls extends StatelessWidget {
  final GoogleMapController mapController;
  final double? positionLeft;
  final double? positionRight;
  final double positionBottom;
  final Color backgroundColor;
  final Color iconColor;

  const CustomZoomControls({
    Key? key,
    required this.mapController,
    this.positionLeft,
    this.positionRight,
    required this.positionBottom,
    this.backgroundColor = AppColors.indigo7Transparent90,
    this.iconColor = AppColors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: positionLeft,
      right: positionRight,
      bottom: positionBottom,
      child: Column(
        children: <Widget>[
          FloatingActionButton(
            mini: true,
            heroTag: 'zoom_in',
            backgroundColor: backgroundColor,
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomIn());
            },
            child: Icon(
              Icons.add,
              color: iconColor,
            ),
          ),

          const SizedBox(height: AppSpaceValues.space1),

          FloatingActionButton(
            mini: true,
            heroTag: 'zoom_out',
            backgroundColor: backgroundColor,
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomOut());
            },
            child: Icon(
              Icons.remove,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
