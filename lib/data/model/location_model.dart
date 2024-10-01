import 'dart:convert';

class LocationModel {
  String? name;
  LocalNames? localNames;
  double lat;
  double lon;
  String? country;
  String? state;

  LocationModel({
    this.name,
    this.localNames,
    required this.lat,
    required this.lon,
    this.country,
    this.state,
  });

  @override
  String toString() {
    return 'LocationModel{name: $name, lat: $lat, lon: $lon, country: $country, state: $state}';
  }

  factory LocationModel.fromRawJson(String str) =>
      LocationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        name: json["name"],
        localNames: json["local_names"] == null
            ? null
            : LocalNames.fromJson(json["local_names"]),
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
        country: json["country"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "local_names": localNames?.toJson(),
        "lat": lat,
        "lon": lon,
        "country": country,
        "state": state,
      };
}

class LocalNames {
  String? en;
  String? bn;
  String? fr;
  String? sr;

  LocalNames({
    this.en,
    this.bn,
    this.fr,
    this.sr,
  });

  factory LocalNames.fromRawJson(String str) =>
      LocalNames.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocalNames.fromJson(Map<String, dynamic> json) => LocalNames(
        en: json["en"],
        bn: json["bn"],
        fr: json["fr"],
        sr: json["sr"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "bn": bn,
        "fr": fr,
        "sr": sr,
      };
}
