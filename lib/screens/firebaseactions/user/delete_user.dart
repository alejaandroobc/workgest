import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            try {
              QuerySnapshot adminsSnapshot = await FirebaseFirestore.instance
                  .collection('usuarios')
                  .where('rol', isEqualTo: 'Administrador')
                  .get();

              if (adminsSnapshot.docs.length == 1 &&
                  adminsSnapshot.docs.first.id == widget.snapshot.id) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No se puede borrar. Eres el último administrador.")),
                );
              } else {
                String? rol = widget.snapshot['rol'];

                if (rol == 'Estandard') {
                  await _deleteStudentsByMonitor('${widget.snapshot['nombre']} ${widget.snapshot['apellido']}');
                }

                await FirebaseFirestore.instance.collection('usuarios').doc(widget.snapshot.id).delete();

                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.delete();
                }

                // Cierra el diálogo
                Navigator.of(context).pop();
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Error eliminando el usuario")),
              );
            }
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

  Future<void> _deleteStudentsByMonitor(String monitorName) async {
    QuerySnapshot studentsSnapshot = await FirebaseFirestore.instance
        .collection('estudiantes')
        .where('monitor', isEqualTo: monitorName)
        .get();

    for (QueryDocumentSnapshot studentSnapshot in studentsSnapshot.docs) {
      await studentSnapshot.reference.delete();
    }
  }
}
