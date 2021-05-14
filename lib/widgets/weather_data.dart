import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

Future<Position> fetchPos() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Geolocator.openLocationSettings();
    return await fetchPos();
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return await fetchPos();
    }
  }
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low);
}

Future<Album> fetchAlbum() async {
  Position pos = await fetchPos();
  try {
    final response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=${pos.latitude}&lon=${pos.longitude}&appid=779e4b58ea0317e919553d94aae43020');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    }
  } catch (e) {
    return Album.fromJson({
      "weather": [
        {
          "description": " ",
        }
      ],
      "main": {
        "temp": 273.2,
        "temp_min": 273.2,
        "temp_max": 273.2,
        "humidity": 0
      },
      "wind": {"speed": 0.0},
      "name": "Check your internet",
    });
  }
}

class Album {
  List<Weather> weather;
  Main main;
  Wind wind;
  String name;

  Album({this.weather, this.main, this.wind, this.name});

  Album.fromJson(Map<String, dynamic> json) {
    if (json['weather'] != null) {
      weather = new List<Weather>();
      json['weather'].forEach((v) {
        weather.add(new Weather.fromJson(v));
      });
    }
    main = json['main'] != null ? new Main.fromJson(json['main']) : null;
    wind = json['wind'] != null ? new Wind.fromJson(json['wind']) : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.weather != null) {
      data['weather'] = this.weather.map((v) => v.toJson()).toList();
    }
    if (this.main != null) {
      data['main'] = this.main.toJson();
    }
    if (this.wind != null) {
      data['wind'] = this.wind.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}

class Weather {
  String main;
  String description;

  Weather({this.main, this.description});

  Weather.fromJson(Map<String, dynamic> json) {
    main = json['main'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main'] = this.main;
    data['description'] = this.description;
    return data;
  }
}

class Main {
  double temp;
  double tempMin;
  double tempMax;
  int humidity;

  Main({this.temp, this.tempMin, this.tempMax, this.humidity});

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    tempMin = json['temp_min'];
    tempMax = json['temp_max'];
    humidity = json['humidity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp'] = this.temp;
    data['temp_min'] = this.tempMin;
    data['temp_max'] = this.tempMax;
    data['humidity'] = this.humidity;
    return data;
  }
}

class Wind {
  var speed;

  Wind({this.speed});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['speed'] = this.speed;
    return data;
  }
}

class Data extends StatefulWidget {
  final input;
  double fontSize;
  Data(this.input, this.fontSize);

  @override
  _DataState createState() => _DataState(input, fontSize);
}

class _DataState extends State<Data> {
  Future<Album> futureAlbum;
  String _input;
  double _fontSize;
  String _text;

  _DataState(String input, double fontSize);
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    _input = widget.input;
    _fontSize = widget.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_input == "country") {
              _text = snapshot.data.name;
            } else if (_input == "temp") {
              _text = (snapshot.data.main.temp - 273.159).toStringAsFixed(1) +
                  "\u2103";
            } else if (_input == "description") {
              _text = snapshot.data.weather[0].description;
            } else if (_input == "wind") {
              _text = snapshot.data.wind.speed.toString();
            } else if (_input == "humidity") {
              _text = snapshot.data.main.humidity.toString();
            } else if (_input == "icon") {
              _text = snapshot.data.weather[0].main;
            } else if (_input == "minmax") {
              _text = (snapshot.data.main.tempMin - 273.159)
                      .toStringAsFixed(0)
                      .toString() +
                  " / " +
                  (snapshot.data.main.tempMax - 273.159)
                      .toStringAsFixed(0)
                      .toString() +
                  "\u2103";
            }
            return Text(
              _text,
              style: GoogleFonts.lato(
                fontSize: _fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasError) {
            return Text(
              "ERROR",
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
