class Articulo {
  int? id; // Usamos un valor nulo (null) para indicar que es autoincremental
  bool activo;
  String contenido;
  String resumen;
  String titulo;

  Articulo({
    this.id,
    required this.activo,
    required this.contenido,
    required this.resumen,
    required this.titulo,
  });

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      id: json['id'], // Mantenemos el campo "id" en la conversión desde JSON
      activo: json['activo'],
      contenido: json['contenido'],
      resumen: json['resumen'],
      titulo: json['titulo'],
    );
  }
}
