import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../error/conection_error.dart';

class ActivityScreen extends StatefulWidget {
  late final User user;

  ActivityScreen(this.user);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  static Stream<QuerySnapshot> getStream() => FirebaseFirestore.instance.collection('material').snapshots();

  late String userRol = '';

  @override
  void initState() {
    super.initState();
    getStream().listen((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc['correo'] == widget.user.email) {
          setState(() {
            userRol = doc['rol'];
          });
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingSize = screenWidth * 0.02; // 2% of screen width
    double fontSizeLarge = screenHeight * 0.025; // 2.5% of screen height
    double fontSizeMedium = screenHeight * 0.02; // 2% of screen height
    double iconSize = screenHeight * 0.04; // 4% of screen height
    double imageHeight = screenHeight * 0.15; // 15% of screen height

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Actividades',
          style: TextStyle(color: Colors.white, fontSize: fontSizeLarge),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getStream(),
        builder: (context, material) {
          if (material.hasError) {
            return ConnectionError();
          }

          if (material.hasData) {
            Map<String, int> activities = {};
            for (var doc in material.data!.docs) {
              int disponibilidad = doc['disponibilidad'];
              activities[doc.id] = disponibilidad;
            }

            return ListView(
              children: activities.entries.map((entry) {
                String docId = entry.key;
                int available = entry.value;
                String name = material.data!.docs.firstWhere((doc) => doc.id == docId)['nombre'];
                String imagePath = 'assets/images/${name.toLowerCase().replaceAll(' ', '')}.png';

                return Padding(
                  padding: EdgeInsets.all(paddingSize),
                  child: Card(
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: fontSizeLarge, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          available > 0 ? 'Disponible: $available' : 'No disponible',
                          style: TextStyle(
                            fontSize: fontSizeMedium,
                            color: available > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            userRol != 'Administrador'
                                ? IconButton(
                              onPressed: available > 0 ? () => actualizarDisponibilidad(docId, available, -1) : null,
                              icon: Icon(
                                Icons.remove,
                                color: Colors.black,
                                size: iconSize,
                              ),
                            )
                                : const SizedBox(),
                            Expanded(
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                                height: imageHeight,
                              ),
                            ),
                            userRol != 'Administrador'
                                ? IconButton(
                              onPressed: () => actualizarDisponibilidad(docId, available, 1),
                              icon: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: iconSize,
                              ),
                            )
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void actualizarDisponibilidad(String id, int cantidadInicial, int change) {
    int newAvailability = cantidadInicial + change;
    if (newAvailability >= 0) {
      FirebaseFirestore.instance.collection('material').doc(id).update({'disponibilidad': newAvailability});
    }
  }
}
