import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        children: const [
          Center(
            child: Text("Connection Error", style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 40,
            )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text("Please check your internet connection", style: TextStyle(
              color: Colors.black,
              fontSize: 17
            )),
          )
        ],
      ),
    );
  }
}
