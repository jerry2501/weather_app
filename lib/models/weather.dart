import 'package:flutter/cupertino.dart';

class Weather{
  final double temperature;
  final String main_description;
  final String city;
  final String country;
  final double longitude;
  final double latitude;
  final double feels_like;
  final int visibility;
  final int pressure;
  final int humidity;
  final double min_temp;
  final double max_temp;
  final String sunrise;
  final String sunset;

  Weather({@required this.temperature,
  @required this.main_description,
  @required this.city,
  @required this.country,
  @required this.longitude,
  @required this.latitude,
  @required this.feels_like,
  @required this.visibility,
  @required this.pressure,
  @required this.humidity,
  @required this.min_temp,
  @required this.max_temp,
  @required this.sunrise,
  @required this.sunset});
}