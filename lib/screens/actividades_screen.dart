import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActivityScreen extends StatefulWidget{
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Actividades',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.remove,
                    color: Colors.black,
                    size: 50,
                  )
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/windsurf.png',
                    height: MediaQuery.of(context).size.height/3,
                    width: MediaQuery.of(context).size.width/3,
                  )
                ],
              ),
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 50,
                  )
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.remove,
                    color: Colors.black,
                    size: 50,
                  )
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/vela.png',
                    height: MediaQuery.of(context).size.height/3,
                    width: MediaQuery.of(context).size.width/3,
                  )
                ],
              ),
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 50,
                  )
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.remove,
                    color: Colors.black,
                    size: 50,
                  )
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/paddlesurf.png',
                    height: MediaQuery.of(context).size.height/3,
                    width: MediaQuery.of(context).size.width/3,
                  )
                ],
              ),
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 50,
                  )
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.remove,
                    color: Colors.black,
                    size: 50,
                  )
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/kayak.png',
                    height: MediaQuery.of(context).size.height/3,
                    width: MediaQuery.of(context).size.width/3,
                  )
                ],
              ),
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 50,
                  )
              )
            ],
          ),
        ],
      ),
    );
  }

}