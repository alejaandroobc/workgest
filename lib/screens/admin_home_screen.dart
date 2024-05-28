import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:workgest/screens/user_screen.dart';
import 'package:workgest/widgets/home.dart';

class UserAdminScreen extends StatefulWidget{
  final User user;

  UserAdminScreen({required this.user});

  @override
  _UserAdminScreenState createState() => _UserAdminScreenState();
}

class _UserAdminScreenState extends State<UserAdminScreen> {
  late User _user;
  int _indexselected=1;
  String titulo= "Home";


  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: Container(
              padding: EdgeInsets.all(8),
              child: Image.asset('assets/images/logo.png')
          ),
          title: Text(
            titulo,
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
      body: Column(
        children: [
          if(_indexselected == 0)
            Expanded(child: UserInformationScreen(_user)),
          if(_indexselected == 1)
            Expanded(
                child:Home(user: _user,)
            ),
          Container(
            height: MediaQuery.of(context).size.height/10,
            decoration: BoxDecoration(
                color: Colors.blue
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
