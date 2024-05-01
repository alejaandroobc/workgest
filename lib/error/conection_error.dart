import 'package:flutter/material.dart';

class ConnectionError extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    return Center(
      child: Icon(Icons.error_outline, color: Colors.red,size: 50,),
    );
  }

}