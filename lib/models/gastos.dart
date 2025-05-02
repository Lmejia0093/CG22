class Gasto {
  int? id;
  String categoria;
  String nombre;
  double monto;
  String fecha; // Guardamos como String por simplicidad (YYYY-MM-DD)

  Gasto({
    this.id,
    required this.categoria,
    required this.nombre,
    required this.monto,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoria': categoria,
      'nombre': nombre,
      'monto': monto,
      'fecha': fecha,
    };
  }

  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map['id'],
      categoria: map['categoria'],
      nombre: map['nombre'],
      monto: map['monto'],
      fecha: map['fecha'],
    );
  }
}
