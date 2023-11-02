import 'package:appmovilfinal/Institucion/index.dart';
import 'package:appmovilfinal/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateInstitucion extends StatefulWidget {
  @override
  _CreateInstitucionState createState() => _CreateInstitucionState();
}

class _CreateInstitucionState extends State<CreateInstitucion> {
  final TextEditingController nombreController = TextEditingController();
  bool activa = false;

  Future<void> guardarInstitucion() async {
    final url = Uri.parse("http://192.168.0.4:5000/crear_institucion");

    final institucionData = {
      "nombre": nombreController.text,
      "activo": activa,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(institucionData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final mensaje = responseData['mensaje'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IndexInstitucion()),
      ); // Regresar a la página anterior
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
            Text('Crear Institución'),
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
              title: Text('Activo'),
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
                  guardarInstitucion();
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
