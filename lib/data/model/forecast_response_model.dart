// ignore_for_file: constant_identifier_names

import 'dart:convert';

class ForecastResponseModel {
  String? cod;
  int? message;
  int? cnt;
  List<ListElement>? list;
  City? city;

  ForecastResponseModel({
    this.cod,
    this.message,
    this.cnt,
    this.list,
    this.city,
  });

  factory ForecastResponseModel.fromRawJson(String str) =>
      ForecastResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForecastResponseModel.fromJson(Map<String, dynamic> json) =>
      ForecastResponseModel(
        cod: json["cod"],
        message: json["message"],
        cnt: json["cnt"],
        list: json["list"] == null
            ? []
            : List<ListElement>.from(
                json["list"]!.map((x) => ListElement.fromJson(x))),
        city: json["city"] == null ? null : City.fromJson(json["city"]),
      );

  Map<String, dynamic> toJson() => {
        "cod": cod,
        "message": message,
        "cnt": cnt,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
        "city": city?.toJson(),
      };
}

class City {
  int? id;
  String? name;
  Coord? coord;
  String? country;
  int? population;
  int? timezone;
  int? sunrise;
  int? sunset;

  City({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
    this.sunrise,
    this.sunset,
  });

  factory City.fromRawJson(String str) => City.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        coord: json["coord"] == null ? null : Coord.fromJson(json["coord"]),
        country: json["country"],
        population: json["population"],
        timezone: json["timezone"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "coord": coord?.toJson(),
        "country": country,
        "population": population,
        "timezone": timezone,
        "sunrise": sunrise,
        "sunset": sunset,
      };
}

class Coord {
  double? lat;
  double? lon;

  Coord({
    this.lat,
    this.lon,
  });

  factory Coord.fromRawJson(String str) => Coord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
      };
}

class ListElement {
  int? dt;
  MainClass? main;
  List<Weather>? weather;
  Clouds? clouds;
  Wind? wind;
  int? visibility;
  double? pop;
  Sys? sys;
  DateTime? dtTxt;
  Rain? rain;

  ListElement({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
    this.sys,
    this.dtTxt,
    this.rain,
  });

  factory ListElement.fromRawJson(String str) =>
      ListElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        dt: json["dt"],
        main: json["main"] == null ? null : MainClass.fromJson(json["main"]),
        weather: json["weather"] == null
            ? []
            : List<Weather>.from(json["weather"]!
                .map((x) => x == null ? null : Weather.fromJson(x))),
        clouds: json["clouds"] == null ? null : Clouds.fromJson(json["clouds"]),
        wind: json["wind"] == null ? null : Wind.fromJson(json["wind"]),
        visibility: json["visibility"],
        pop: json["pop"]?.toDouble(),
        sys: json["sys"] == null ? null : Sys.fromJson(json["sys"]),
        dtTxt: json["dt_txt"] == null ? null : DateTime.parse(json["dt_txt"]),
        rain: json["rain"] == null ? null : Rain.fromJson(json["rain"]),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "main": main?.toJson(),
        "weather": weather == null
            ? []
            : List<dynamic>.from(weather!.map((x) => x.toJson())),
        "clouds": clouds?.toJson(),
        "wind": wind?.toJson(),
        "visibility": visibility,
        "pop": pop,
        "sys": sys?.toJson(),
        "dt_txt": dtTxt?.toIso8601String(),
        "rain": rain?.toJson(),
      };
}

class Clouds {
  int? all;

  Clouds({
    this.all,
  });

  factory Clouds.fromRawJson(String str) => Clouds.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
        all: json["all"],
      );

  Map<String, dynamic> toJson() => {
        "all": all,
      };
}

class MainClass {
  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;
  int? pressure;
  int? seaLevel;
  int? grndLevel;
  int? humidity;
  double? tempKf;

  MainClass({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.seaLevel,
    this.grndLevel,
    this.humidity,
    this.tempKf,
  });

  factory MainClass.fromRawJson(String str) =>
      MainClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MainClass.fromJson(Map<String, dynamic> json) => MainClass(
        temp: json["temp"]?.toDouble(),
        feelsLike: json["feels_like"]?.toDouble(),
        tempMin: json["temp_min"]?.toDouble(),
        tempMax: json["temp_max"]?.toDouble(),
        pressure: json["pressure"],
        seaLevel: json["sea_level"],
        grndLevel: json["grnd_level"],
        humidity: json["humidity"],
        tempKf: json["temp_kf"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "temp": temp,
        "feels_like": feelsLike,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "pressure": pressure,
        "sea_level": seaLevel,
        "grnd_level": grndLevel,
        "humidity": humidity,
        "temp_kf": tempKf,
      };
}

class Rain {
  double? the3H;

