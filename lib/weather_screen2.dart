import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';

import 'additional_info_item.dart';
import 'hourly_forecast_item.dart';


class WeatherScreen2 extends StatefulWidget {
  const WeatherScreen2({super.key});

  @override
  State<WeatherScreen2> createState() => _WeatherScreen2State();
}

class _WeatherScreen2State extends State<WeatherScreen2> {
  late var temp = 0;

  Future<Map<String, dynamic>> getWeatherForecast() async {
    const String apiKey = openWeatherAPIKey;
    String city = 'Hanoi';
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$apiKey'));

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    getWeatherForecast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Weather App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {

              });
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: getWeatherForecast(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data!;

            final currentTemp = data['list'][0]['main']['temp'];
            final currentWeatherSky = data['list'][0]['weather'][0]['main'];
            final currentPressure = data['list'][0]['main']['pressure'];
            final currentWindSpeed = data['list'][0]['wind']['speed'];
            final currentHumidity = data['list'][0]['main']['humidity'];
            final currentMain = data['list'][0]['weather'][0]['main'];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Hanoi', style: TextStyle(fontSize: 24)),
                    const CurrentTimeWidget(),

                    //main card
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${(currentTemp - 273.15).toStringAsFixed(2)} ° C',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                  Icon(
                                    currentMain == 'Clouds'
                                        ? Icons.cloud
                                        : currentMain == 'Rain'
                                        ? Icons.cloudy_snowing
                                        : Icons.sunny,
                                    size: 60,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '$currentWeatherSky',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'Weather forcast',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // const SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       HourlyWeatherForecast(
                    //           icon: Icons.sunny,
                    //           time: '09:00',
                    //           temperature: 310.11),
                    //       HourlyWeatherForecast(
                    //           icon: Icons.cloud,
                    //           time: '12:00',
                    //           temperature: 312.17),
                    //       HourlyWeatherForecast(
                    //           icon: Icons.snowing,
                    //           time: '15:00',
                    //           temperature: 311.51),
                    //       HourlyWeatherForecast(
                    //           icon: Icons.cloudy_snowing,
                    //           time: '18:00',
                    //           temperature: 315.14),
                    //       HourlyWeatherForecast(
                    //           icon: Icons.cloud,
                    //           time: '21:00',
                    //           temperature: 297.35),
                    //       HourlyWeatherForecast(
                    //           icon: Icons.cloud,
                    //           time: '24:00',
                    //           temperature: 295.89)
                    //     ],
                    //   ),
                    // ),

                    SizedBox(
                      height: 130,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data['list'].length,
                          itemBuilder: (context, index) {
                            final forecastWeather = data['list'][index + 1];
                            final forecastTime = forecastWeather['dt_txt'];
                            final forecastTemp = forecastWeather['main']['temp'];
                            final forecastMain = forecastWeather['weather'][0]['main'];
                            final time = DateTime.parse(forecastTime);

                            return HourlyWeatherForecast(
                                icon: forecastMain == 'Clouds'
                                    ? Icons.cloud
                                    : forecastMain == 'Rain'
                                    ? Icons.cloudy_snowing
                                    : Icons.sunny,
                                // time: DateFormat.Hm().format(time) != '00:00' ? DateFormat.Hm().format(time) : '24:00',
                                time: DateFormat.j().format(time),
                                temperature: forecastTemp);
                          }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'Addition information',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AdditionalInfoItem(
                          icon: Icons.water_drop,
                          label: 'Humidity',
                          value: currentHumidity.toString(),
                        ),
                        AdditionalInfoItem(
                          icon: Icons.air,
                          label: 'Wind speed',
                          value: currentWindSpeed.toString(),
                        ),
                        AdditionalInfoItem(
                          icon: Icons.beach_access,
                          label: 'Pressure',
                          value: currentPressure.toString(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class CurrentTimeWidget extends StatefulWidget {
  const CurrentTimeWidget({super.key});

  @override
  _CurrentTimeWidgetState createState() => _CurrentTimeWidgetState();
}

class _CurrentTimeWidgetState extends State<CurrentTimeWidget> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {
              _CurrentTimeWidgetState();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateTime.now().toString().substring(10, 19),
      style: const TextStyle(fontSize: 24),
    );
  }
}



