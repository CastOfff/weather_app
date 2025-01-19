import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/secrets.dart';

import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  Future <Map<String, dynamic>> GetCurrentWeather() async {
    try {
      String CityName = 'London';
      final res = await http.get(
          Uri.parse(
              'https://api.openweathermap.org/data/2.5/forecast?q=$CityName&APPID=$openWeatherAPIKey'
          )
      );

      final data = jsonDecode(res.body);
      // data['main']['temp'];
      if (res.statusCode != 200) {
        throw "An unexpected error occurred";
      }

      return data;
    }
    catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {

              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: GetCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final data = snapshot.data!;
          final currentTemp = data['main']['temp'];
          final currentSky = data['weather'][0]['main'];
          final currentPressure = data['main']['pressure'];
          final currentWinSpeed = data['wind']['speed'];
          final currentHumidity = data['main']['humidity'];
          int timestamp = data['dt'];
          DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

          return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO: main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "$currentTemp°K",
                              style: const TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Icon(
                              currentSky == 'Clouds' || currentSky == 'Rain' ? Icons.cloud: Icons.sunny,
                              size: 64,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "$currentSky",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // const Text('Hourly Forecast',
              //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              // ),
              const SizedBox(
                height: 16,
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       for (int i = 0; i < 5; i++)
              //         HourlyForecastItem(
              //           icon: Icons.cloud,
              //           temperature: '321',
              //           time: data['dt'].toString(),
              //           //time: "${time.hour}:00" ,
              //         ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 123,
              //   child: ListView.builder(
              //       itemCount: 1,
              //       scrollDirection: Axis.horizontal,
              //       itemBuilder: (context, index){
              //         final hourlyForecast = "${time.hour}:00";
              //         final hourlySky = data['weather'][0]['main'];
              //         final hourlyTemp = data['main']['temp'];
              //         return HourlyForecastItem(
              //             time: hourlyForecast.toString(),
              //             temperature: hourlyTemp.toString(),
              //             icon: hourlySky == "Clouds" || hourlySky == 'Rain'
              //                 ? Icons.cloud
              //                 : Icons.sunny,
              //         );
              //       }
              //   ),
              // ),

              const SizedBox(
                height: 20,
              ),
              const Text('Additional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value:  currentHumidity.toString() ,
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    label: 'Wind speed',
                    value: currentWinSpeed.toString(),
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
        );
        },
      ),
    );
  }
}



