import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Container(
                        color: Colors.blue[600],
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              image: NetworkImage(
                                  "http://openweathermap.org/img/wn/${weatherData[12].weatherIcon}@2x.png"
                              ),
                            ),
                            Text('Today\'s Weather', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8), // Ajustar según sea necesario
                            Text('${weatherData[0].weatherDescription}'),
                            Text('${weatherData[0].windSpeed}')
                          ],
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
                            return ListTile(
                              tileColor: Colors.blueGrey[200],
                              title: Text('${weather.weatherDescription}'),
                              subtitle: Text(
                                  'Date: ${weather.date?.day}/${weather.date?.month}/${weather.date?.year} | Temperature: ${weather.temperature?.celsius}°C'
                              ),
                              trailing: Image(
                                image: NetworkImage(
                                    "http://openweathermap.org/img/wn/${weatherData[index].weatherIcon}@4x.png"
                                ),
                              ),
                            );
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

  Icon _IconWeather( String description){
    if (description.contains('cloud')){
      return Icon(WeatherIcons.cloudy);
    } else if (description.toLowerCase().contains('rain')) {
      return Icon(WeatherIcons.rain);
    } else if (description.toLowerCase().contains('snow')) {
      return Icon(WeatherIcons.snow);
    } else if (description.contains('clear') || description.contains('few clouds')){
      return Icon(Icons.sunny);
    } else {
      return Icon(Icons.error);
    }
  }

}