  Rain({
    this.the3H,
  });

  factory Rain.fromRawJson(String str) => Rain.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rain.fromJson(Map<String, dynamic> json) => Rain(
        the3H: json["3h"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "3h": the3H,
      };
}

class Sys {
  Pod? pod;

  Sys({
    this.pod,
  });

  factory Sys.fromRawJson(String str) => Sys.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sys.fromJson(Map<String, dynamic> json) => Sys(
        pod: podValues.map[json["pod"]]!,
      );

  Map<String, dynamic> toJson() => {
        "pod": podValues.reverse[pod],
      };
}

enum Pod { DAY, NIGHT }

final podValues = EnumValues({"d": Pod.DAY, "n": Pod.NIGHT});

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json["id"] ?? 0,
      main: json["main"] ?? '',
      description: json["description"] ?? '',
      icon: json["icon"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "main": main,
    "description": description,
    "icon": icon,
  };
}

enum Description {
  // Thunderstorm descriptions
  THUNDERSTORM_WITH_LIGHT_RAIN,
  THUNDERSTORM_WITH_RAIN,
  THUNDERSTORM_WITH_HEAVY_RAIN,
  LIGHT_THUNDERSTORM,
  THUNDERSTORM,
  HEAVY_THUNDERSTORM,
  RAGGED_THUNDERSTORM,
  THUNDERSTORM_WITH_LIGHT_DRIZZLE,
  THUNDERSTORM_WITH_DRIZZLE,
  THUNDERSTORM_WITH_HEAVY_DRIZZLE,

  // Drizzle-related descriptions
  LIGHT_INTENSITY_DRIZZLE,
  DRIZZLE,
  HEAVY_INTENSITY_DRIZZLE,
  LIGHT_INTENSITY_DRIZZLE_RAIN,
  DRIZZLE_RAIN,
  HEAVY_INTENSITY_DRIZZLE_RAIN,
  SHOWER_RAIN_AND_DRIZZLE,
  HEAVY_SHOWER_RAIN_AND_DRIZZLE,
  SHOWER_DRIZZLE,

  // Rain-related descriptions
  LIGHT_RAIN,
  MODERATE_RAIN,
  HEAVY_INTENSITY_RAIN,
  VERY_HEAVY_RAIN,
  EXTREME_RAIN,
  FREEZING_RAIN,
  LIGHT_INTENSITY_SHOWER_RAIN,
  SHOWER_RAIN,
  HEAVY_INTENSITY_SHOWER_RAIN,
  RAGGED_SHOWER_RAIN,

  // Snow-related descriptions
  LIGHT_SNOW,
  SNOW,
  HEAVY_SNOW,
  SLEET,
  LIGHT_SHOWER_SLEET,
  SHOWER_SLEET,
  LIGHT_RAIN_AND_SNOW,
  RAIN_AND_SNOW,
  LIGHT_SHOWER_SNOW,
  SHOWER_SNOW,
  HEAVY_SHOWER_SNOW,

  // Other weather descriptions
  MIST,
  SMOKE,
  HAZE,
  SAND_DUST_WHIRLS,
  FOG,
  SAND,
  DUST,
  VOLCANIC_ASH,
  SQUALLS,
  TORNADO,

