import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class DeleteSummerCamper extends StatefulWidget{
  final QueryDocumentSnapshot snapshot;

  DeleteSummerCamper({required this.snapshot});

  @override
  _DeleteSummerCamperState createState() => _DeleteSummerCamperState();
}

class _DeleteSummerCamperState extends State<DeleteSummerCamper>{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('¿Desea borrar el alumno?'),
      actions: [
        TextButton(
          onPressed: (){
            FirebaseFirestore
                .instance
                .collection('estudiantes')
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