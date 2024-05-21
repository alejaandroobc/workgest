import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }


class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  WeatherFactory wf = WeatherFactory("2fde5dc70e99b88cae3a442e661f90a9");

  @override
  Widget build(BuildContext context) {
    Future<List<Weather>> getDatos() async {
      return await wf.fiveDayForecastByCityName("Santa Pola");
    }

    return FutureBuilder(
      future: getDatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Weather> weatherData = snapshot.data!;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: Text(
                    'Weather',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blueAccent[100]
                          ),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${weatherData[0].temperature?.celsius?.toInt()}ºC',
                                          style: TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        ),
                                        Icon(
                                          Icons.thermostat,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${(weatherData[0].windSpeed!*3.6).toInt()}km/h',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:25
                                          ),
                                        ),
                                        Icon(
                                          _windIconDirection(weatherData[0].windDegree),
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        Icon(
                                          WeatherIcons.windy,
                                          color: Colors.white,
                                          size: 25,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Image(
                                  image: NetworkImage(
                                      "http://openweathermap.org/img/wn/${weatherData[0].weatherIcon}@4x.png"
                                  ),
                                ),
                              ],),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: 8,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(0.2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10), // Puedes ajustar el radio como desees
                                          border: Border.all(
                                              color: Colors.black,
                                              width: 0.5
                                          ),
                                        ),
                                        width: MediaQuery.of(context).size.width/4,
                                        height: MediaQuery.of(context).size.height/5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: NetworkImage(
                                                  "http://openweathermap.org/img/wn/${weatherData[index].weatherIcon}@2x.png"
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${weatherData[index].temperature?.celsius?.toInt()}º',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:12
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.thermostat,
                                                  color: Colors.white,
                                                  size: 12,
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${(weatherData[index].windSpeed!*3.6).toInt()}km/h',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:12
                                                  ),
                                                ),
                                                Icon(
                                                  _windIconDirection(weatherData[index].windDegree),
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                                Icon(
                                                  WeatherIcons.windy,
                                                  color: Colors.white,
                                                  size: 12,
                                                )
                                              ],
                                            ),
                                            Text(
                                              '${weatherData[index].date?.hour}:${weatherData[index].date?.minute}${weatherData[index].date?.minute}',
                                              style: TextStyle(
                                                color: Colors.white
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: weatherData.length,
                        itemBuilder: (context, index) {
                          Weather weather = weatherData[index];
                          if(index==0){
                            return SizedBox(height: 0);
                          }else{
                            if(index%7==0){
                              return ListTile(
                                tileColor: Colors.lightBlue[300],
                                title: Text(
                                  '${weather.date?.day}/${weather.date?.month}/${weather.date?.year}',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      '${weatherData[index].temperature?.celsius?.toInt()}º',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:15
                                      ),
                                    ),
                                    Icon(
                                      Icons.thermostat,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Text(
                                      '${(weatherData[index].windSpeed!*3.6).toInt()}km/h',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:15
                                      ),
                                    ),
                                    Icon(
                                      _windIconDirection(weatherData[index].windDegree),
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Icon(
                                      WeatherIcons.windy,
                                      color: Colors.white,
                                      size: 15,
                                    )
                                  ],
                                ),
                                trailing: Image(
                                  image: NetworkImage(
                                      "http://openweathermap.org/img/wn/${weatherData[index].weatherIcon}@4x.png"
                                  ),
                                ),
                              );
                            }else{
                              return SizedBox(height:0);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
        }
      },
    );
  }

  IconData? _windIconDirection(grado){
    if(grado >= 22.5 && grado < 45){
      return WeatherIcons.wind_deg_45;
    }else if(grado >= 45 && grado < 67.5){
      return WeatherIcons.wind_deg_45;
    }else if(grado >= 67.5 && grado < 90){
      return WeatherIcons.wind_deg_90;
    }else if(grado >= 90 && grado < 112.5){
      return WeatherIcons.wind_deg_90;
    }else if(grado >= 112.5 && grado < 135){
      return WeatherIcons.wind_deg_135;
    }else if(grado >= 135 && grado < 157.5){
      return WeatherIcons.wind_deg_135;
    }else if(grado >= 157.5 && grado < 180){
      return WeatherIcons.wind_deg_180;
    }else if(grado >= 180 && grado < 202.5){
      return WeatherIcons.wind_deg_180;
    }else if(grado >= 202.5 && grado < 225){
      return WeatherIcons.wind_deg_225;
    }else if(grado >= 225 && grado < 237.5){
      return WeatherIcons.wind_deg_225;
    }else if(grado >= 237.5 && grado < 270){
      return WeatherIcons.wind_deg_270;
    }else if(grado >= 270 && grado < 292.5){
      return WeatherIcons.wind_deg_270;
    }else if(grado >= 292.5 && grado < 315){
      return WeatherIcons.wind_deg_315;
    }else if(grado >= 315 && grado < 337.5){
      return WeatherIcons.wind_deg_315;
    }else{
      return WeatherIcons.wind_deg_0;
    }
  }
}