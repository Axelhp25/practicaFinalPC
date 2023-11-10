import 'package:appmovilfinal/Autor/index.dart';
import 'package:appmovilfinal/Models/Articulo.dart';
import 'package:appmovilfinal/Models/Autor.dart';
import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appmovilfinal/Models/Institucion.dart';
import 'package:intl/intl.dart';

class CreateAutorArticulo extends StatefulWidget {
  @override
  _CreateAutorArticuloState createState() => _CreateAutorArticuloState();
}

class _CreateAutorArticuloState extends State<CreateAutorArticulo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? selectedArticuloId;
  int? selectedAutorId;
  String? validationErrorAutor;
  String? validationErrorArticulo;
  bool activo = false;
  DateTime? selectedDate;
  String formattedDate = '';

  List<Articulo> articulos = [];
  List<Autor> autores = [];
  String mensaje = "Conexión: Cargando...";

  @override
  void initState() {
    super.initState();
    obtenerArticulos();
    obtenerAutores();
  }

  Future<void> obtenerArticulos() async {
    final url = Uri.parse("http://127.0.0.1:5000/obtener_articulos");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          articulos = (jsonData as List).map((item) {
            return Articulo.fromJson(item);
          }).toList();
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
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

  Future<void> guardarAutorArticulo() async {
    var uri = Uri.http('127.0.0.1:5000', '/crear_autorarticulo');

    final autorData = {
      "idAutor": selectedAutorId,
      "idArticulo": selectedArticuloId,
      "fecha": formattedDate,
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(autorData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final mensaje = responseData['mensaje'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      print(mensaje);
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: Row(
          children: [
            Text('Crear'),
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
                padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                child: Text(
                  "Asignar articulo a autor",
                  style: TextStyle(
                      fontSize: 24, color: Color.fromARGB(255, 158, 158, 158)),
                ),
              ),
              Text('Autor'),
              DropdownButton<int>(
                isExpanded: true,
                value: selectedAutorId,
                items: autores.map((autor) {
                  return DropdownMenuItem<int>(
                    value: autor.idAutor,
                    child: Text(autor.nombre),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedAutorId = newValue;
                  });
                },
              ),
              if (validationErrorAutor != null)
                Text(
                  validationErrorAutor!,
                  style: TextStyle(color: Colors.red),
                ),
              Text('Articulo'),
              DropdownButton<int>(
                isExpanded: true,
                value: selectedArticuloId,
                items: articulos.map((articulo) {
                  return DropdownMenuItem<int>(
                    value: articulo.id,
                    child: Text(articulo.titulo),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedArticuloId = newValue;
                  });
                },
              ),
              if (validationErrorArticulo != null)
                Text(
                  validationErrorArticulo!,
                  style: TextStyle(color: Colors.red),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.teal[300])),
                      onPressed: () {
                        _selectDate(context); // Muestra el selector de fecha
                      },
                      child: Text('Seleccionar Fecha'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  onPressed: () {
                    // Validar si los campos obligatorios están seleccionados
                    if (selectedAutorId == null) {
                      setState(() {
                        validationErrorAutor = "Selecciona un autor";
                      });
                    } else {
                      setState(() {
                        validationErrorAutor = null;
                      });
                    }

                    if (selectedArticuloId == null) {
                      setState(() {
                        validationErrorArticulo = "Selecciona un artículo";
                      });
                    } else {
                      setState(() {
                        validationErrorArticulo = null;
                      });
                    }

                    if (selectedAutorId != null && selectedArticuloId != null) {
                      guardarAutorArticulo();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Guardar'),
                      SizedBox(
                        width: 5,
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
