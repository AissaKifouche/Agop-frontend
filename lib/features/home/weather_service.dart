import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherData {
  final double tempCurrent;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final double rainMm;
  final String uvIndex;
  final int sunriseTs;
  final int sunsetTs;
  final String description;
  final String icon; // mapped to a material icon name
  final List<DayForecast> forecast;

  WeatherData({
    required this.tempCurrent,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.rainMm,
    required this.uvIndex,
    required this.sunriseTs,
    required this.sunsetTs,
    required this.description,
    required this.icon,
    required this.forecast,
  });
}

class DayForecast {
  final String label;
  final double tempMax;
  final double tempMin;
  final int weatherCode;

  DayForecast({
    required this.label,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });
}

class WeatherService {
  static const List<String> _days = ["MON","TUE","WED","THU","FRI","SAT","SUN"];

  static Future<WeatherData> fetchWeather(double lat, double lon) async {
    final uri = Uri.parse(
        "https://api.open-meteo.com/v1/forecast"
            "?latitude=$lat&longitude=$lon"
            "&current=temperature_2m,relative_humidity_2m,precipitation,weather_code,wind_speed_10m,uv_index"
            "&daily=temperature_2m_max,temperature_2m_min,weather_code,sunrise,sunset,uv_index_max"
            "&timezone=auto"
            "&forecast_days=5"
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception("Weather fetch failed");
    final json = jsonDecode(res.body);

    final current = json['current'];
    final daily = json['daily'];

    // Current values
    final double temp = (current['temperature_2m'] as num).toDouble();
    final int humidity = (current['relative_humidity_2m'] as num).toInt();
    final double wind = (current['wind_speed_10m'] as num).toDouble();
    final double rain = (current['precipitation'] as num).toDouble();
    final double uv = (current['uv_index'] as num).toDouble();
    final int code = (current['weather_code'] as num).toInt();

    // Today's min/max from daily[0]
    final double todayMax = (daily['temperature_2m_max'][0] as num).toDouble();
    final double todayMin = (daily['temperature_2m_min'][0] as num).toDouble();

    // Sunrise/sunset (returned as ISO strings like "2024-04-12T06:14")
    final int sunrise = _parseTimeToTs(daily['sunrise'][0] as String);
    final int sunset  = _parseTimeToTs(daily['sunset'][0] as String);

    // UV label
    String uvLabel;
    if (uv < 3) {
      uvLabel = "Low";
    } else if (uv < 6){ uvLabel = "Moderate";}
    else if (uv < 8){ uvLabel = "High";}
    else {uvLabel = "Very High";}

    // Next 4 days forecast (skip index 0 = today)
    final List<DayForecast> forecast = [];
    for (int i = 1; i <= 4; i++) {
      final dt = DateTime.parse((daily['sunrise'][i] as String).split('T')[0]);
      forecast.add(DayForecast(
        label: _days[dt.weekday - 1],
        tempMax: (daily['temperature_2m_max'][i] as num).toDouble(),
        tempMin: (daily['temperature_2m_min'][i] as num).toDouble(),
        weatherCode: (daily['weather_code'][i] as num).toInt(),
      ));
    }

    return WeatherData(
      tempCurrent: temp,
      tempMin: todayMin,
      tempMax: todayMax,
      humidity: humidity,
      windSpeed: wind,
      rainMm: rain,
      uvIndex: uvLabel,
      sunriseTs: sunrise,
      sunsetTs: sunset,
      description: _codeToDescription(code),
      icon: _codeToIcon(code),
      forecast: forecast,
    );
  }

  static int _parseTimeToTs(String isoString) {
    return DateTime.parse(isoString).millisecondsSinceEpoch ~/ 1000;
  }

  static String formatTime(int unixTs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unixTs * 1000);
    return "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
  }

  static String daylightDuration(int sunriseTs, int sunsetTs) {
    final diff = sunsetTs - sunriseTs;
    final h = diff ~/ 3600;
    final m = (diff % 3600) ~/ 60;
    return "${h}h ${m.toString().padLeft(2,'0')}m";
  }

  // Maps WMO weather codes to readable descriptions
  static String _codeToDescription(int code) {
    if (code == 0) return "Clear Sky";
    if (code <= 2) return "Partly Cloudy";
    if (code == 3) return "Overcast";
    if (code <= 49) return "Foggy";
    if (code <= 59) return "Drizzle";
    if (code <= 69) return "Rain";
    if (code <= 79) return "Snow";
    if (code <= 84) return "Rain Showers";
    if (code <= 94) return "Thunderstorm";
    return "Stormy";
  }

  // Maps WMO weather codes to Flutter Icons — use these in your widget
  static String _codeToIcon(int code) {
    if (code == 0) return "sunny";
    if (code <= 2) return "partly_cloudy";
    if (code <= 3) return "cloudy";
    if (code <= 49) return "foggy";
    if (code <= 69) return "rainy";
    if (code <= 79) return "snowing";
    if (code <= 84) return "rainy";
    return "thunderstorm";
  }

  // Use this in your widget to get the right Icon widget
  static IconData getIconData(String icon) {
    switch (icon) {
      case "sunny": return Icons.sunny;
      case "partly_cloudy": return Icons.wb_cloudy;
      case "cloudy": return Icons.cloud;
      case "foggy": return Icons.foggy;
      case "rainy": return Icons.grain;
      case "snowing": return Icons.snowing;
      case "thunderstorm": return Icons.thunderstorm;
      default: return Icons.sunny;
    }
  }

  static IconData forecastIconData(int weatherCode) {
    return getIconData(_codeToIcon(weatherCode));
  }

}