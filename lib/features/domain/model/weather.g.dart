// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      main: Main.fromJson(json['main'] as Map<String, dynamic>),
      wind: Wind.fromJson(json['wind'] as Map<String, dynamic>),
      w: (json['weather'] as List<dynamic>)
          .map((e) => WInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      dt: (json['dt'] as num).toInt(),
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'main': instance.main,
      'wind': instance.wind,
      'weather': instance.w,
      'dt': instance.dt,
    };

Main _$MainFromJson(Map<String, dynamic> json) => Main(
      temp: (json['temp'] as num).toInt(),
      feelsLike: (json['feels_like'] as num).toInt(),
      humidity: (json['humidity'] as num).toInt(),
    );

Map<String, dynamic> _$MainToJson(Main instance) => <String, dynamic>{
      'temp': instance.temp,
      'feels_like': instance.feelsLike,
      'humidity': instance.humidity,
    };

WInfo _$WInfoFromJson(Map<String, dynamic> json) => WInfo(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$WInfoToJson(WInfo instance) => <String, dynamic>{
      'id': instance.id,
    };

Wind _$WindFromJson(Map<String, dynamic> json) => Wind(
      speed: (json['speed'] as num).toInt(),
    );

Map<String, dynamic> _$WindToJson(Wind instance) => <String, dynamic>{
      'speed': instance.speed,
    };
