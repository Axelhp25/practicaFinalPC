import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ReporteAutorArticulo extends StatefulWidget {
  @override
  _ReporteAutorArticuloState createState() => _ReporteAutorArticuloState();
}

class _ReporteAutorArticuloState extends State<ReporteAutorArticulo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String formattedDate = '';
  String formattedDate2 = '';

  List<Map<String, dynamic>> reporteData = [];
  String mensaje = "Conexión: Cargando...";

  Future<void> obtenerReportes() async {
    final url = Uri.parse(
        "http://127.0.0.1:5000/obtener_reportes?fecha_inicial=$formattedDate&fecha_final=$formattedDate2");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          reporteData = (jsonData as List).cast<Map<String, dynamic>>();
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked2 = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked2 != null) {
      setState(() {
        formattedDate2 = DateFormat('yyyy-MM-dd').format(picked2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: Row(
          children: [
            Text('Reportes'),
            SizedBox(
              width: 20,
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text(
                'Inicio',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                child: Text(
                  "Generación de reportes de articulos por fecha",
                  style: TextStyle(
                      fontSize: 24, color: Color.fromARGB(255, 158, 158, 158)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 182, 123, 77))),
                      onPressed: () {
                        _selectDate(context); // Muestra el selector de fecha
                      },
                      child: Text('Seleccionar Fecha Inicial'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 154, 182, 77))),
                      onPressed: () {
                        _selectDate2(context); // Muestra el selector de fecha
                      },
                      child: Text('Seleccionar Fecha Final'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      formattedDate2,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    // Validar si las fechas están seleccionadas
                    if (formattedDate.isEmpty || formattedDate2.isEmpty) {
                      // Manejar error si las fechas no están seleccionadas
                      return;
                    }

                    obtenerReportes();
                    formattedDate = "";
                    formattedDate2 = "";
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Generar'),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.refresh)
                    ],
                  ),
                ),
              ),
              // ListView para mostrar los datos obtenidos
              Expanded(
                child: reporteData.isEmpty
                    ? Center(
                        child: Text('No se encontraron registros.'),
                      )
                    : ListView.builder(
                        itemCount: reporteData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                                'Titulo: ${reporteData[index]['titulo_articulo']}'),
                            subtitle: Text(
                                'Autor: ${reporteData[index]['nombre_autor']}'),
                            // Puedes agregar más campos según tu estructura de datos
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
