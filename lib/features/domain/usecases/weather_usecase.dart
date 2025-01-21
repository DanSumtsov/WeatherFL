import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_fl/core/utils/utils.dart';
import 'package:weather_fl/features/domain/model/weather.dart';

import '../../data/repo/weather_repo.dart';

abstract class WeatherUseCase {
  Future<Weather> fetchWeather(String city);

  Future<Map<String, List<Weather>>> fetchForecast(String city);
}

class WeatherUseCaseImpl implements WeatherUseCase {
  final WeatherRepository weatherRepository;

  WeatherUseCaseImpl(this.weatherRepository);

  @override
  Future<Weather> fetchWeather(String city) async {
    return weatherRepository.getWeather(city);
  }

  @override
  Future<Map<String, List<Weather>>> fetchForecast(String city) async {
    final forecast = await weatherRepository.getForecast(city);
    return Utils.splitForecastByDay(forecast.list);
  }
}

final weatherUseCaseProvider = Provider<WeatherUseCase>((ref) {
  final weatherRepository = ref.read(weatherRepositoryProvider);
  return WeatherUseCaseImpl(weatherRepository);
});
