class Institucion {
  int idInstitucion;
  String nombre;
  bool activo;

  Institucion({
    this.idInstitucion = 0,
    this.nombre = '',
    this.activo = false,
  });

  factory Institucion.fromJson(Map<String, dynamic> json) {
    return Institucion(
      idInstitucion: json['idInstitucion'] ?? 0,
      nombre: json['nombre'] ?? '',
      activo: json['activo'] ?? false,
    );
  }

  // Aquí puedes agregar métodos para realizar operaciones CRUD en la tabla de instituciones
}
