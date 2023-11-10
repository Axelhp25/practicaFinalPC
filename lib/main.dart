import 'package:appmovilfinal/Articulo/index.dart';
import 'package:appmovilfinal/Autor/index.dart';
import 'package:appmovilfinal/Autorarticulo/create.dart';
import 'package:appmovilfinal/Autorarticulo/edit.dart';
import 'package:appmovilfinal/Institucion/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final url = Uri.parse("http://127.0.0.1:5000/obtener_cards");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Map<String, dynamic>> articulos = List<Map<String, dynamic>>.from(
        jsonData.map((item) {
          return {
            'titulo': item['titulo_articulo'] ?? '',
            'autor': item['nombre_autor'] ?? '',
            'resumen': item['resumen_articulo'] ?? '',
            'idAutor': item['idAutor'], // Agrega el ID del autor
            'idArticulo': item['idArticulo'], // Agrega el ID del artículo
          };
        }),
      );
      print(articulos);
      return articulos;
    } else {
      throw Exception('Error al cargar datos desde la API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndexArticulo()),
                  );
                },
                child: Text(
                  'Articulos',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndexAutor()),
                  );
                },
                child: Text(
                  'Autores',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndexInstitucion()),
                  );
                },
                child: Text(
                  'Instituciones',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAutorArticulo(),
                    ),
                  );
                },
                child: Text(
                  'Asignar Articulos',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAutorArticulo(),
                    ),
                  );
                },
                child: Text(
                  'Reportes por fechas',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.teal[300],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron artículos.'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.88,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final articulo = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ArticuloCard(
                      titulo: articulo['titulo'] ?? '',
                      autor: articulo['autor'] ?? '',
                      resumen: articulo['resumen'] ?? '',
                      idAutor:
                          articulo['idAutor'] ?? 0, // Agrega el ID del autor
                      idArticulo: articulo['idArticulo'] ??
                          0, // Agrega el ID del artículo
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ArticuloCard extends StatelessWidget {
  final String titulo;
  final String autor;
  final String resumen;
  final int idAutor; // Agrega el ID del autor
  final int idArticulo; // Agrega el ID del artículo

  ArticuloCard({
    required this.titulo,
    required this.autor,
    required this.resumen,
    required this.idAutor, // Añade el ID del autor a los parámetros
    required this.idArticulo, // Añade el ID del artículo a los parámetros
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditarAutorArticulo(
                idAutor: idAutor, // Pasa el ID del autor
                idArticulo: idArticulo, // Pasa el ID del artículo
              ),
            ),
          );
        },
        child: SizedBox(
          width: 350, // Ancho original de la tarjeta
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Autor: $autor',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'Resumen: $resumen',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
