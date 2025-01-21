import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  final Main main;
  final Wind wind;
  @JsonKey(name: 'weather')
  final List<WInfo> w;
  final int dt;

  Weather(
      {required this.main,
      required this.wind,
      required this.w,
      required this.dt});

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

@JsonSerializable()
class Main {
  final int temp;
  @JsonKey(name: 'feels_like')
  int feelsLike;
  final int humidity;

  Main({required this.temp, required this.feelsLike, required this.humidity});

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);

  Map<String, dynamic> toJson() => _$MainToJson(this);
}

@JsonSerializable()
class WInfo {
  final int id;

  WInfo({required this.id});

  factory WInfo.fromJson(Map<String, dynamic> json) => _$WInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WInfoToJson(this);
}

@JsonSerializable()
class Wind {
  final int speed;

  Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);

  Map<String, dynamic> toJson() => _$WindToJson(this);
}
