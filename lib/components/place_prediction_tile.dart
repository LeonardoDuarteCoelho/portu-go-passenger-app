import 'package:flutter/material.dart';
import 'package:portu_go_passenger/constants.dart';
import 'package:portu_go_passenger/models/predicted_places.dart';

class PlacePredictionTileDesign extends StatelessWidget {
  late final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({ this.predictedPlaces });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.gray9,
            size: AppSpaceValues.space4,
          ),

          const SizedBox(width: AppSpaceValues.space3),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpaceValues.space2),

                Text(
                  predictedPlaces!.main_text!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppFontSizes.ml,
                    color: AppColors.gray9,
                    fontWeight: AppFontWeights.regular
                  ),
                ),

                const SizedBox(height: AppSpaceValues.space1),

                Text(
                  predictedPlaces!.secondary_text!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppFontSizes.sm,
                    color: AppColors.gray7,
                    fontWeight: AppFontWeights.regular
                  ),
                ),

                const SizedBox(height: AppSpaceValues.space2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
