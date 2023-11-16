import 'package:appmovilfinal/Articulo/create.dart';
import 'package:appmovilfinal/Articulo/index.dart';
import 'package:appmovilfinal/Autorarticulo/reportes.dart';
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
            'idAutor': item['idAutor'],
            'idArticulo': item['idArticulo'],
            'fecha': item['fecha_articulo'] ?? '',
          };
        }),
      );
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
                    MaterialPageRoute(
                      builder: (context) => CreateArticulos(),
                    ),
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
                    MaterialPageRoute(
                      builder: (context) => ReporteAutorArticulo(),
                    ),
                  );
                },
                child: Text(
                  'Reportes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
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
                childAspectRatio: 1,
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
                      fecha: articulo['fecha'],
                      autor: articulo['autor'] ?? '',
                      resumen: articulo['resumen'] ?? '',
                      idAutor: articulo['idAutor'] ?? 0,
                      idArticulo: articulo['idArticulo'] ?? 0,
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
  final String fecha;
  final int idAutor;
  final int idArticulo;

  ArticuloCard({
    required this.titulo,
    required this.autor,
    required this.resumen,
    required this.fecha,
    required this.idAutor,
    required this.idArticulo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          // Al hacer clic, no realizamos ninguna acción por ahora
        },
        onLongPress: () {
          _mostrarMenuEliminar(context);
        },
        child: SizedBox(
          width: 350,
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
                Text(
                  'Fecha: ${_formatearFecha(fecha)}',
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

  String _formatearFecha(String fecha) {
    try {
      // Intenta parsear la fecha como un DateTime
      DateTime fechaDateTime = DateTime.parse(fecha);

      // Formatea la fecha según el formato deseado
      return DateFormat('dd/MM/yyyy').format(fechaDateTime);
    } catch (e) {
      // Si hay un error al parsear la fecha, simplemente devuelve la cadena original
      return fecha;
    }
  }

  void _mostrarMenuEliminar(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          overlay.localToGlobal(Offset.zero),
          overlay.localToGlobal(overlay.size.bottomRight(Offset.zero)),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: 'eliminar',
          child: Text('Eliminar'),
        ),
      ],
    ).then((value) {
      if (value == 'eliminar') {
        _mostrarAlertaEliminar(context);
      }
    });
  }

  void _mostrarAlertaEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Artículo'),
          content: Text('¿Está seguro de que desea eliminar este artículo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarArticulo(idArticulo); // Pasa el idArticulo al método
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                );
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarArticulo(int idArticulo) async {
    final url =
        Uri.parse("http://127.0.0.1:5000/eliminar_articulo/$idArticulo");

    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final mensaje = responseData['mensaje'];
        print(mensaje);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

class CreateArticulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Artículo'),
      ),
      body: Center(
        child: Text('Pantalla de Creación de Artículos'),
      ),
    );
  }
}
