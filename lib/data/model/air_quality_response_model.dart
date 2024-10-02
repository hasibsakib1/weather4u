// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AirQualityResponseModel {
  Coord coord;
  AirQuality airQuality;

  AirQualityResponseModel({
    required this.coord,
    required this.airQuality,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "coord": coord.toJson(),
        "airQuality": airQuality.toJson(),
      };

  factory AirQualityResponseModel.fromRawJson(String str) =>
      AirQualityResponseModel.fromJson(json.decode(str));

  factory AirQualityResponseModel.fromJson(Map<String, dynamic> json) =>
      AirQualityResponseModel(
        coord: Coord.fromJson(json["coord"]),
        airQuality: AirQuality.fromJson(json["list"][0]),
      );

  @override
  String toString() =>
      'AirQualityModel(coord: ${coord.toString()}, airQuality: ${airQuality.toString()})';
      
}

class AirQuality {
  int aqi;
  Map<String, double> components;
  int dt;

  AirQuality({
    required this.aqi,
    required this.components,
    required this.dt,
  });

  factory AirQuality.fromRawJson(String str) =>
      AirQuality.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AirQuality.fromJson(Map<String, dynamic> json) => AirQuality(
        aqi: json["main"]["aqi"],
        components: Map.from(json["components"])
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
        dt: json["dt"],
      );

  Map<String, dynamic> toJson() => {
        "main": aqi,
        "components":
            Map.from(components).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "dt": dt,
      };

  @override
  String toString() =>
      'AirQuality(aqi: $aqi, components: $components, dt: $dt)';
}

class Coord {
  double lon;
  double lat;

  Coord({
    required this.lon,
    required this.lat,
  });

  factory Coord.fromRawJson(String str) => Coord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
        lon: json["lon"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
      };

  @override
  String toString() => 'Coord(lon: $lon, lat: $lat)';
}
