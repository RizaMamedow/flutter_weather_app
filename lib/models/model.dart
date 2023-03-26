import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/configs/constants.dart' as constants;

class Location {
  double? latitude;
  double? longitide;
  String apiKey = constants.apiKey;
  int? status;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitide = position.longitude;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class NetworkData {
  NetworkData(this.url);
  final String url;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      debugPrint(response.statusCode.toString());
    }
  }
}

class WeatherApiModel {
  Future<dynamic> getCurrentLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkData networkHelper = NetworkData('${constants.weatherApiUrl}?lat=${location.latitude}&lon=${location.longitide}&appid=${constants.apiKey}&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getWeatherByCityName(String cityName) async {
    NetworkData networkHelper = NetworkData('${constants.weatherApiUrl}?q=$cityName&appid=${constants.apiKey}&units=metric');
    var weatherData = await networkHelper.getData();
    if (cityName.isEmpty) {
      return Exception("City with name not found");
    } else {
      return weatherData;
    }
  }
}

class WeatherData {
  final int? temperature;
  final String? condition;
  final String? description;
  final int? humidity;
  final String? windSpeed;
  final String? country;
  final String? city;
  final String? iconCode;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.country,
    required this.city,
    required this.iconCode,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherData.fromJson(json) {
    return WeatherData(
      iconCode: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
      country: json['sys']['country'],
      temperature: json['main']['temp'].toInt(),
      city: json['name'],
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toString(),
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000).toUtc(),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000).toUtc(),
    );
  }
  IconData getIcon() {
    switch(iconCode) {
      case "01d": { return FontAwesomeIcons.sun; }
      case "02d": { return FontAwesomeIcons.cloudSun; }
      case "09d": { return FontAwesomeIcons.cloudShowersHeavy; }
      case "10d": { return FontAwesomeIcons.cloudShowersWater; }
      case "11d": { return FontAwesomeIcons.cloudBolt; }
      case "13d": { return FontAwesomeIcons.snowflake; }
      case "50d": { return FontAwesomeIcons.smog; }

      default: { return Icons.cloud; }
    }
  }

  Color getIconColor() {
    switch(iconCode) {
      case "01d": { return Colors.amberAccent; }
      default: { return Colors.grey.shade700; }
    }
  }
}

