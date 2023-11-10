import 'package:appmovilfinal/Articulo/index.dart';
import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateArticulo extends StatefulWidget {
  @override
  _CreateArticuloState createState() => _CreateArticuloState();
}

class _CreateArticuloState extends State<CreateArticulo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController resumenController = TextEditingController();
  final TextEditingController contenidoController = TextEditingController();
  bool activo = true;

  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  Future<void> guardarArticulo() async {
    if (_formKey.currentState!.validate()) {
      var uri = Uri.http('127.0.0.1:5000', '/crear_articulo');
      final articuloData = {
        "titulo": tituloController.text,
        "resumen": resumenController.text,
        "contenido": contenidoController.text,
        "activo": activo,
      };

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(articuloData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final mensaje = responseData['mensaje'];
        print(mensaje);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IndexArticulo()),
        );
      } else {
        print("Error: ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: tituloController,
                maxLength: 45,
                validator: validateRequired,
                decoration: InputDecoration(
                  labelText: "Titulo",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: resumenController,
                maxLength: 95,
                validator: validateRequired,
                decoration: InputDecoration(
                  labelText: "Resumen",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: contenidoController,
                maxLength: 195,
                maxLines: 2,
                validator: validateRequired,
                decoration: InputDecoration(
                  labelText: "Contenido",
                  border: OutlineInputBorder(),
                ),
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
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () {
                    guardarArticulo();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Guardar'),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.create)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
