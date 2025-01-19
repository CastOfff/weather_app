import 'package:flutter/material.dart';

class HourlyWeatherForecast extends StatelessWidget {
  final IconData icon;
  final String time;
  final num temperature;

  const HourlyWeatherForecast({
    super.key,
    required this.icon,
    required this.time,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(icon, size: 40),
              const SizedBox(
                height: 8,
              ),
              Text('${(temperature - 273.15).toStringAsFixed(0)} ° C',
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}