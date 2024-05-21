import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class DeleteUser extends StatefulWidget{
  final QueryDocumentSnapshot snapshot;

  DeleteUser({required this.snapshot});

  @override
  _DeleteUserState createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser>{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('¿Desea borrar el usuario?'),
      actions: [
        TextButton(
          onPressed: (){
            FirebaseFirestore
                .instance
                .collection('usuarios')
                .doc(widget.snapshot.id)
                .delete();
            Navigator.of(context).pop();
          },
          child: Text(
            'Borrar',
            style: TextStyle(
                fontSize: 20
            ),
          ),
        ),
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar',
            style: TextStyle(
                fontSize: 20
            ),
          ),
        ),
      ],
    );
  }

}