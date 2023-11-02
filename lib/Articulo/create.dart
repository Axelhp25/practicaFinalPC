import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'index.dart';
import 'package:appmovilfinal/Models/Articulo.dart';

class CreateArticulo extends StatefulWidget {
  @override
  _CreateArticuloState createState() => _CreateArticuloState();
}

class _CreateArticuloState extends State<CreateArticulo> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController resumenController = TextEditingController();
  final TextEditingController contenidoController = TextEditingController();
  bool activo = false;

  Future<void> guardarArticulo() async {
    var uri =
        Uri.http('192.168.0.4:5000', '/crear_articulo'); // Construye la URI

    final articuloData = {
      "titulo": tituloController.text,
      "resumen": resumenController.text,
      "contenido": contenidoController.text,
      "activo": activo,
    };

    final response = await http.post(
      uri, // Utiliza la URI construida
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(articuloData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final mensaje = responseData['mensaje'];
      print(mensaje); // Imprime el mensaje del servidor

      // Redireccionar al índice y reemplazar la página actual
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IndexArticulo()),
      );
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Crear Artículo'),
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
            Text('Título'),
            TextFormField(
              controller: tituloController,
            ),
            Text('Resumen'),
            TextFormField(
              controller: resumenController,
            ),
            Text('Contenido'),
            TextFormField(
              controller: contenidoController,
            ),
            CheckboxListTile(
              title: Text('Activo'),
              value: activo,
              onChanged: (value) {
                setState(() {
                  activo = value!;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  guardarArticulo(); // Llama a la función para guardar el artículo
                },
                child: Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
