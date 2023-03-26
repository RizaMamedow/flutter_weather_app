import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather.dart';

import 'package:weather_app/configs/constants.dart' as constants;


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
              // i don't use "leading" because i don't like spaces between "title" and "leading"
              title: Row(
                children: const [
                  Icon(Icons.location_on_outlined, color: Colors.black,),
                  SizedBox(width: 10),
                  Text("Current Location", style: TextStyle(
                    fontWeight: FontWeight.w600,
                  )),
                ]
              ),
              trailing: const Icon(Icons.keyboard_arrow_right_sharp),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WeatherPage())
                );
              },
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: constants.cities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WeatherPage(city: constants.cities[index]))
                      ),
                    },
                    title: Text(constants.cities[index]),
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