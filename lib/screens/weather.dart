import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/extensions.dart';
import 'package:weather_app/models/model.dart';


class WeatherWidget extends StatefulWidget {
  final WeatherData? data;

  const WeatherWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 25),
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Column(
          children: [
            FaIcon(
              widget.data?.getIcon(),
              color: widget.data?.getIconColor(),
              size: 90,
            ),
            SizedBox(
              width: 300,
              child: Text(
                widget.data?.condition ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 50,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "${widget.data?.description?.capitalize()}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "${widget.data?.temperature}°",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 35,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: const Text("Humidity: ", style: TextStyle(
                      fontWeight: FontWeight.w400
                    )),
                    trailing: Text("${widget.data?.humidity}%", style: const TextStyle(
                      fontSize: 15,
                    )),
                  ),
                  ListTile(
                    title: const Text("Location: ", style: TextStyle(
                        fontWeight: FontWeight.w400
                    )),
                    trailing: Text("${widget.data?.city}, ${widget.data?.country}", style: const TextStyle(
                      fontSize: 15,
                    )),
                  ),
                  ListTile(
                    title: const Text("Wind Speed: ", style: TextStyle(
                        fontWeight: FontWeight.w400
                    )),
                    trailing: Text("${widget.data?.windSpeed} Km/h", style: const TextStyle(
                      fontSize: 15,
                    )),
                  ),
                  ListTile(
                    title: const Text("Sunrise: ", style: TextStyle(
                        fontWeight: FontWeight.w400
                    )),
                    trailing: Text(
                      DateFormat("HH:mm").format(widget.data!.sunrise ?? DateTime.now()),
                      style: const TextStyle(
                        fontSize: 15,
                      )
                    ),
                  ),
                  ListTile(
                    title: const Text("Sunset: ", style: TextStyle(
                        fontWeight: FontWeight.w400
                    )),
                    trailing: Text(
                      DateFormat("HH:mm").format(widget.data!.sunset ?? DateTime.now()),
                      style: const TextStyle(
                        fontSize: 15,
                      )
                    ),
                  ),
                ],
              ),
            )
          ]
        ),
      ],
    );
  }
}


class WeatherPage extends StatefulWidget {
  final String? city;
  const WeatherPage({Key? key, this.city}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool connectionErrors = false;
  bool loadingScreen = true;
  WeatherApiModel weatherModel = WeatherApiModel();
  WeatherData? details;

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  getWeatherData() async {
    try {
      dynamic weatherData;
      if (widget.city == null) {
        weatherData = await weatherModel.getCurrentLocationWeather();
      } else {
        weatherData = await weatherModel.getWeatherByCityName(widget.city ?? '');
      }
      setState(() {
        loadingScreen = false;
        details = WeatherData.fromJson(weatherData);
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
          title: Text(widget.city ?? "Current Location", style: TextStyle( color: Colors.black )),
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
                    content: Text("Just second"),
                  ));
                },
              ),
            ),
          ],
        ),
        body: !loadingScreen ? WeatherWidget(data: details) : const Center(
          child: Text("Loading...", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600
          )),
        )
    );
  }
}
