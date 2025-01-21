import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_fl/core/utils/utils.dart';
import 'package:weather_fl/features/domain/model/weather.dart';
import 'home_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
      theme: ThemeData.dark(),
    );
  }
}

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(homeProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 16),
        child: RefreshIndicator(
            color: Colors.white,
            onRefresh: () async {
              await ref.read(homeProvider.notifier).fetchAll('Sumy');
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainSection(weather.currentWeather),
                  SizedBox(height: 20),
                  Text(
                    '3-hour forecast',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildHourlyForecast(weather.forecast),
                  SizedBox(height: 10),
                  Text(
                    '5-days forecast',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildDailyForecast(),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildMainSection(AsyncValue<Weather?> weather) {
    return Column(children: [
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            Utils.formatTimestamp(weather.value?.dt, 'E dd'),
            style: TextStyle(
                fontSize: 36,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700),
          ),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 24, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Sumy, UA',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              )
            ],
          )
        ]),
        Spacer(),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset('assets/svg/settings.svg',
              width: 32, height: 32),
        )
      ]),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
              flex: 1,
              child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: SvgPicture.asset(
                    _getWeatherIconPath(weather.value?.w[0].id ?? 200),
                    fit: BoxFit.contain,
                  ))),
          Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.value?.main.temp.toString() ?? '-',
                        style: TextStyle(
                          fontSize: 128,
                          height: 1.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Column(children: [
                        Text(
                          '°C',
                          style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ])
                    ],
                  ),
                  Text(
                    'Feels like: ${weather.value?.main.feelsLike ?? '-'} °C',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        color: Colors.white70),
                  )
                ],
              )),
        ],
      ),
      SizedBox(height: 24),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildWeatherInfo(
              Icons.wind_power, '${weather.value?.wind.speed ?? '-'} m/s'),
          _buildWeatherInfo(
              Icons.water_drop, '${weather.value?.main.humidity ?? '-'}%'),
          _buildWeatherInfo(Icons.grain, '0.1mm'),
        ],
      )
    ]);
  }

  String _getWeatherIconPath(int weatherId) {
    String asset = 'assets/svg/sunny.svg';
    if (weatherId == 800) {
      asset = 'assets/svg/sunny.svg';
    } else if (weatherId >= 801 && weatherId <= 804) {
      asset = 'assets/svg/cloudy.svg';
    } else if (weatherId >= 200 && weatherId <= 232) {
      asset = 'assets/svg/snowy.svg';
    } else if (weatherId >= 500 && weatherId <= 531) {
      asset = 'assets/svg/snowy.svg';
    } else if (weatherId >= 600 && weatherId <= 622) {
      asset = 'assets/svg/snowy.svg';
    } else if (weatherId >= 701 && weatherId <= 781) {
      asset = 'assets/svg/cloudy.svg';
    }
    return asset;
  }

  Widget _buildWeatherInfo(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        SizedBox(height: 8),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildHourlyForecast(AsyncValue<Map<String, List<Weather>>> forecast) {
    final list = forecast.value?['today'];
    final empty = list != null && list.isNotEmpty;
    return SizedBox(
      height: 112,
      child: Offstage(
        offstage: !empty,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: forecast.value?['today']?.length ?? 0,
          itemBuilder: (context, index) {
            final weather = list?[index];
            final temp = '${weather?.main.temp} °C';
            final time = Utils.formatTimestampToTime(weather?.dt);
            return _buildForecastCard(weather?.w[0].id ?? 200, temp, time);
          },
        ),
      ),
    );
  }

  Widget _buildForecastCard(int weatherId, String temp, String time) {
    return Container(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(_getWeatherIconPath(weatherId),
              width: 50, height: 50),
          SizedBox(height: 8),
          Text(temp, style: TextStyle(fontSize: 16)),
          Text(time, style: TextStyle(fontSize: 16, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildDailyForecast() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _buildDailyCard(
                'assets/svg/snowy.svg', 'Thu 16', 'Snowy', '-2°C');
          case 1:
            return _buildDailyCard(
                'assets/svg/snowy.svg', 'Fri 17', 'Snowy', '-4°C');
          case 2:
            return _buildDailyCard(
                'assets/svg/sunny.svg', 'Sat 18', 'Sunny', '2°C');
          default:
            return _buildDailyCard(
                'assets/svg/cloudy.svg', 'Sun 19', 'Cloudy', '0°C');
        }
      },
    );
  }

  Widget _buildDailyCard(
      String iconPath, String day, String weather, String temp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(iconPath, width: 50, height: 50),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(day, style: TextStyle(fontSize: 18)),
                  Text(weather,
                      style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ],
          ),
          Text(temp, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
