import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:weather_fl/features/domain/model/weather.dart';

import '../../domain/model/forecast.dart';

part 'weather_api.g.dart';

@RestApi(baseUrl: "https://api.openweathermap.org/data/2.5")
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  static final apiKey = "ee779c92388cae73b5ba265064036809";

  @GET("/weather")
  Future<Weather> getWeather(
      @Query("lon")double lon,
      @Query("lat")double lat,
      @Query("appid") String apiKey,
      @Query("units") String units,
      );

  @GET("/forecast")
  Future<Forecast> getForecast(
      @Query("lon")double lon,
      @Query("lat")double lat,
      @Query("appid") String apiKey,
      @Query("units") String units,
      );
}
