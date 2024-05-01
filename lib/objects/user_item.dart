import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workgest/error/conection_error.dart';
import 'package:workgest/screens/login.dart';
class UserItem extends StatelessWidget{

  final String nombre;
  final String apellido;
  final String correo;
  final String rol;
  final QueryDocumentSnapshot _snapshot;

   UserItem(this._snapshot):
        nombre = _snapshot.get('nombre') as String,
        apellido = _snapshot.get('apellido') as String,
        correo = _snapshot.get('correo') as String,
        rol = _snapshot.get('rol') as String;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text('$nombre $apellido'),
      subtitle: Text('$correo'),
    );
  }
}

class UserData extends StatelessWidget{

  late User user;

  UserData(this.user);

  static Stream<QuerySnapshot> getStream()=>
    FirebaseFirestore
        .instance
        .collection('usuarios')
        .orderBy('rol')
        .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getStream(),
        builder: (context, usuarios){
          if(usuarios.hasError){
            return ConnectionError();
          }
          if(usuarios.hasData){
            final data = usuarios.data;
            if(data != null){
              return ListView.builder(
                itemExtent: 150,
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  if(data.docs[index]['correo'] == user.email){
                    return UserItem(data.docs[index]);
                  }
                },
              );
            }
          }
          return CircularProgressIndicator();
        }
    );
  }
}