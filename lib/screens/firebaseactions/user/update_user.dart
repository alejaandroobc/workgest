import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../objects/user_item.dart';
import 'delete_user.dart';

class UpdateUser extends StatefulWidget {
  final UserItem userItem;
  final QueryDocumentSnapshot snapshot;
  final int classID;
  final User user;

  UpdateUser(this.userItem, this.user, {required this.snapshot, required this.classID});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late final TextEditingController _nameFieldController;
  late final TextEditingController _apellidoFieldController;
  late final TextEditingController _emailFieldController;
  late RadioOpciones _opcionRol;

  final FocusNode _focusName = FocusNode();
  final FocusNode _focusApellido = FocusNode();
  final FocusNode _focusEmail = FocusNode();

  bool _processing = false;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _nameFieldController = TextEditingController(text: widget.userItem.nombre);
    _apellidoFieldController = TextEditingController(text: widget.userItem.apellido);
    _emailFieldController = TextEditingController(text: widget.userItem.correo);

    if (widget.userItem.rol == 'Administrador') {
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

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  bool _validateFields() {
    if (_nameFieldController.text.isEmpty ||
        _apellidoFieldController.text.isEmpty ||
        _emailFieldController.text.isEmpty) {
      setState(() {
        _statusMessage = "Todos los campos son obligatorios.";
      });
      return false;
    }

    if (!_isValidEmail(_emailFieldController.text)) {
      setState(() {
        _statusMessage = "El correo electrónico no tiene un formato válido.";
      });
      return false;
    }

    return true;
  }

  Future<bool> _isEmailAlreadyRegistered(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('correo', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double dialogWidth = MediaQuery.of(context).size.width * 0.8;
    double paddingVertical = MediaQuery.of(context).size.width * 0.04;
    double paddingHorizontal = MediaQuery.of(context).size.width * 0.05;
    double fontSize = MediaQuery.of(context).size.width * 0.04;
    double iconSize = screenHeight * 0.04;

    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusApellido.unfocus();
        _focusEmail.unfocus();
      },
      child: AlertDialog(
        title: const Text(
          'Edita el usuario',
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteUser(snapshot: widget.snapshot);
                },
              );
            },
            icon: Icon(
              Icons.delete,
              size: iconSize,
            ),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _processing = true;
                _statusMessage = "";
              });

              if (!_validateFields()) {
                setState(() {
                  _processing = false;
                });
                return;
              }

              bool emailExists = await _isEmailAlreadyRegistered(_emailFieldController.text);

              if (emailExists && _emailFieldController.text != widget.userItem.correo) {
                setState(() {
                  _statusMessage = "El correo electrónico ya está registrado.";
                  _processing = false;
                });
                return;
              }

              FirebaseFirestore.instance.runTransaction((transaction) async {
                transaction.update(widget.snapshot.reference, {
                  "nombre": _nameFieldController.text,
                  "apellido": _apellidoFieldController.text,
                  "correo": _emailFieldController.text,
                  "rol": _opcionRol.name
                });
              });

              await widget.user.updateEmail(_emailFieldController.text);

              setState(() {
                _processing = false;
                _statusMessage = "Usuario actualizado correctamente.";
              });

              Navigator.of(context).pop();
            },
            child: Text(
              'Editar',
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
        content: SingleChildScrollView(
          child: SizedBox(
            width: dialogWidth,
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
                      borderRadius: BorderRadius.circular(screenHeight * 0.025),
                    ),
                  ),
                ),
                SizedBox(height: paddingVertical),
                TextField(
                  controller: _apellidoFieldController,
                  focusNode: _focusApellido,
                  decoration: InputDecoration(
                    labelText: 'Apellidos',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenHeight * 0.025),
                    ),
                  ),
                ),
                SizedBox(height: paddingVertical),
                TextField(
                  controller: _emailFieldController,
                  focusNode: _focusEmail,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenHeight * 0.025),
                    ),
                  ),
                ),
                SizedBox(height: paddingVertical),
                if (widget.classID != 1 && _emailFieldController.text != widget.user.email)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Administrador',
                        style: _opcionRol == RadioOpciones.Administrador
                            ? const TextStyle(color: Colors.green)
                            : const TextStyle(color: Colors.black),
                      ),
                      Radio(
                        value: RadioOpciones.Administrador,
                        groupValue: _opcionRol,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            _opcionRol = RadioOpciones.Administrador;
                          });
                        },
                      ),
                      Text(
                        'Estandard',
                        style: _opcionRol == RadioOpciones.Estandard
                            ? const TextStyle(color: Colors.green)
                            : const TextStyle(color: Colors.black),
                      ),
                      Radio(
                        value: RadioOpciones.Estandard,
                        groupValue: _opcionRol,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            _opcionRol = RadioOpciones.Estandard;
                          });
                        },
                      )
                    ],
                  ),
                SizedBox(height: paddingVertical),
                Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage == "Usuario actualizado correctamente."
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum RadioOpciones {
  Administrador,
  Estandard
}
