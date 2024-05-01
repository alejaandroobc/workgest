import 'package:firebase_auth/firebase_auth.dart';
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
        title: Text(
          titulo,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Column(
        children: [
          if(_indexselected == 0)
            Expanded(child: UserInformationScreen(_user)),
          if(_indexselected == 1)
          Expanded(
              child:Home()
          ),
          if(_indexselected == 2)
            Row()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              label: 'User',

            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                label: 'Settings'
            ),
          ],
        currentIndex: _indexselected,
        onTap: _itemElegido,
        selectedLabelStyle: TextStyle(
          fontSize: 20,    // Tamaño de la fuente
          fontWeight: FontWeight.normal,
        ),
      )
    );
  }

  void _itemElegido(int index){
    setState(() {
      _indexselected = index;
      switch(_indexselected){
        case 0:
          titulo= 'User';
          break;
        case 1:
          titulo= 'Home';
          break;
        case 2:
          titulo= 'Settings';
          break;
      }
    });
  }
}

