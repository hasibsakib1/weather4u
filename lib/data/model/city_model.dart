import 'dart:convert';

class CityModel {
    String name;
    Map<String, String>? localNames;
    double? lat;
    double? lon;
    String country;
    String? state;

    CityModel({
        required this.name,
        this.localNames,
        this.lat,
        this.lon,
        required this.country,
        this.state,
    });



    factory CityModel.fromRawJson(String str) => CityModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        name: json["name"],
        localNames: Map.from(json["local_names"]!).map((k, v) => MapEntry<String, String>(k, v)),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        country: json["country"],
        state: json["state"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "local_names": Map.from(localNames!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "lat": lat,
        "lon": lon,
        "country": country,
        "state": state,
    };
}
