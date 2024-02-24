import 'package:flutter/material.dart';
import 'package:portu_go_passenger/assistants/assistant_request.dart';
import 'package:portu_go_passenger/components/progress_dialog.dart';
import 'package:portu_go_passenger/constants.dart';
import 'package:portu_go_passenger/global/global.dart';
import 'package:portu_go_passenger/global/map_api_key.dart';
import 'package:portu_go_passenger/infoHandler/app_info.dart';
import 'package:portu_go_passenger/models/directions.dart';
import 'package:portu_go_passenger/models/predicted_places.dart';
import 'package:provider/provider.dart';

class PlacePredictionTileDesign extends StatelessWidget {
  late final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({ this.predictedPlaces });

  getPlaceDirectionInfo(String? placeId, context) async {
    String placeDirectionInfoUrl;

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: AppStrings.loading3,
      ),
    );
    placeDirectionInfoUrl = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey';
    var responseApi = await AssistantRequest.receiveRequest(placeDirectionInfoUrl);
    Navigator.pop(context);
    if(responseApi == AppStrings.connectToApiError) {
      return;
    }
    if(responseApi['status'] == 'OK') {
      Directions directions = Directions();
      // For navigating this JSON file, see documentation: https://developers.google.com/maps/documentation/places/web-service/details
      directions.locationName = responseApi['result']['name'];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi['result']['geometry']['location']['lat'];
      directions.locationLongitude = responseApi['result']['geometry']['location']['lng'];

      Provider.of<AppInfo>(context, listen: false).updateDropOffAddress(directions);
      Navigator.pop(context, AppStrings.destinationSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getPlaceDirectionInfo(predictedPlaces!.place_id, context);
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
