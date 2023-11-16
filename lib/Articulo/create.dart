import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appmovilfinal/Articulo/index.dart';
import 'package:appmovilfinal/main.dart';

import '../Models/Autor.dart';

class CreateArticulos extends StatefulWidget {
  @override
  _CreateArticulosState createState() => _CreateArticulosState();
}

class _CreateArticulosState extends State<CreateArticulos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController resumenController = TextEditingController();
  final TextEditingController contenidoController = TextEditingController();
  List<Autor> autores = [];
  List<Autor> selectedAutores = [];

  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    obtenerAutores();
  }

  Future<void> obtenerAutores() async {
    final url = Uri.parse("http://127.0.0.1:5000/obtener_autores");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          autores = (jsonData as List).map((item) {
            return Autor.fromJson(item);
          }).toList();
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void toggleAutorSelection(Autor autor) {
    setState(() {
      if (selectedAutores.contains(autor)) {
        selectedAutores.remove(autor);
      } else {
        selectedAutores.add(autor);
      }
    });
  }

  Future<void> guardarArticulo() async {
    if (_formKey.currentState!.validate()) {
      if (selectedAutores.isEmpty) {
        // Si no se ha seleccionado ningún autor, muestra un AlertDialog y no continúa
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Debes seleccionar al menos un autor.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmar'),
            content: Text('¿Deseas insertar el artículo?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  insertarArticulo();
                },
                child: Text('Sí'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
            ],
          );
        },
      );
    }
  }

  // Método para insertar el artículo
  Future<void> insertarArticulo() async {
    var uri = Uri.http('127.0.0.1:5000', '/crear_articulo');
    final articuloData = {
      "titulo": tituloController.text,
      "resumen": resumenController.text,
      "contenido": contenidoController.text,
      "autores": selectedAutores.map((autor) => autor.idAutor).toList(),
    };

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(articuloData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final mensaje = responseData['mensaje'];
        print(mensaje);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Artículo creado con éxito'),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
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
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: TextFormField(
                  controller: tituloController,
                  maxLength: 45,
                  validator: validateRequired,
                  decoration: InputDecoration(
                    labelText: "Titulo",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: TextFormField(
                  controller: resumenController,
                  maxLength: 95,
                  validator: validateRequired,
                  decoration: InputDecoration(
                    labelText: "Resumen",
                    border: OutlineInputBorder(),
                  ),
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
              SizedBox(
                height: 15,
              ),
              Text('Autores'),
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: autores.length,
                  itemBuilder: (context, index) {
                    final autor = autores[index];
                    return CheckboxListTile(
                      title: Text(autor.nombre),
                      value: selectedAutores.contains(autor),
                      onChanged: (value) {
                        toggleAutorSelection(autor);
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
