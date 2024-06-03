import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workgest/utils/firebase_auth.dart';

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final _nameFieldController = TextEditingController();
  final _apellidoFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  late RadioOpciones _opcionRol = RadioOpciones.Estandard;

  final _focusName = FocusNode();
  final _focusApellido = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _processing = false;
  String _statusMessage = "";

  @override
  void dispose() {
    _nameFieldController.dispose();
    _apellidoFieldController.dispose();
    _emailFieldController.dispose();
    _focusName.dispose();
    _focusApellido.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    super.dispose();
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
    if (_passwordFieldController.text.length < 10 ||
        !_passwordFieldController.text.contains(RegExp(r'[A-Z]')) ||
        !_passwordFieldController.text.contains(RegExp(r'[0-9]'))) {
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

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingVertical = MediaQuery.of(context).size.width * 0.04;
    double padding = MediaQuery.of(context).size.width * 0.05;
    double fontSize = MediaQuery.of(context).size.width * 0.04;

    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusApellido.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Registra un Nuevo Usuario',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _nameFieldController,
                  focusNode: _focusName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenHeight * 0.025),
                    ),
                    hintText: 'Nombre',
                  ),
                ),
                SizedBox(height: paddingVertical),
                TextField(
                  controller: _apellidoFieldController,
                  focusNode: _focusApellido,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenHeight * 0.025),
                    ),
                    hintText: 'Apellido',
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
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenHeight * 0.025),
                    ),
                  ),
                ),
                SizedBox(height: paddingVertical),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Administrador',
                      style: _opcionRol == RadioOpciones.Administrador ? TextStyle(color: Colors.green) : TextStyle(color: Colors.black),
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
                      style: _opcionRol == RadioOpciones.Estandard ? TextStyle(color: Colors.green) : TextStyle(color: Colors.black),
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
                _processing
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
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

                    if (emailExists) {
                      setState(() {
                        _statusMessage = "El correo electrónico ya está registrado.";
                        _processing = false;
                      });
                      return;
                    }

                    User? user = await FireAuth.singUpUsingEmailAndPass(
                      name: _nameFieldController.text,
                      email: _emailFieldController.text,
                      password: _passwordFieldController.text,
                    );

                    if (user != null) {
                      await FirebaseFirestore.instance.collection('usuarios').add({
                        'nombre': _nameFieldController.text,
                        'apellido': _apellidoFieldController.text,
                        'correo': _emailFieldController.text,
                        'rol': _opcionRol.name,
                      });

                      setState(() {
                        _statusMessage = "Usuario registrado correctamente.";
                      });
                    } else {
                      setState(() {
                        _statusMessage = "Error al registrar usuario. Intente nuevamente.";
                      });
                    }

                    setState(() {
                      _processing = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenHeight * 0.025),
                    ),
                  ),
                  child: Text(
                    'Registrar Usuario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                ),
                SizedBox(height: paddingVertical),
                Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage == "Usuario registrado correctamente."
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
