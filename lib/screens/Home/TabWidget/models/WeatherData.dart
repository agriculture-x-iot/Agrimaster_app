//ここでOpenweathermapから取得したJson形式の現在の天気情報をFlutterで表示できるよう変換してます

class WeatherData {
  final DateTime date;        //日付
  final String name;          //都市名
  final double temp;          //気温
  final String description;  //天気情報(晴天、曇り、雨etc…)
  final String icon;          //天気アイコン

  WeatherData({this.date, this.name, this.temp, this.description, this.icon,});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: new DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: false),
      name: json['name'],
      temp: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}