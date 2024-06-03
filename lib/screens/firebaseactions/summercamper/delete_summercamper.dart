import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteSummerCamper extends StatefulWidget {
  final QueryDocumentSnapshot snapshot;

  DeleteSummerCamper({required this.snapshot});

  @override
  _DeleteSummerCamperState createState() => _DeleteSummerCamperState();
}

class _DeleteSummerCamperState extends State<DeleteSummerCamper> {
  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.04;
    double dialogPadding = MediaQuery.of(context).size.width * 0.05;

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: dialogPadding, vertical: dialogPadding),
      title: Text(
        '¿Desea borrar el alumno?',
        style: TextStyle(fontSize: fontSize),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance.collection('estudiantes').doc(widget.snapshot.id).delete().then((_) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alumno borrado correctamente.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al borrar el alumno.'),
                  duration: Duration(seconds: 2),
                ),
              );
            });
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
