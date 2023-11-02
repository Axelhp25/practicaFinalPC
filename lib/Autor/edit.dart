import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appmovilfinal/Models/Institucion.dart';

class EditAutor extends StatefulWidget {
  final int? idAutor;

  EditAutor({this.idAutor});

  @override
  _EditAutorState createState() => _EditAutorState();
}

class _EditAutorState extends State<EditAutor> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  int? selectedInstitucionId;
  List<Institucion> instituciones = [];
  bool activo = false;
  @override
  void initState() {
    super.initState();
    obtenerInstituciones();

    // Si se proporciona un idAutor, carga los datos del autor
    if (widget.idAutor != null) {
      cargarDatosAutor(widget.idAutor!);
    }
  }

  Future<void> obtenerInstituciones() async {
    final url = Uri.parse("http://192.168.0.4:5000/obtener_instituciones");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          instituciones = (jsonData as List).map((item) {
            return Institucion.fromJson(item);
          }).toList();
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> cargarDatosAutor(int idAutor) async {
    final url = Uri.parse("http://192.168.0.4:5000/obtener_autor/$idAutor");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Comprobar si la respuesta contiene la estructura esperada
        if (jsonData.containsKey("nombre") &&
            jsonData.containsKey("apellido") &&
            jsonData.containsKey("direccion") &&
            jsonData.containsKey("idInstitucion")) {
          nombreController.text = jsonData["nombre"];
          apellidoController.text = jsonData["apellido"];
          direccionController.text = jsonData["direccion"];
          selectedInstitucionId = jsonData["idInstitucion"];
          activo = jsonData["activo"];
        } else {}
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> guardarAutor() async {
    var uri =
        Uri.http('192.168.0.4:5000', '/actualizar_autor/${widget.idAutor}');

    final autorData = {
      "nombre": nombreController.text,
      "apellido": apellidoController.text,
      "direccion": direccionController.text,
      "idInstitucion": selectedInstitucionId,
      "activo": activo,
    };

    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(autorData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final mensaje = responseData['mensaje'];
      Navigator.pop(context); // Regresar a la página anterior
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
            Text('Editar Autor'),
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
                  guardarAutor();
                },
                child: Text('Guardar'),
              ),
            ),
            // Muestra mensajes de error o éxito
          ],
        ),
      ),
    );
  }
}
