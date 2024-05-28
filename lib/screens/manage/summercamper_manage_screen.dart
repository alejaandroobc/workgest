import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workgest/objects/summercamper_item.dart';
import 'package:workgest/screens/firebaseactions/summercamper/update_summercamper.dart';
import 'package:workgest/screens/firebaseactions/user/register_user.dart';
import '../../error/conection_error.dart';

class SummerCamperManage extends StatefulWidget{
  @override
  _SummerCamperManageState createState () => _SummerCamperManageState();

}

class _SummerCamperManageState extends State<SummerCamperManage>{

  late Stream<QuerySnapshot> _usuariosStream;
  late Stream<QuerySnapshot> _estudiantesStream;

  String? _selectedMonitor='Todos';

  static Stream<QuerySnapshot> getUsuarios()=>
      FirebaseFirestore
          .instance
          .collection('usuarios')
          .orderBy('rol')
          .snapshots();

  static Stream<QuerySnapshot> getEstudiantes()=>
      FirebaseFirestore
          .instance
          .collection('estudiantes')
          .orderBy('edad')
          .snapshots();

  @override
  void initState() {
    super.initState();
    _usuariosStream = getUsuarios();
    _estudiantesStream = getEstudiantes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Gestión de alumnos',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Filtra por monitor:'),
                      Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _usuariosStream,
                          builder: (context, usuarios){
                            if (usuarios.hasError) {
                              return CircularProgressIndicator();
                            }
                            if (usuarios.connectionState == ConnectionState.waiting) {
                              return Container();
                            }
                            final data = usuarios.data!;
                            List<String> monitores = [];
                            for(int i = 0; i < data.docs.length; i++){
                              if(data.docs[i]['rol'] == 'Estandard'){
                                monitores.add(data.docs[i]['nombre'] + ' ' + data.docs[i]['apellido']);
                              }
                            }
                            monitores.add('Todos');
                            return DropdownButton<String>(
                              value: _selectedMonitor,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMonitor = newValue;
                                });
                              },
                              items: monitores.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getEstudiantes(),
              builder: (context, estudiante) {
                if (estudiante.hasError) {
                  return ConnectionError();
                }
                if (estudiante.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (estudiante.hasData) {
                  final data = estudiante.data!;
                  List<QueryDocumentSnapshot> estudiantes = _selectedMonitor != null && _selectedMonitor != 'Todos'
                      ? data.docs.where((doc) => doc['monitor'] == _selectedMonitor).toList().cast<QueryDocumentSnapshot>()
                      :data.docs.cast<QueryDocumentSnapshot>();
                  return ListView.builder(
                    itemCount: estudiantes.length,
                    itemBuilder: (context, index) {
                      String nombre = data.docs[index]['nombre'];
                      String apellido = data.docs[index]['apellido'];
                      String monitor = data.docs[index]['monitor'];
                      int edad = data.docs[index]['edad'];
                      return ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('$nombre $apellido'),
                        subtitle: Text(monitor),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return UpdateSummerCamper(
                                  SummerCamper(nombre, apellido, edad, monitor),
                                  snapshot: data.docs[index],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        tileColor: _colorTile(index),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserRegistration()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Color _colorTile(int index){
    if(index%2==0){
      return Colors.black12;
    }else{
      return Colors.white;
    }
  }

}