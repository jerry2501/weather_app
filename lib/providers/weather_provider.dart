import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherProvider{
  Weather _weather;

  final StreamController<Weather> _modelController=StreamController<Weather>();

  Stream<Weather> get modelStream=>_modelController.stream;

  void dispose(){
    _modelController.close();
  }

  Weather get weather{
    return _weather;
  }

  Future getWeatherData(String city) async{
    return http.get("https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=f6c1bf4ca8b24174bfe07d76255c9cb9")
    .then((response){
      var result=jsonDecode(response.body);
      print(jsonDecode(response.body)['main']['temp']);
      _weather=Weather(
        temperature: (result["main"]["temp"]-273),
        main_description: result['weather'][0]['main'],
        city: result['name'],
        country: result['sys']['country'],
        longitude: result['coord']['lon'],
        latitude: result['coord']['lat'],
        feels_like:(result['main']['feels_like']-273),
        max_temp: (result['main']['temp_max']-273),
        min_temp: (result['main']['temp_min']-273),
        pressure: (result['main']['pressure']),
        visibility: (result['visibility']),
        humidity: (result['main']['humidity']),
        sunrise: DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(result['sys']['sunrise']*1000)),
        sunset: DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(result['sys']['sunset']*1000)),
      );
      //notifyListeners();
      _modelController.add(_weather);
    }).catchError((onError){
      throw onError;
    });

  }


}