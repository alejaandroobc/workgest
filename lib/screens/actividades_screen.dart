import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../error/conection_error.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  static Stream<QuerySnapshot> getStream() => FirebaseFirestore.instance.collection('material').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Actividades',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getStream(),
        builder: (context, material) {
          if (material.hasError) {
            return ConnectionError();
          }

         if(material.hasData){
           Map<String, int> activities = {};
           material.data!.docs.forEach((doc) {
             String nombre = doc['nombre'];
             int disponibilidad = doc['disponibilidad'];
             activities[doc.id] = disponibilidad;  // Utiliza el ID del documento
           });

           return ListView(
             children: activities.entries.map((entry) {
               String docId = entry.key;
               int available = entry.value;
               String name = material.data!.docs.firstWhere((doc) => doc.id == docId)['nombre'];
               String imagePath = 'assets/images/${name.toLowerCase().replaceAll(' ', '')}.png';

               return Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Card(
                   child: Column(
                     children: [
                       Text(
                         name,
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                       ),
                       Text(
                         available > 0 ? 'Disponible: $available' : 'No disponible',
                         style: TextStyle(
                           fontSize: 16,
                           color: available > 0 ? Colors.green : Colors.red,
                         ),
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           IconButton(
                             onPressed: available > 0 ? () => actualizarDisponibilidad(docId, available, -1) : null,
                             icon: Icon(
                               Icons.remove,
                               color: Colors.black,
                               size: 30,
                             ),
                           ),
                           Expanded(
                             child: Image.asset(
                               imagePath,
                               fit: BoxFit.contain,
                               height: 100,
                             ),
                           ),
                           IconButton(
                             onPressed: () => actualizarDisponibilidad(docId, available, 1),
                             icon: Icon(
                               Icons.add,
                               color: Colors.black,
                               size: 30,
                             ),
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
               );
             }).toList(),
           );
         }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void actualizarDisponibilidad(String id, int cantidadInicial, int change) {
    int newAvailability = cantidadInicial + change;
    if (newAvailability >= 0) {
      FirebaseFirestore.instance
          .collection('material')
          .doc(id)
          .update({'disponibilidad': newAvailability});
    }
  }
}
