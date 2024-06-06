import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workgest/viewmodel/user_viewmodel.dart';

class DeleteUser extends StatefulWidget {
  final QueryDocumentSnapshot snapshot;

  DeleteUser({required this.snapshot});

  @override
  _DeleteUserState createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  @override
  Widget build(BuildContext context) {
    double dialogPadding = MediaQuery.of(context).size.width * 0.05;
    double fontSize = MediaQuery.of(context).size.width * 0.04;

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: dialogPadding, vertical: dialogPadding),
      title: Text(
        '¿Desea borrar el usuario?',
        style: TextStyle(fontSize: fontSize),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            UserViewModel.deleteUser(widget.snapshot, context);
          },
          child: Text(
            'Borrar',
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar',
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    );
  }
}
