import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workgest/utils/firebase_auth.dart';

class UserManage extends StatefulWidget{
  @override
  _UserManageState createState () => _UserManageState();

}

class _UserManageState extends State<UserManage>{

  final _nameFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();


  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _processing = false;



  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Padding(
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
                      hintText: 'Name'
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
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: 'Contraseña'
                  ),
                ),
                SizedBox(height: 8,),
                _processing
                ? CircularProgressIndicator()
                    :Expanded(
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
                          )
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );

  }

}