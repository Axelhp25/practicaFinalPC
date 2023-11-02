import 'package:appmovilfinal/Autor/index.dart';
import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appmovilfinal/Models/Institucion.dart';

class CreateAutor extends StatefulWidget {
  @override
  _CreateAutorState createState() => _CreateAutorState();
}

class _CreateAutorState extends State<CreateAutor> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  int? selectedInstitucionId; // Cambiado a tipo nullable
  bool activo = false;
  // Una lista para almacenar las instituciones disponibles
  List<Institucion> instituciones = [];
  String mensaje = "Conexión: Cargando...";

  @override
  void initState() {
    super.initState();
    obtenerInstituciones();
  }

  Future<void> obtenerInstituciones() async {
    final url = Uri.parse("http://192.168.0.4:5000/obtener_instituciones");

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
    var uri = Uri.http('192.168.0.4:5000', '/crear_autor'); // Construye la URI

    final autorData = {
      "nombre": nombreController.text,
      "apellido": apellidoController.text,
      "direccion": direccionController.text,
      "idInstitucion": selectedInstitucionId,
      "activo": activo,
    };

    final response = await http.post(
      uri, // Utiliza la URI construida
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre'),
            TextFormField(
              controller: nombreController,
            ),
            Text('Apellido'),
            TextFormField(
              controller: apellidoController,
            ),
            Text('Dirección'),
            TextFormField(
              controller: direccionController,
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
                  guardarAutor(); // Llama a la función para guardar el autor
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
