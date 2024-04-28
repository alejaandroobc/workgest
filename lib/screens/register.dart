import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget{
  @override
  _RegisterScreenState createState () => _RegisterScreenState();

}

class _RegisterScreenState extends State<RegisterScreen>{

  final _nameFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();


  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _processing = false;

  /*@override
  void dispose() {
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }*/

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

        ),
      ),
    );

  }

}