import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
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

class WeatherModel {
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
    return weatherData;
  }
}


// Other And Decoration Methods

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
