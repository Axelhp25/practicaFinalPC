import 'package:appmovilfinal/Articulo/edit.dart';
import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'create.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class IndexArticulo extends StatefulWidget {
  @override
  _IndexArticuloState createState() => _IndexArticuloState();
}

class _IndexArticuloState extends State<IndexArticulo> {
  List<Map<String, dynamic>> articulos = [];

  Future<void> getData() async {
    final url = Uri.parse("http://192.168.0.4:5000/obtener_articulos");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          articulos = List<Map<String, dynamic>>.from(jsonData);
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
            Text('Articulos'),
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
                  MaterialPageRoute(builder: (context) => CreateArticulo()),
                );
              },
              child: Text('Crear Artículo'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: articulos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      articulos[index]["titulo"] ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      articulos[index]["resumen"] ?? "",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            final idArticulo = articulos[index]["id"];
                            if (idArticulo != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditArticulo(idArticulo: idArticulo),
                                ),
                              );
                            }
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
