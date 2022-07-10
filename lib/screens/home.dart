import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather.dart';

import 'package:weather_app/configs/constants.dart' as constants;


List<dynamic> cityList = constants.cities;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.info_outlined, color: Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Created by Mamedov Riza"),
              backgroundColor: Colors.black,
            ));
          },
        ),
        title: const Text('Select City', style: TextStyle( color: Colors.black )),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(
              title: const Text("Current Location", style: TextStyle(
                fontWeight: FontWeight.w600
              )),
              trailing: const Icon(Icons.keyboard_arrow_right_sharp),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CurrentLocationWeatherPage())
                );
              },
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: cityList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WeatherPage(cityName: cityList[index]))
                      ),
                    },
                    title: Text(cityList[index]),
                    trailing: const Icon(Icons.keyboard_arrow_right_sharp),
                  );
                },
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}