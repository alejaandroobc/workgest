import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../objects/user_item.dart';
import 'delete_user.dart';

class UpdateMyUser extends StatefulWidget {
  final UserItem userItem;
  final QueryDocumentSnapshot snapshot;
  final int classID;
  final User user;

  UpdateMyUser(this.userItem, this.user, {required this.snapshot, required this.classID});

  @override
  _UpdateMyUserState createState() => _UpdateMyUserState();
}

class _UpdateMyUserState extends State<UpdateMyUser> {
  late final TextEditingController _nameFieldController;
  late final TextEditingController _apellidoFieldController;
  late final TextEditingController _emailFieldController;
  late final TextEditingController _passwordFieldController; // Nuevo controlador para la contraseña
  late RadioOpciones _opcionRol;

  final FocusNode _focusName = FocusNode();
  final FocusNode _focusApellido = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode(); // Nuevo nodo de enfoque para la contraseña

  bool _processing = false;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _nameFieldController = TextEditingController(text: widget.userItem.nombre);
    _apellidoFieldController = TextEditingController(text: widget.userItem.apellido);
    _emailFieldController = TextEditingController(text: widget.userItem.correo);
    _passwordFieldController = TextEditingController(); // Inicializa el controlador de la contraseña

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
    _passwordFieldController.dispose(); // Dispose del controlador de la contraseña
    _focusName.dispose();
    _focusApellido.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose(); // Dispose del nodo de enfoque de la contraseña
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{10,}$');
    return regex.hasMatch(password);
  }

  bool _validateFields() {
    if (_nameFieldController.text.isEmpty ||
        _apellidoFieldController.text.isEmpty ||
        _emailFieldController.text.isEmpty ||
        _passwordFieldController.text.isEmpty) {
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

    if (!_isValidPassword(_passwordFieldController.text)) { // Valida la nueva contraseña
      setState(() {
        _statusMessage = "La contraseña debe tener al menos 10 caracteres, incluyendo mayúsculas, minúsculas y números.";
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

              await widget.user.updateEmail(_emailFieldController.text);

              FirebaseFirestore.instance.runTransaction((transaction) async {
                transaction.update(widget.snapshot.reference, {
                  "nombre": _nameFieldController.text,
                  "apellido": _apellidoFieldController.text,
                  "correo": _emailFieldController.text,
                  "rol": _opcionRol.name
                });
              });

              await widget.user.updatePassword(_passwordFieldController.text);

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
          child: Container(
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
                TextField(
                  controller: _passwordFieldController,
                  focusNode: _focusPassword,
                  obscureText: true, // Oculta la contraseña
                  decoration: InputDecoration(
                    labelText: 'Nueva Contraseña', // Etiqueta para la nueva contraseña
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
