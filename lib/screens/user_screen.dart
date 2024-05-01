import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workgest/error/conection_error.dart';
import 'package:workgest/objects/user_item.dart';

class UserInformationScreen extends StatelessWidget{

  late User user;

  UserInformationScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(
                child: Row(
                  children:
                  [
                    ConnectionError(),
                  ],
                )
            );
          }
          if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
            return Container(
               child:UserData(user)
            );
          }
          return Center(
            child:CircularProgressIndicator(),
          );
        },
    );
  }
}