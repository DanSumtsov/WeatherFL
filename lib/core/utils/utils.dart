import 'package:intl/intl.dart';

import '../../features/domain/model/weather.dart';

class Utils {
  static String formatTimestamp(int? timestamp, String pattern) {
    if (timestamp == null) return '-';
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final DateFormat formatter = DateFormat(pattern);
    return formatter.format(dateTime);
  }

  static String formatTimestampToTime(int? timestamp) {
    if (timestamp == null) return '-';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String formattedTime =
        "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  static Map<String, List<Weather>> splitForecastByDay(
      List<Weather> forecasts) {
    final now = DateTime.now();
    final todayDate = now.year * 10000 + now.month * 100 + now.day;

    List<Weather> todayForecasts = [];
    List<Weather> nextDaysForecasts = [];

    for (var forecast in forecasts) {
      final forecastDate =
          DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000);

      final forecastDay = forecastDate.year * 10000 +
          forecastDate.month * 100 +
          forecastDate.day;

      if (forecastDay == todayDate) {
        todayForecasts.add(forecast);
      } else {
        nextDaysForecasts.add(forecast);
      }
    }
    return {
      'today': todayForecasts,
      'nextDays': nextDaysForecasts,
    };
  }
}
