import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workgest/error/conection_error.dart';
import 'package:workgest/objects/user_item.dart';
import 'package:workgest/screens/firebaseactions/user//update_user.dart';

class UserInformationScreen extends StatelessWidget{

  late final User user;

  UserInformationScreen(this.user);

  static Stream<QuerySnapshot> getStream()=>
      FirebaseFirestore
          .instance
          .collection('usuarios')
          .orderBy('rol')
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi usuario',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    body: StreamBuilder(
        stream: getStream(),
        builder: (context, usuarios){
          if(usuarios.hasError){
            return ConnectionError();
          }
          if(usuarios.hasData){
            final data = usuarios.data;
            if(data != null){
              return ListView.builder(
                itemExtent: 500,
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  if(data.docs[index]['correo'] == user.email){
                    String nombre = data.docs[index]['nombre'];
                    String apellido= data.docs[index]['apellido'];
                    String correo = data.docs[index]['correo'];
                    String rol = data.docs[index]['rol'];
                    return Center(
                      heightFactor: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 200,
                                color: Colors.deepPurpleAccent,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            nombre,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            apellido,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Email: '+correo,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Rol: '+rol,
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 0, top: 20, right: 20, bottom: 15),
                                  child: FloatingActionButton(
                                      shape: CircleBorder(),
                                      child: Icon(Icons.edit),
                                      onPressed: (){
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context){
                                              return UpdateUser(
                                                  UserItem(nombre, apellido, correo, rol),
                                                  snapshot:data!.docs[index]
                                              );
                                            }
                                        );
                                      }),
                                )
                              ]
                          )
                        ],
                      ),
                    );
                  }
                },
              );
            }
          }
          return CircularProgressIndicator();
        })
    );
  }
}