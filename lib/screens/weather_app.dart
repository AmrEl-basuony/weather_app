import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/widgets/single_weather.dart';

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => this.build(context)));
          },
          icon: Icon(
            Icons.refresh_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              "assets/sunny.jpg",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black38,
              ),
            ),
            SingleWeather(),
          ],
        ),
      ),
    );
  }
}
