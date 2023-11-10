import 'package:appmovilfinal/Autor/index.dart';
import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appmovilfinal/Models/Institucion.dart';
import 'package:intl/intl.dart';

class CreateAutor extends StatefulWidget {
  @override
  _CreateAutorState createState() => _CreateAutorState();
}

class _CreateAutorState extends State<CreateAutor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  int? selectedInstitucionId;
  bool activo = true;
  List<Institucion> instituciones = [];
  String mensaje = "Conexión: Cargando...";

  @override
  void initState() {
    super.initState();
    obtenerInstituciones();
  }

  Future<void> obtenerInstituciones() async {
    final url = Uri.parse("http://127.0.0.1:5000/obtener_instituciones");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Instituciones obtenidas: $jsonData");
        setState(() {
          instituciones = (jsonData as List).map((item) {
            return Institucion.fromJson(item);
          }).toList();
          mensaje = "Conexión exitosa";
        });
      } else {
        print("Error: ${response.statusCode}");
        mensaje = "Error de conexión (${response.statusCode})";
      }
    } catch (e) {
      print("Error: $e");
      mensaje = "Error de conexión";
    }
  }

  Future<void> guardarAutor() async {
    if (_formKey.currentState!.validate()) {
      var uri = Uri.http('127.0.0.1:5000', '/crear_autor');

      final autorData = {
        "nombre": nombreController.text,
        "apellido": apellidoController.text,
        "direccion": direccionController.text,
        "idInstitucion": selectedInstitucionId,
        "activo": activo,
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
          MaterialPageRoute(builder: (context) => IndexAutor()),
        );
        print(mensaje);
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
            Text('Crear Autor'),
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
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
                controller: nombreController,
                maxLength: 40,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Apellido",
                  border: OutlineInputBorder(),
                ),
                controller: apellidoController,
                maxLength: 40,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El apellido es requerido';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Dirección",
                  border: OutlineInputBorder(),
                ),
                controller: direccionController,
                maxLength: 40,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La dirección es requerida';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text('Institución'),
              DropdownButton<int>(
                isExpanded: true,
                value: selectedInstitucionId,
                items: instituciones.map((institucion) {
                  return DropdownMenuItem<int>(
                    value: institucion.idInstitucion,
                    child: Text(institucion.nombre),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedInstitucionId = newValue;
                  });
                },
              ),
              SizedBox(
                height: 15,
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
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  onPressed: () {
                    guardarAutor();
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
