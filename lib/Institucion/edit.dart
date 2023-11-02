import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditInstitucion extends StatefulWidget {
  final int idInstitucion;

  EditInstitucion({required this.idInstitucion});

  @override
  _EditInstitucionState createState() => _EditInstitucionState();
}

class _EditInstitucionState extends State<EditInstitucion> {
  final TextEditingController nombreController = TextEditingController();
  bool activa = false;

  @override
  void initState() {
    super.initState();
    obtenerDetallesInstitucion();
  }

  Future<void> obtenerDetallesInstitucion() async {
    final url = Uri.parse(
        "http://192.168.0.4:5000/obtener_institucion/${widget.idInstitucion}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          nombreController.text = jsonData['nombre'] ?? "";
          activa = jsonData['activo'] ?? false;
        });
      } else {
        print(
            "Error al obtener detalles de la institución: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> guardarCambios() async {
    final url = Uri.parse(
        "http://192.168.0.4:5000/actualizar_institucion/${widget.idInstitucion}");

    final institucionData = {
      "nombre": nombreController.text,
      "activo": activa,
    };

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(institucionData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final mensaje = responseData['mensaje'];
      Navigator.pop(context); // Regresar a la página anterior
      print(mensaje);
    } else {
      print(
          "Error al guardar cambios de la institución: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Editar Institución'),
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
            CheckboxListTile(
              title: Text('Activa'),
              value: activa,
              onChanged: (value) {
                setState(() {
                  activa = value!;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  guardarCambios(); // Llama a la función para guardar los cambios de la institución
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
