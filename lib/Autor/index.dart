// ignore_for_file: unnecessary_null_comparison

import 'package:appmovilfinal/Autor/edit.dart';
import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'create.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:appmovilfinal/Models/Autor.dart';

class IndexAutor extends StatefulWidget {
  @override
  _IndexAutorState createState() => _IndexAutorState();
}

class _IndexAutorState extends State<IndexAutor> {
  List<Autor> autores = [];

  Future<void> getData() async {
    final url = Uri.parse("http://127.0.0.1:5000/obtener_autores");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("JSON obtenido: $jsonData");
        setState(() {
          autores = (jsonData as List).map((item) {
            return Autor(
              nombre: item['nombre'] + ' ' + item['apellido'],
              apellido: item['direccion'],
              direccion: item['direccion'],
              idAutor: item['idAutor'],
            );
          }).toList();
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> confirmarYEliminarArticulo(int idAutor) async {
    bool confirmado = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Está seguro de que desea eliminar este autor?'),
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
      eliminarAutor(idAutor);
    }
  }

  Future<void> eliminarAutor(int idAutor) async {
    final url = Uri.parse("http://127.0.0.1:5000/eliminar_autor/$idAutor");

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
            Text('Listado de Autores'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAutor()),
                );
              },
              child: Text('Crear Autor'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: autores.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      autores[index].nombre,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      autores[index].direccion,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Redirigir a la página de edición del autor y pasar el ID del autor
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditAutor(idAutor: autores[index].idAutor),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.amber,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              final idArticulo = autores[index].idAutor;
                              if (idArticulo != null) {
                                confirmarYEliminarArticulo(idArticulo);
                              }
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
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
