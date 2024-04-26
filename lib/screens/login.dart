import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workgest/screens/admin_user_screen.dart';
import '../utils/firebase_auth.dart';

class LoginScreen extends StatefulWidget{

  @override
  _LoginScreenState createState ()=> _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{


  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _processing = false;

  @override
  void dispose() {
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        _focusEmail.unfocus();
        _focusPassword.unfocus();
    },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.supervised_user_circle,
              size: 100,
              color: Colors.blue,
            ),
            Text(
              'Inicio de Sesión',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: TextField(
                controller: _emailFieldController,
                focusNode: _focusEmail,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: 'Email'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: TextField(
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
            ),
            _processing
                ? CircularProgressIndicator()
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4, // Utiliza el 80% del ancho de la pantalla
                    height: MediaQuery.of(context).size.height * 0.05, // Utiliza el 80% del ancho de la pantalla
                    child: ElevatedButton(
                        onPressed: () async {
                          _focusPassword.unfocus();
                          _focusEmail.unfocus();

                          setState(() {
                            _processing=true;
                          });

                          User? user = await FireAuth.singInUsingEmailAndPass(
                              email: _emailFieldController.text,
                              password: _passwordFieldController.text
                          );

                          setState(() {
                            _processing= false;
                          });

                          if(user != null){
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => UserAdminScreen(user: user)
                                )
                            );
                          }

                          },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,

                          ),
                        ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}