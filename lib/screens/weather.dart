import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/models/model.dart';


class DataSection extends StatefulWidget {
  final int? temperature;
  final String? condition;
  final String? description;
  final int? humidity;
  final String? windSpeed;
  final String? country;
  final String? city;
  final String? iconCode;

  const DataSection({
    Key? key,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.country,
    required this.city,
    required this.iconCode,
    required this.windSpeed,
  }) : super(key: key);

  @override
  State<DataSection> createState() => _DataSectionState();
}

class _DataSectionState extends State<DataSection> {
  dynamic iconWidget = Icons.access_time;

  @override
  void initState() {
    super.initState();
  }

  dynamic setIcon() {
    switch(widget.iconCode) {
      case "01d": { return FontAwesomeIcons.sun; }
      case "02d": { return FontAwesomeIcons.cloudSun; }
      case "03d": { return FontAwesomeIcons.cloud; }
      case "04d": { return FontAwesomeIcons.cloud; }
      case "09d": { return FontAwesomeIcons.cloudShowersHeavy; }
      case "10d": { return FontAwesomeIcons.cloudShowersWater; }
      case "11d": { return FontAwesomeIcons.cloudBolt; }
      case "13d": { return FontAwesomeIcons.snowflake; }
      case "50d": { return FontAwesomeIcons.smog; }

      default: { return Icons.cloud; }
    }
  }

  dynamic setIconColor() {
    switch(widget.iconCode) {
      case "01d": { return Colors.amberAccent; }
      case "02d": { return Colors.grey[700]; }
      case "03d": { return Colors.grey[700]; }
      case "04d": { return Colors.grey[700]; }
      case "09d": { return Colors.grey[700]; }
      case "10d": { return Colors.grey[700]; }
      case "11d": { return Colors.grey[700]; }
      case "13d": { return Colors.grey[700]; }
      case "50d": { return Colors.grey[700]; }

      default: { return Colors.grey[700]; }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            FaIcon(
              setIcon(),
              color: setIconColor(),
              size: 90,
            ),
            SizedBox(
              width: 300,
              child: Text(
                "${widget.condition?.capitalize()}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 50,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "${widget.description?.capitalize()}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "${widget.temperature}°",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 35,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text("Humidity: ", style: TextStyle(
                        fontWeight: FontWeight.w400
                      )),
                      trailing: Text("${widget.humidity}%", style: const TextStyle(
                        fontSize: 15,
                      )),
                    ),
                    ListTile(
                      title: const Text("Location: ", style: TextStyle(
                          fontWeight: FontWeight.w400
                      )),
                      trailing: Text("${widget.city}, ${widget.country}", style: const TextStyle(
                        fontSize: 15,
                      )),
                    ),
                    ListTile(
                      title: const Text("Wind Speed: ", style: TextStyle(
                          fontWeight: FontWeight.w400
                      )),
                      trailing: Text("${widget.windSpeed} Km/h", style: const TextStyle(
                        fontSize: 15,
                      )),
                    )
                  ],
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}


class WeatherPage extends StatefulWidget {
  final dynamic cityName;

  const WeatherPage({Key? key, required this.cityName}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool connectionErrors = false;
  bool loadingScreen = true;

  int? temperature;
  String? condition;
  String? description;
  int? humidity;
  String? country;
  String? city;
  String? windSpeed;
  String? iconCode;
  WeatherModel weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  getWeatherData() async {
    try {
      var weatherData = await weatherModel.getWeatherByCityName(widget.cityName);
      setState(() {
        condition = weatherData['weather'][0]['main'];
        description = weatherData['weather'][0]['description'];
        humidity = weatherData['main']['humidity'];
        country = weatherData['sys']['country'];
        city = weatherData['name'];
        iconCode = weatherData['weather'][0]['icon'];
        double temp = weatherData['main']['temp'];
        windSpeed = weatherData['wind']['speed'].toString();
        temperature = temp.toInt();
        loadingScreen = false;
      });
    } on SocketException {
      setState(() { connectionErrors = true; });
    } on HttpException {
      setState(() { connectionErrors = true; });
    } on FormatException {
      setState(() { connectionErrors = true; });
    }
  }

  refresh() {
    setState(() { loadingScreen = true; });
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () { Navigator.pop(context); },
          ),
        ),
        title: Text(widget.cityName, style: const TextStyle( color: Colors.black )),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                refresh();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Weather Refreshed"),
                ));
              },
            ),
          ),
        ],
      ),
      body: !loadingScreen ? DataSection(
        humidity: humidity,
        condition: condition,
        description: description,
        temperature: temperature,
        country: country,
        city: city,
        iconCode: iconCode,
        windSpeed: windSpeed,
      ) : const Center(
        child: Text("Loading...", style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600
        )),
      )
    );
  }
}


class CurrentLocationWeatherPage extends StatefulWidget {
  const CurrentLocationWeatherPage({Key? key}) : super(key: key);

  @override
  State<CurrentLocationWeatherPage> createState() => _CurrentLocationWeatherPageState();
}

class _CurrentLocationWeatherPageState extends State<CurrentLocationWeatherPage> {
  bool connectionErrors = false;
  bool loadingScreen = true;

  int? temperature;
  String? condition;
  String? description;
  int? humidity;
  String? country;
  String? city;
  String? windSpeed;
  String? iconCode;
  WeatherModel weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  getWeatherData() async {
    try {
      var weatherData = await weatherModel.getCurrentLocationWeather();
      setState(() {
        condition = weatherData['weather'][0]['main'];
        description = weatherData['weather'][0]['description'];
        humidity = weatherData['main']['humidity'];
        country = weatherData['sys']['country'];
        city = weatherData['name'];
        iconCode = weatherData['weather'][0]['icon'];
        double temp = weatherData['main']['temp'];
        windSpeed = weatherData['wind']['speed'].toString();
        temperature = temp.toInt();
        loadingScreen = false;
      });
    } on SocketException {
      setState(() { connectionErrors = true; });
    } on HttpException {
      setState(() { connectionErrors = true; });
    } on FormatException {
      setState(() { connectionErrors = true; });
    }
  }

  refresh() {
    setState(() { loadingScreen = true; });
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () { Navigator.pop(context); },
            ),
          ),
          title: const Text("Current Location", style: TextStyle( color: Colors.black )),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: () {
                  refresh();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Weather Refreshed"),
                  ));
                },
              ),
            ),
          ],
        ),
        body: !loadingScreen ? DataSection(
          humidity: humidity,
          condition: condition,
          description: description,
          temperature: temperature,
          country: country,
          city: city,
          iconCode: iconCode,
          windSpeed: windSpeed,
        ) : const Center(
          child: Text("Loading...", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600
          )),
        )
    );
  }
}
