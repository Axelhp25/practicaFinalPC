import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appmovilfinal/Articulo/index.dart';

class EditArticulo extends StatefulWidget {
  final int idArticulo;

  EditArticulo({required this.idArticulo});

  @override
  _EditArticuloState createState() => _EditArticuloState();
}

class _EditArticuloState extends State<EditArticulo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController resumenController = TextEditingController();
  final TextEditingController contenidoController = TextEditingController();
  bool activo = false;

  @override
  void initState() {
    super.initState();
    obtenerDetallesArticulo();
  }

  Future<void> obtenerDetallesArticulo() async {
    final url = Uri.parse(
        "http://127.0.0.1:5000/obtener_articulo/${widget.idArticulo}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        setState(() {
          tituloController.text = jsonData['titulo'] ?? '';
          resumenController.text = jsonData['resumen'] ?? '';
          contenidoController.text = jsonData['contenido'] ?? '';
          activo = jsonData['activo'] ?? false;
        });
      } else {
        print("Error al obtener detalles del artículo: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
          "http://127.0.0.1:5000/actualizar_articulo/${widget.idArticulo}");

      final articuloData = {
        "titulo": tituloController.text,
        "resumen": resumenController.text,
        "contenido": contenidoController.text,
        "activo": activo,
      };
      final response = await http.put(
        url,
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
        print("Error al guardar cambios del artículo: ${response.statusCode}");
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
            Text('Editar Artículo'),
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
                decoration: InputDecoration(
                  labelText: "Titulo",
                  border: OutlineInputBorder(),
                ),
                controller: tituloController,
                maxLength: 45,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Resumen",
                  border: OutlineInputBorder(),
                ),
                controller: resumenController,
                maxLength: 95,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Contenido",
                  border: OutlineInputBorder(),
                ),
                controller: contenidoController,
                maxLength: 195,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
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
                          MaterialStateProperty.all<Color>(Colors.amber)),
                  onPressed: () {
                    guardarCambios();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Guardar'),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.edit)
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
