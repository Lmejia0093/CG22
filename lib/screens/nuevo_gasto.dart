import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/gastos.dart';
import '../database/db_helper.dart';

class NuevoGasto extends StatefulWidget {
  const NuevoGasto({super.key});

  @override
  State<NuevoGasto> createState() => _NuevoGastoState();
}

class _NuevoGastoState extends State<NuevoGasto> {
  final _formKey = GlobalKey<FormState>();
  String categoria = '';
  String nombre = '';
  double monto = 0.0;
  String fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final List<String> categoriasDisponibles = [
    'Supermercado',
    'Comida',
    'Transporte',
    'Vivienda',
    'Educación',
    'Ropa',
    'Salud',
    'Servicios',
    'Tecnología',
    'Deudas',
    'Entretenimiento',
    'Viajes',
    'Mascotas',
    'Familia',
    'Otros',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5), // Morado claro
      appBar: AppBar(
        title: const Text("Nuevo Gasto"),
        backgroundColor: const Color(0xFF6A1B9A), // Morado oscuro
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Agregar nuevo gasto",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[800],
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: categoria.isNotEmpty ? categoria : null,
                    decoration: InputDecoration(
                      labelText: "Categoría",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: categoriasDisponibles.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => categoria = value!),
                    validator: (value) => value == null || value.isEmpty ? "Campo obligatorio" : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nombre",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onSaved: (value) => nombre = value!,
                    validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Monto",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => monto = double.tryParse(value!) ?? 0.0,
                    validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text("Guardar",
                      style:TextStyle(
                        color: Colors.white,
                      )),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final nuevo = Gasto(
                            categoria: categoria,
                            nombre: nombre,
                            monto: monto,
                            fecha: fecha,
                          );
                          await DBHelper().insertarGasto(nuevo);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
