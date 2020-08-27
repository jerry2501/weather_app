import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/widgets/sun_time_card.dart';
import 'package:weather_app/widgets/temp_card.dart';

class MyHomePage extends StatefulWidget {

  final WeatherProvider bloc;

  MyHomePage({Key key, this.bloc}) : super(key: key);
  static Widget create(BuildContext context){
    return Provider<WeatherProvider>(
      create:(context)=>WeatherProvider(),
      child: Consumer<WeatherProvider>(
        builder: (context,bloc,_)=>MyHomePage(bloc: bloc),
      ),
      dispose: (context,bloc)=>bloc.dispose(),
    );
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading=true;
  String _cityname;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  void getData() {
    final data=widget.bloc.getWeatherData('ahmedabad');
    setState(() {
      _isLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final mediaquery=MediaQuery.of(context);
    return Scaffold(
      body: (_isLoading)?
      Center(
        child: CircularProgressIndicator(),
      )
          :StreamBuilder(
          stream: widget.bloc.modelStream,
          builder:(ctx,snapshot){
            final Weather weather=snapshot.data;
            if(snapshot.hasData){
              return SingleChildScrollView(
                child: Stack(
                    children:[
                      Container(
                        height:mediaquery.size.height,
                        width: double.infinity,
                        color: Colors.indigo,
                      ),
                      _buildPositioned(mediaquery,weather),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: mediaquery.size.height*0.67,
                          width: mediaquery.size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(70),topRight: Radius.circular(70)),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${weather.city},${weather.country}',style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
                                  SizedBox(width: 5,),
                                  Icon(FontAwesomeIcons.building),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.place,color: Colors.red,),
                                  SizedBox(width: 5,),
                                  Text("${weather.longitude},${weather.latitude}",style: TextStyle(fontWeight: FontWeight.bold,),),
                                ],
                              ),
                              SizedBox(height: mediaquery.size.height*0.03,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TempCard(mediaquery: mediaquery,text: 'Feels Like:',color: Colors.blue,body: '${weather.feels_like.toStringAsFixed(1)}\u00B0C'),
                                    TempCard(mediaquery: mediaquery,text: 'Visibility:',color: Colors.grey[800],body: '${weather.visibility}'),
                                    TempCard(mediaquery: mediaquery,text: 'Pressure:',color: Colors.grey[800],body: '${weather.pressure} hPa'),
                                    TempCard(mediaquery: mediaquery,text: 'Humidity:',color: Colors.grey[800],body: '${weather.humidity}%'),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TempCard(mediaquery: mediaquery,text: 'Min Temp:',color: Colors.blue,body: '${weather.min_temp.toStringAsFixed(1)}\u00B0C'),
                                    TempCard(mediaquery: mediaquery,text: 'Max Temp:',color: Colors.blue,body: '${weather.max_temp.toStringAsFixed(1)}\u00B0C',),
                                  ],
                                ),
                              ),
                              SizedBox(height: mediaquery.size.height*0.02,),
                              Container(
                                  width: mediaquery.size.width,
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text('Sunrise and Sunset:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),textAlign: TextAlign.left,)),
                              SizedBox(height:mediaquery.size.height*0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:mediaquery.size.width*0.35,
                                    // height: mediaquery.size.height*0.15,
                                    child: SunTimeCard(mediaquery,'assets/images/sunrise.png','${weather.sunrise} IST'),
                                  ),
                                  Container(
                                    width:mediaquery.size.width*0.35,
                                    // height: mediaquery.size.height*0.15,
                                    child: SunTimeCard(mediaquery,'assets/images/sunset.png','${weather.sunset} IST'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
              );
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }



  Widget _buildPositioned(MediaQueryData mediaquery,Weather snapshot) {
    return Positioned(
      top:mediaquery.size.height*0.07,
      left: mediaquery.size.width*0.05,
      child: Column(
        children: [
          Container(
            width: mediaquery.size.width*0.9,
            height: mediaquery.size.height*0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 5,top:5,left: 10,right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type City here',
                        border: InputBorder.none,
                      ),
                      onChanged: (value){
                        setState(() {
                          _cityname=value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 5,),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: (){
                      widget.bloc.getWeatherData(_cityname).catchError((onError){
                        return showDialog(
                          context:context,
                          builder: (ctx)=>AlertDialog(
                            title: Text('An error Occred!'),
                            content: Text('Please enter correct name!!'),
                            actions: [
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        ); //then will execute after the catch because it returns future
                      });
                    },
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: mediaquery.size.height*0.04,),
          Row(
            children: [
              Container(
                  height: mediaquery.size.height*0.10,
                  width: mediaquery.size.width*0.20,
                  child: Image.asset('assets/images/thermometer.png',fit: BoxFit.cover,)),
              SizedBox(width: mediaquery.size.width*.10,),
              Column(
                children: [
                  Text("${snapshot.temperature.toStringAsFixed(1)}\u00B0C",style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  Text("${snapshot.main_description}",style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


}
