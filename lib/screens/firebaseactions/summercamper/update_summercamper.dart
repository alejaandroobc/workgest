import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workgest/objects/summercamper_item.dart';
import 'package:workgest/screens/firebaseactions/summercamper/delete_summercamper.dart';
import 'package:workgest/screens/firebaseactions/user/delete_user.dart';

class UpdateSummerCamper extends StatefulWidget {
  final SummerCamper summerCamper;
  final QueryDocumentSnapshot snapshot;

  UpdateSummerCamper(this.summerCamper,{required this.snapshot});

  @override
  _UpdateSummerCamperState createState() => _UpdateSummerCamperState();
}
class _UpdateSummerCamperState extends State<UpdateSummerCamper>{

  late final TextEditingController _nameFieldController;
  late final TextEditingController _apellidoFieldController;
  late final TextEditingController _monitorFieldController;
  late int _edad;

  late QueryDocumentSnapshot _snapshot;

  final FocusNode _focusName = FocusNode();
  final FocusNode _focusApellido = FocusNode();
  final FocusNode _focusMonitor = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFieldController = TextEditingController(text: widget.summerCamper.nombre);
    _apellidoFieldController = TextEditingController(text: widget.summerCamper.apellido);
    _monitorFieldController = TextEditingController(text: widget.summerCamper.monitor);
    _edad = widget.summerCamper.edad;
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _apellidoFieldController.dispose();
    _monitorFieldController.dispose();
    _focusName.dispose();
    _focusApellido.dispose();
    _focusMonitor.dispose();
    super.dispose();
  }

  List<int> edades = [6,7,8,9,10,11,12,13,14,15,16,17,18];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _focusName.unfocus();
        _focusApellido.unfocus();
        _focusMonitor.unfocus();
      },
      child: AlertDialog(
        title: Text('Edita el alumno'),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pop(); // Cierra el primer AlertDialog
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return DeleteSummerCamper(snapshot: widget.snapshot);
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
                    "monitor": _monitorFieldController.text,
                    "edad": _edad
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
                controller: _monitorFieldController,
                focusNode: _focusMonitor,
                decoration: InputDecoration(
                  labelText: 'Monitor',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              SizedBox(height: 8),
              DropdownButton<int>(
                value: _edad,
                onChanged: (int? newValue) {
                  setState(() {
                    _edad = newValue!;
                  });
                },
                items: edades.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('${value}'),
                  );
                }).toList(),
                hint: Text('Edad'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}