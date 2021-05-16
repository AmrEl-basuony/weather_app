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