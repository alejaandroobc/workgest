import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAdminScreen extends StatefulWidget{
  final User user;

  UserAdminScreen({required this.user});

  @override
  _UserAdminScreenState createState() => _UserAdminScreenState();
}

class _UserAdminScreenState extends State<UserAdminScreen> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name = ${_user.displayName}'),
      ),
      body: Scaffold(

      ),
      bottomNavigationBar: ,


    );
  }
}
