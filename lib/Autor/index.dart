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
    final url = Uri.parse("http://192.168.0.4:5000/obtener_autores");

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

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete))
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