  // Clear and clouds descriptions
  CLEAR_SKY,
  FEW_CLOUDS,
  SCATTERED_CLOUDS,
  BROKEN_CLOUDS,
  OVERCAST_CLOUDS
}


final descriptionValues = EnumValues({
  // Thunderstorm descriptions
  "thunderstorm with light rain": Description.THUNDERSTORM_WITH_LIGHT_RAIN,
  "thunderstorm with rain": Description.THUNDERSTORM_WITH_RAIN,
  "thunderstorm with heavy rain": Description.THUNDERSTORM_WITH_HEAVY_RAIN,
  "light thunderstorm": Description.LIGHT_THUNDERSTORM,
  "thunderstorm": Description.THUNDERSTORM,
  "heavy thunderstorm": Description.HEAVY_THUNDERSTORM,
  "ragged thunderstorm": Description.RAGGED_THUNDERSTORM,
  "thunderstorm with light drizzle": Description.THUNDERSTORM_WITH_LIGHT_DRIZZLE,
  "thunderstorm with drizzle": Description.THUNDERSTORM_WITH_DRIZZLE,
  "thunderstorm with heavy drizzle": Description.THUNDERSTORM_WITH_HEAVY_DRIZZLE,

  // Drizzle-related descriptions
  "light intensity drizzle": Description.LIGHT_INTENSITY_DRIZZLE,
  "drizzle": Description.DRIZZLE,
  "heavy intensity drizzle": Description.HEAVY_INTENSITY_DRIZZLE,
  "light intensity drizzle rain": Description.LIGHT_INTENSITY_DRIZZLE_RAIN,
  "drizzle rain": Description.DRIZZLE_RAIN,
  "heavy intensity drizzle rain": Description.HEAVY_INTENSITY_DRIZZLE_RAIN,
  "shower rain and drizzle": Description.SHOWER_RAIN_AND_DRIZZLE,
  "heavy shower rain and drizzle": Description.HEAVY_SHOWER_RAIN_AND_DRIZZLE,
  "shower drizzle": Description.SHOWER_DRIZZLE,

  // Rain-related descriptions
  "light rain": Description.LIGHT_RAIN,
  "moderate rain": Description.MODERATE_RAIN,
  "heavy intensity rain": Description.HEAVY_INTENSITY_RAIN,
  "very heavy rain": Description.VERY_HEAVY_RAIN,
  "extreme rain": Description.EXTREME_RAIN,
  "freezing rain": Description.FREEZING_RAIN,
  "light intensity shower rain": Description.LIGHT_INTENSITY_SHOWER_RAIN,
  "shower rain": Description.SHOWER_RAIN,
  "heavy intensity shower rain": Description.HEAVY_INTENSITY_SHOWER_RAIN,
  "ragged shower rain": Description.RAGGED_SHOWER_RAIN,

  // Snow-related descriptions
  "light snow": Description.LIGHT_SNOW,
  "snow": Description.SNOW,
  "heavy snow": Description.HEAVY_SNOW,
  "sleet": Description.SLEET,
  "light shower sleet": Description.LIGHT_SHOWER_SLEET,
  "shower sleet": Description.SHOWER_SLEET,
  "light rain and snow": Description.LIGHT_RAIN_AND_SNOW,
  "rain and snow": Description.RAIN_AND_SNOW,
  "light shower snow": Description.LIGHT_SHOWER_SNOW,
  "shower snow": Description.SHOWER_SNOW,
  "heavy shower snow": Description.HEAVY_SHOWER_SNOW,

  // Other weather descriptions
  "mist": Description.MIST,
  "smoke": Description.SMOKE,
  "haze": Description.HAZE,
  "sand/dust whirls": Description.SAND_DUST_WHIRLS,
  "fog": Description.FOG,
  "sand": Description.SAND,
  "dust": Description.DUST,
  "volcanic ash": Description.VOLCANIC_ASH,
  "squalls": Description.SQUALLS,
  "tornado": Description.TORNADO,

  // Clear and clouds descriptions
  "clear sky": Description.CLEAR_SKY,
  "few clouds": Description.FEW_CLOUDS,
  "scattered clouds": Description.SCATTERED_CLOUDS,
  "broken clouds": Description.BROKEN_CLOUDS,
  "overcast clouds": Description.OVERCAST_CLOUDS
});


enum MainEnum { CLOUDS, RAIN, THUNDERSTORM, DRIZZLE, SNOW, ATMOSPHERE, CLEAR }

final mainEnumValues = EnumValues({
  "Clouds": MainEnum.CLOUDS,
  "Rain": MainEnum.RAIN,
  "Thunderstorm": MainEnum.THUNDERSTORM,
  "Drizzle": MainEnum.DRIZZLE,
  "Snow": MainEnum.SNOW,
  "Atmosphere": MainEnum.ATMOSPHERE,
  "Clear": MainEnum.CLEAR,
});

class Wind {
  double? speed;
  int? deg;
  double? gust;

  Wind({
    this.speed,
    this.deg,
    this.gust,
  });

  factory Wind.fromRawJson(String str) => Wind.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        speed: json["speed"]?.toDouble(),
        deg: json["deg"],
        gust: json["gust"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "speed": speed,
        "deg": deg,
        "gust": gust,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
