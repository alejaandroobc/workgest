import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HorarioScreen extends StatefulWidget {
  @override
  _HorarioScreenState createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  List<List<dynamic>> _data = [];
  String? filepath;
  List<Color> _colorPalette = []; // Lista para almacenar los colores

  @override
  void initState() {
    super.initState();
    // Establecer la orientación en horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _generateColorPalette(); // Generar la paleta de colores
    _loadFilepath();
  }

  @override
  void dispose() {
    // Restablecer la orientación al salir de la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _generateColorPalette() {
    // Generar la paleta de colores
    _colorPalette = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.brown,
    ];
  }

  Future<void> _loadFilepath() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot doc = await firestore.collection('settings').doc('csv_filepath').get();
    if (doc.exists) {
      String? savedFilepath = doc['path'];
      if (savedFilepath != null) {
        setState(() {
          filepath = savedFilepath;
        });
        _loadCSV();
      }
    }
  }

  Future<void> _loadCSV() async {
    if (filepath == null) return;

    final input = File(filepath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();

    setState(() {
      _data = fields;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Horario',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _pickFile();
            },
            child: Text('Subir CSV'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                // Determinar el color de fondo basado en el índice
                Color backgroundColor;
                if (index == 0) {
                  // Encabezado
                  backgroundColor = Colors.greenAccent;
                } else {
                  // Cambiar de color cada dos filas
                  backgroundColor = _colorPalette[((index - 1) ~/ 2) % _colorPalette.length];
                }
                return Card(
                  margin: const EdgeInsets.all(3),
                  color: backgroundColor,
                  child: ListTile(
                    title: Row(
                      children: _data[index].map<Widget>((item) {
                        return Expanded(
                          child: Text(
                            item.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: index == 0 ? 18 : 15,
                              fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    final filePath = result.files.first.path;
    if (filePath == null) return;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('settings').doc('csv_filepath').set({
      'path': filePath,
    });

    setState(() {
      filepath = filePath;
    });

    _loadCSV();
  }
}
