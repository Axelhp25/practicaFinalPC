import 'package:appmovilfinal/Autor/index.dart';
import 'package:appmovilfinal/Institucion/create.dart';
import 'package:flutter/material.dart';
import 'Articulo/index.dart';
import 'Institucion/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> articulos = [
    {
      'titulo': 'Título 1',
      'autor': 'Autor 1',
      'resumen': 'Resumen del artículo 1',
    },
    {
      'titulo': 'Título 2',
      'autor': 'Autor 2',
      'resumen': 'Resumen del artículo 2',
    },
    {
      'titulo': 'Título 3',
      'autor': 'Autor 3',
      'resumen': 'Resumen del artículo 3',
    },
    // Agrega más artículos aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
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
                    const Color.fromARGB(255, 255, 255, 255)),
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
                    const Color.fromARGB(255, 255, 255, 255)),
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
            )
          ],
        ),
        backgroundColor: Colors.teal[300],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bienvenido a la página de inicio',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: articulos.map((articulo) {
                return Container(
                  width: 300,
                  child: ArticuloCard(
                    titulo: articulo['titulo'] ?? '',
                    autor: articulo['autor'] ?? '',
                    resumen: articulo['resumen'] ?? '',
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ArticuloCard extends StatelessWidget {
  final String titulo;
  final String autor;
  final String resumen;

  ArticuloCard({
    required this.titulo,
    required this.autor,
    required this.resumen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
