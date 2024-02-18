import 'package:flutter/material.dart';
import 'package:portu_go_passenger/assistants/assistant_request.dart';
import 'package:portu_go_passenger/components/place_prediction_tile.dart';
import 'package:portu_go_passenger/constants.dart';
import 'package:portu_go_passenger/global/map_api_key.dart';
import 'package:portu_go_passenger/models/predicted_places.dart';

class SearchPlacesScreen extends StatefulWidget {

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placesPredictedList = [];

  void findPlaceAutocompleteSearch(String inputText) async {
    // We don't want to send suggestions when the user still didn't type anything!
    if(inputText.length > 1) {
      String urlAutocompleteSearch = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:PT';
      var responseAutocompleteSearch = await AssistantRequest.receiveRequest(urlAutocompleteSearch);

      if(responseAutocompleteSearch == AppStrings.connectToApiError) {
        return;
      }
      if(responseAutocompleteSearch['status'] == 'OK') {
        // Variable containing the JSON data provided by the API:
        var placePredictions = responseAutocompleteSearch['predictions'];
        // Below, we're treating this JSON data as a list:
        var placePredictionsList = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();
        // Now, 'placePredictionsList' is stored in the external variable 'placesPredictedList',
        // which makes it accessible outside this method.
        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [

          // SEARCH LOCATION UI:
          Container(
            height: 190,
            decoration: const BoxDecoration(
              color: AppColors.gray3,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gray7,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7, 0.7,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpaceValues.space3),
              child: Column(
                children: [
                  const SizedBox(height: AppSpaceValues.space4),

                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.gray9,
                          size: AppSpaceValues.space4,
                        ),
                      ),

                      const Center(
                        child: Text(
                          AppStrings.findLocation,
                          style: TextStyle(
                            fontSize: AppFontSizes.l,
                            color: AppColors.gray9,
                            fontWeight: AppFontWeights.semiBold
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: AppSpaceValues.space4),

                  Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: AppColors.gray9,
                        size: AppSpaceValues.space3,
                      ),

                      const SizedBox(width: AppSpaceValues.space2),

                      Expanded(
                        child: TextField(
                          onChanged: (valueTyped) {
                            findPlaceAutocompleteSearch(valueTyped);
                          },
                          decoration: InputDecoration(
                            hintText: AppStrings.findLocationHintText,
                            hintStyle: const TextStyle(
                              fontSize: AppFontSizes.m,
                              fontWeight: AppFontWeights.medium,
                              color: AppColors.gray6,
                            ),
                            fillColor: AppColors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpaceValues.space9),
                              borderSide: const BorderSide(color: AppColors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpaceValues.space9),
                              borderSide: const BorderSide(color: AppColors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpaceValues.space9),
                              borderSide: const BorderSide(color: AppColors.transparent),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: AppSpaceValues.space3,
                              top: AppSpaceValues.space2,
                              bottom: AppSpaceValues.space2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

/***************************************************************************************************/

          // DISPLAY FOR THE PLACE PREDICTIONS RESULTS:
          (placesPredictedList.isNotEmpty)
          ? Expanded(
            child: ListView.separated(
              itemCount: placesPredictedList.length,
              itemBuilder: (context, index) {
                // Each location prediction provided by the API is being built into this design.
                return PlacePredictionTileDesign(
                  // It is then displayed based on index.
                  predictedPlaces: placesPredictedList[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                // Each View is divided with this Divider widget.
                return const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.gray5,
                );
              },
              physics: const ClampingScrollPhysics(),
            ),
          )
          : Container(),
        ],
      ),
    );
  }
}
