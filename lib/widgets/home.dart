import 'package:flutter/material.dart';
import 'package:workgest/screens/user_manage_screen.dart';
import 'package:workgest/screens/weatherscreen.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context){

    List _botones = [
      Expanded(
          child: IconButton(
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserManage())
                );
              },
              icon: Icon(
                Icons.app_registration,
                size: 40,
                color: Colors.white,
              )
          )
      ),
      Expanded(
          child: IconButton(
              onPressed: null,
              icon: Icon(
                Icons.calendar_month_outlined,
                size: 40,
                color: Colors.white,
              )
          )
      ),
      Expanded(
          child: IconButton(
              onPressed: null,
              icon: Icon(
                Icons.list_rounded,
                size: 40,
                color: Colors.white,
              ),

          )
      ),
      Expanded(
          child: IconButton(
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WeatherApp())
                );
              },
              icon: Icon(
                Icons.sunny,
                size: 40,
                color: Colors.white,
              )
          )
      ),
      Expanded(
          child: IconButton(
              onPressed: null,
              icon: Icon(
                Icons.kayaking_rounded,
                size: 40,
                color: Colors.white,
              )
          )
      ),
      Expanded(
          child: IconButton(
              onPressed: null,
              icon: Icon(
                Icons.location_on,
                size: 40,
                color: Colors.white,
              )
          )
      ),
    ];


    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

            childAspectRatio: MediaQuery.of(context).size.height / (MediaQuery.of(context).size.width * 2.4),
            crossAxisCount: 2
        ),
        itemCount: 6,
        itemBuilder: (context, index){
          final item = _botones.elementAt(index);
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Expanded(
              child: Card(
                color: _colorItem!(index),
                elevation: 5,
                child: item,
              ),
            ),
          );
        }
    );
  }

  Color _colorItem(int index){
      switch(index){
        case 0:
          return Colors.red;
        case 1:
          return Colors.green;
        case 2:
          return Colors.orange;
        case 3:
          return Colors.blueAccent;
        case 4:
          return Colors.yellow;
        case 5:
          return Colors.purple;
        default:
          return Colors.white;
      }
  }
}