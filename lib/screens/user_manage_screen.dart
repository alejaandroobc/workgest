import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workgest/objects/user_item.dart';
import 'package:workgest/screens/firebaseactions/register.dart';
import 'package:workgest/screens/firebaseactions/update_user.dart';

import '../error/conection_error.dart';

class UserManage extends StatefulWidget{
  @override
  _UserManageState createState () => _UserManageState();

}

class _UserManageState extends State<UserManage>{

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
          backgroundColor: Colors.blue,
          title: Text(
            'Gestión de usuarios',
            style: TextStyle(
                color: Colors.white
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('usuarios').orderBy('rol').snapshots(),
                builder: (context, usuarios) {
                  if (usuarios.hasError) {
                    return ConnectionError();
                  }
                  if (usuarios.hasData) {
                    final data = usuarios.data;
                    return ListView.builder(
                      itemCount: usuarios.data!.docs.length,
                      itemBuilder: (context, index) {
                        String nombre = data?.docs[index]['nombre'];
                        String apellido= data?.docs[index]['apellido'];
                        String correo = data?.docs[index]['correo'];
                        String rol = data?.docs[index]['rol'];
                        return ListTile(
                            leading: Icon(Icons.account_circle),
                            title: Text('$nombre $apellido'),
                            subtitle: Text(correo),
                            trailing: IconButton(
                                onPressed: (){
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context){
                                        return UpdateUser(UserItem(nombre, apellido, correo, rol), snapshot: data!.docs[index]);
                                      }
                                  );
                                },
                                icon: Icon(Icons.edit)
                            ),
                            tileColor: _colorTile(index),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: FloatingActionButton(
                        shape: CircleBorder(),
                        child: Icon(Icons.add),
                        onPressed: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => UserRegistration())
                          );
                        }),
                  )
                ]
            )
          ],
        )
    );
  }

  Color _colorTile(int index){
    if(index%2==0){
      return Colors.black12;
    }else{
      return Colors.white;
    }
  }

}