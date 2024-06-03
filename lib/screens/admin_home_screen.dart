import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workgest/widgets/home.dart';

class UserAdminScreen extends StatefulWidget {
  final User user;

  UserAdminScreen({required this.user});

  @override
  _UserAdminScreenState createState() => _UserAdminScreenState();
}

class _UserAdminScreenState extends State<UserAdminScreen> {
  late User _user;
  final String _titulo = "Home";

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double iconSize = screenHeight * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Container(
          padding: EdgeInsets.all(screenHeight * 0.01),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text(
          _titulo,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Home(user: _user),
          ),
          Container(
            height: screenHeight /13,
            decoration: const BoxDecoration(color: Colors.blue),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  color: Colors.white,
                  size: iconSize,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
