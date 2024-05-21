import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workgest/objects/user_item.dart';
import 'package:workgest/screens/firebaseactions/user/delete_user.dart';

class UpdateUser extends StatefulWidget {
  final UserItem userItem;
  final QueryDocumentSnapshot snapshot;

  UpdateUser(this.userItem,{required this.snapshot});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}
class _UpdateUserState extends State<UpdateUser>{

  late final TextEditingController _nameFieldController;
  late final TextEditingController _apellidoFieldController;
  late final TextEditingController _emailFieldController;
  late RadioOpciones _opcionRol;

  late QueryDocumentSnapshot _snapshot;

  final FocusNode _focusName = FocusNode();
  final FocusNode _focusApellido = FocusNode();
  final FocusNode _focusEmail = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFieldController = TextEditingController(text: widget.userItem.nombre);
    _apellidoFieldController = TextEditingController(text: widget.userItem.apellido);
    _emailFieldController = TextEditingController(text: widget.userItem.correo);

    if (widget.userItem.rol == 'administrador') {
      _opcionRol = RadioOpciones.Administrador;
    } else {
      _opcionRol = RadioOpciones.Estandard;
    }
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _apellidoFieldController.dispose();
    _emailFieldController.dispose();
    _focusName.dispose();
    _focusApellido.dispose();
    _focusEmail.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _focusName.unfocus();
        _focusApellido.unfocus();
        _focusEmail.unfocus();
      },
      child: AlertDialog(
        title: Text('Edita el usuario'),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pop(); // Cierra el primer AlertDialog
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return DeleteUser(snapshot: widget.snapshot);

                    }
                );
              },
              icon: Icon(
                Icons.delete,
                size: 30,
              )
          ),
          TextButton(
              onPressed: (){
                FirebaseFirestore
                    .instance
                    .runTransaction((transaction) async{

                      transaction.update(widget.snapshot.reference, {
                        "nombre": _nameFieldController.text,
                        "apellido": _apellidoFieldController.text,
                        "correo": _emailFieldController.text,
                        "rol": _opcionRol.name
                      });
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Editar',
                style: TextStyle(
                    fontSize: 20
                ),
              )
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
              )
          ),
        ],
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameFieldController,
                focusNode: _focusName,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _apellidoFieldController,
                focusNode: _focusApellido,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _emailFieldController,
                focusNode: _focusEmail,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Administrador',
                      style: RadioOpciones.Administrador == _opcionRol
                          ?TextStyle(color: Colors.green)
                          :TextStyle(color: Colors.black)
                  ),
                  Radio(
                      value: RadioOpciones.Administrador,
                      groupValue: _opcionRol,
                      activeColor: Colors.green,
                      onChanged: (value){
                        setState(() {
                          _opcionRol = RadioOpciones.Administrador;

                        });
                      }
                  ),
                  Text(
                      'Estandard',
                      style: RadioOpciones.Estandard == _opcionRol
                          ?TextStyle(color: Colors.green)
                          :TextStyle(color: Colors.black)
                  ),
                  Radio(
                      value: RadioOpciones.Estandard,
                      groupValue: _opcionRol,
                      activeColor: Colors.green,
                      onChanged: (value){
                        setState(() {
                          _opcionRol = RadioOpciones.Estandard;
                        });
                      }
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}

enum RadioOpciones{
  Administrador,
  Estandard
}