import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_fl/features/domain/model/forecast.dart';
import 'package:weather_fl/features/domain/model/weather.dart';
import 'package:weather_fl/features/domain/usecases/weather_usecase.dart';

class HomeViewModel extends StateNotifier<WeatherState> {
  final WeatherUseCase weatherUseCase;

  HomeViewModel(this.weatherUseCase) : super(WeatherState());

  Future<void> fetchAll(String city) async {
    final all = await Future.wait([fetchWeather(city), fetchForecast(city)]);
  }

  Future<void> fetchWeather(String city) async {
    final previousState = state;
    //state = const AsyncValue.loading();
    try {
      final weather = await weatherUseCase.fetchWeather(city);
      await Future.delayed(Duration(seconds: 1));
      state = state.copyWith(currentWeather: AsyncValue.data(weather));
    } catch (e, stackTrace) {
      state = previousState;
      state = state.copyWith(currentWeather: AsyncValue.error(e, stackTrace));
    }
  }

  Future<void> fetchForecast(String city) async {
    final previousState = state;
    //state = const AsyncValue.loading();
    try {
      final forecast = await weatherUseCase.fetchForecast(city);
      await Future.delayed(Duration(seconds: 1));
      state = state.copyWith(forecast: AsyncValue.data(forecast));
    } catch (e, stackTrace) {
      state = previousState;
      state = state.copyWith(forecast: AsyncValue.error(e, stackTrace));
    }
  }
}

final homeProvider = StateNotifierProvider<HomeViewModel, WeatherState>((ref) {
  final weatherUseCase = ref.read(weatherUseCaseProvider);
  return HomeViewModel(weatherUseCase);
});

class WeatherState {
  final AsyncValue<Weather> currentWeather;
  final AsyncValue<Map<String, List<Weather>>> forecast;

  const WeatherState({
    this.currentWeather = const AsyncValue.loading(),
    this.forecast = const AsyncValue.loading(),
  });

  WeatherState copyWith({
    AsyncValue<Weather>? currentWeather,
    AsyncValue<Map<String, List<Weather>>>? forecast,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
    );
  }
}
