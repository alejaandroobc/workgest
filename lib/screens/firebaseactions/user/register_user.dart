import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workgest/utils/firebase_auth.dart';

class UserRegistration extends StatefulWidget{
  @override
  _UserRegistrationState createState () => _UserRegistrationState();

}

class _UserRegistrationState extends State<UserRegistration>{

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
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Register',
            style: TextStyle(
                color: Colors.white
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Registra un Nuevo Usuario',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextField(
                    controller: _nameFieldController,
                    focusNode: _focusName,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: 'Nombre'
                    ),
                  ),
                  SizedBox(height: 8,),
                  TextField(
                    controller: _apellidoFieldController,
                    focusNode: _focusApellido,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: 'Apellido'
                    ),
                  ),
                  SizedBox(height: 8,),
                  TextField(
                    controller: _emailFieldController,
                    focusNode: _focusEmail,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: 'Email'
                    ),
                  ),
                  SizedBox(height: 8,),
                  TextField(
                    controller: _passwordFieldController,
                    focusNode: _focusPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: 'Contraseña'
                    ),
                  ),
                  SizedBox(height: 8,),
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
                  SizedBox(height: 8,),
                  _processing
                      ? CircularProgressIndicator()
                      :Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                        onPressed: () async{
                          setState(() {
                            _processing = true;
                          });
          
                          User? user = await FireAuth.singUpUsingEmailAndPass(
                              name: _nameFieldController.text,
                              email: _emailFieldController.text,
                              password: _passwordFieldController.text
                          );
          
                          FirebaseFirestore
                              .instance
                              .collection('usuarios')
                              .add({
                            'nombre' : _nameFieldController.text,
                            'apellido': _apellidoFieldController.text,
                            'correo': _emailFieldController.text,
                            'rol': _opcionRol.name
                          });
          
                          setState(() {
                            _processing = false;
                          });
          
                          if(user!= null){
                            Text('Usuario registrado correctamente');
                          }
          
                        },
          
                        child: Text(
                          'Registrar Usuario',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        textStyle: TextStyle(color: Colors.white)
                      ),
                    ),
                  )
                ],
              ),
            ),
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