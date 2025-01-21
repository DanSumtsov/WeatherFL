import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:weather_fl/features/domain/model/forecast.dart';
import 'package:weather_fl/features/domain/model/weather.dart';

import '../api/weather_api.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather(String city);
  Future<Forecast> getForecast(String city);
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApi api;

  WeatherRepositoryImpl(this.api);

  @override
  Future<Weather> getWeather(String city) async {
    try {
      final response = await api.getWeather(
        34.80029000,
        50.92160000,
        WeatherApi.apiKey,
        'metric',
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  @override
  Future<Forecast> getForecast(String city) async {
    try {
      final response = await api.getForecast(
        34.80029000,
        50.92160000,
        WeatherApi.apiKey,
        'metric',
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

}

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final dio = Dio();
  final apiClient = WeatherApi(dio);
  return WeatherRepositoryImpl(apiClient);
});
