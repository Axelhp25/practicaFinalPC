class Autor {
  int idAutor;
  bool activo;
  String nombre;
  String apellido;
  String direccion;
  int idInstitucion;
  DateTime? modificado;

  Autor({
    this.idAutor = 0,
    this.activo = false,
    required this.nombre,
    required this.apellido,
    required this.direccion,
    this.idInstitucion = 0,
    this.modificado,
  });

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      activo: json['activo'] ?? false,
      apellido: json['apellido'] ?? '',
      direccion: json['direccion'] ?? '',
      idAutor: json['idAutor'] ?? 0,
      idInstitucion: json['idInstitucion'] ?? 0,
      nombre: json['nombre'] ?? '',
    );
  }
}
