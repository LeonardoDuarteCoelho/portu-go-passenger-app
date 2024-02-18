/// Based on the JSON format provided by the autocomplete API.
/// (See documentation: https://developers.google.com/maps/documentation/places/web-service/autocomplete#maps_http_places_autocomplete_amoeba-txt)
class PredictedPlaces {
  String? place_id;
  String? main_text;
  String? secondary_text;

  PredictedPlaces({
    this.place_id,
    this.main_text,
    this.secondary_text,
  });

  PredictedPlaces.fromJson(Map<String, dynamic> jsonData) {
    place_id = jsonData['place_id'];
    main_text = jsonData['structured_formatting']['main_text'];
    secondary_text = jsonData['structured_formatting']['secondary_text'];
  }
}