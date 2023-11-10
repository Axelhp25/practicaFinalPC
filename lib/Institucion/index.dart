import 'package:appmovilfinal/Institucion/create.dart';
import 'package:appmovilfinal/Institucion/edit.dart';
import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class IndexInstitucion extends StatefulWidget {
  @override
  _IndexInstitucionState createState() => _IndexInstitucionState();
}

class _IndexInstitucionState extends State<IndexInstitucion> {
  List<Map<String, dynamic>> instituciones = [];

  Future<void> getData() async {
    final url = Uri.parse("http://127.0.0.1:5000/obtener_instituciones");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          instituciones = List<Map<String, dynamic>>.from(jsonData);
          print(instituciones);
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> confirmarYEliminarInstitucion(int idInstitucion) async {
    bool confirmado = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Está seguro de que desea eliminar esta institución?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
    if (confirmado == true) {
      eliminarAutor(idInstitucion);
    }
  }

  Future<void> eliminarAutor(int idInstitucion) async {
    final url =
        Uri.parse("http://127.0.0.1:5000/eliminar_institucion/$idInstitucion");

    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
        getData();
      } else {
        print("Error al eliminar el artículo: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: Row(
          children: [
            Text('Instituciones'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.teal[300])),
              onPressed: () {
                // Navegar a la pantalla de creación de instituciones
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateInstitucion()),
                );
              },
              child: Text('Crear Institución'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: instituciones.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      instituciones[index]["nombre"] ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      instituciones[index]["descripcion"] ?? "",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            final idInstitucion =
                                instituciones[index]["idInstitucion"];
                            print(idInstitucion);
                            if (idInstitucion != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditInstitucion(
                                      idInstitucion: idInstitucion),
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                            onPressed: () {
                              final idArticulo =
                                  instituciones[index]["idInstitucion"];
                              if (idArticulo != null) {
                                confirmarYEliminarInstitucion(idArticulo);
                              }
                            },
                            icon: Icon(Icons.delete)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
