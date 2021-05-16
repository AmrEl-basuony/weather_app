import 'main.dart';
import 'weather.dart';
import 'wind.dart';

class Collection {
  List<Weather> weather;
  Main main;
  Wind wind;
  String name;

  Collection({this.weather, this.main, this.wind, this.name});

  Collection.fromJson(Map<String, dynamic> json) {
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