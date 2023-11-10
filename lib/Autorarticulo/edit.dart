import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class EditarAutorArticulo extends StatefulWidget {
  final int idAutor;
  final int idArticulo;

  EditarAutorArticulo({required this.idAutor, required this.idArticulo});

  @override
  _EditarAutorArticuloState createState() => _EditarAutorArticuloState();
}

class _EditarAutorArticuloState extends State<EditarAutorArticulo> {
  String formattedDate = '';
  List<Map<String, dynamic>> articulos = [];
  List<Map<String, dynamic>> autores = [];
  int selectedAutorId = 0;
  int selectedArticuloId = 0;
  String? validationErrorAutor;
  String? validationErrorArticulo;

  TextEditingController fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedAutorId = 0;
    selectedArticuloId = 0;
    obtenerDatosAutorArticulo();
    obtenerArticulos();
    obtenerAutores();
  }

  Future<void> obtenerDatosAutorArticulo() async {
    final url = Uri.parse(
        "http://127.0.0.1:5000/obtener_autorarticulo/${widget.idAutor}/${widget.idArticulo}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Datos de autor-artículo obtenidos: $jsonData");
        setState(() {
          selectedAutorId = jsonData['idAutor'];
          selectedArticuloId = jsonData['idArticulo'];
          fechaController.text = jsonData['fecha'];
          formattedDate = jsonData['fecha'];
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> obtenerArticulos() async {
    final url = Uri.parse("http://127.0.0.1:5000/obtener_articulos");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Artículos obtenidos: $jsonData");
        setState(() {
          articulos = (jsonData as List).cast<Map<String, dynamic>>();
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
        print("Autores obtenidos: $jsonData");
        setState(() {
          autores = (jsonData as List).cast<Map<String, dynamic>>();
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> guardarAutorArticulo() async {
    if (selectedAutorId == 0) {
      setState(() {
        validationErrorAutor = "Selecciona un autor";
      });
    } else {
      setState(() {
        validationErrorAutor = null;
      });
    }

    if (selectedArticuloId == 0) {
      setState(() {
        validationErrorArticulo = "Selecciona un artículo";
      });
    } else {
      setState(() {
        validationErrorArticulo = null;
      });
    }

    if (selectedAutorId != 0 && selectedArticuloId != 0) {
      final url = Uri.parse(
          "http://127.0.0.1:5000/actualizar_autorarticulo/${widget.idAutor}/${widget.idArticulo}");

      final autorArticuloData = {
        "fecha": fechaController.text,
        "idAutor": selectedAutorId,
        "idArticulo": selectedArticuloId,
      };

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(autorArticuloData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final mensaje = responseData['mensaje'];
        Navigator.pop(context,
            mensaje); // Cierra la vista de edición y regresa al detalle
        print(mensaje);
      } else {
        print("Error: ${response.statusCode}");
      }
    }
  }

  Future<void> eliminarAutorArticulo() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Autor-Artículo'),
          content: Text('¿Seguro que deseas eliminar este Autor-Artículo?'),
          actions: <Widget>[
            TextButton(
              focusNode: primaryFocus,
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                final url = Uri.parse(
                    "http://127.0.0.1:5000/eliminar_autorarticulo/${widget.idAutor}/${widget.idArticulo}");

                http.delete(url).then((response) {
                  if (response.statusCode == 200) {
                    final responseData = json.decode(response.body);
                    final mensaje = responseData['mensaje'];
                    Navigator.pop(context, mensaje);
                    print(mensaje);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    print("Error: ${response.statusCode}");
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        fechaController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: Text('Editar Autor Artículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
              child: Text(
                "Editar datos de este artículo",
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 158, 158, 158),
                ),
              ),
            ),
            DropdownButton<int>(
              isExpanded: true,
              value: selectedAutorId,
              items: autores.map((autor) {
                return DropdownMenuItem<int>(
                  value: autor['idAutor'],
                  child: Text(autor[
                      'nombre']), // Reemplaza 'nombre' con el campo correcto
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedAutorId = newValue!;
                });
              },
            ),
            if (validationErrorAutor != null)
              Text(
                validationErrorAutor!,
                style: TextStyle(color: Colors.red),
              ),
            DropdownButton<int>(
              isExpanded: true,
              value: selectedArticuloId,
              items: articulos.map((articulo) {
                return DropdownMenuItem<int>(
                  value: articulo['id'],
                  child: Text(articulo['titulo']),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedArticuloId = newValue!;
                });
              },
            ),
            if (validationErrorArticulo != null)
              Text(
                validationErrorArticulo!,
                style: TextStyle(color: Colors.red),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.green)),
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text('Modificar Fecha'),
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
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.amber)),
              onPressed: () {
                guardarAutorArticulo();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Guardar Cambios'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.edit)
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                eliminarAutorArticulo();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Eliminar'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.delete)
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
