import 'package:flutter/material.dart';
import 'package:workgest/screens/register.dart';

class Home extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    List _botones = [
      Expanded(
          child: IconButton(
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterScreen())
                );
              },
              icon: Icon(Icons.app_registration)
          )
      ),
      Expanded(
          child: IconButton(
              onPressed: null,
              icon: Icon(Icons.app_registration)
          )
      ),
      Expanded(
          child: IconButton(
              onPressed: null,
              icon: Icon(Icons.app_registration)
          )
      ),
      Expanded(
          child: IconButton(
              onPressed: null,
              icon: Icon(Icons.app_registration)
          )
      ),
      Expanded(
          child: IconButton(
              onPressed: null,
              icon: Icon(Icons.app_registration)
          )
      ),
      Expanded(
          child: IconButton(
              onPressed: null,
              icon: Icon(Icons.app_registration)
          )
      ),
    ];


    return GridView.builder(
        padding: EdgeInsets.all(0),
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
                color: Colors.red,
                elevation: 5,
                child: item,
              ),
            ),
          );
        }
    );
  }
}