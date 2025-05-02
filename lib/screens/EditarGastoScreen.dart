import 'package:flutter/material.dart';
import '../models/gastos.dart';
import '../database/db_helper.dart';

class EditarGastoScreen extends StatefulWidget {
  const EditarGastoScreen({super.key});

  @override
  State<EditarGastoScreen> createState() => _EditarGastoScreenState();
}

class _EditarGastoScreenState extends State<EditarGastoScreen> {
  final _formKey = GlobalKey<FormState>();
  late Gasto gasto;
  late TextEditingController nombreController;
  late TextEditingController categoriaController;
  late TextEditingController montoController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController();
    categoriaController = TextEditingController();
    montoController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gasto = ModalRoute.of(context)!.settings.arguments as Gasto;
    nombreController.text = gasto.nombre;
    categoriaController.text = gasto.categoria;
    montoController.text = gasto.monto.toString();
  }

  String? _validarMonto(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo requerido";
    }
    if (double.tryParse(value) == null) {
      return "Monto inválido";
    }
    return null;
  }

  Future<void> guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      final nuevoGasto = Gasto(
        id: gasto.id,
        nombre: nombreController.text,
        categoria: categoriaController.text,
        monto: double.parse(montoController.text),
        fecha: gasto.fecha,
      );

      try {
        await DBHelper().actualizarGasto(nuevoGasto);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar el gasto: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Gasto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Para que la card no sea más grande de lo necesario
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: "Nombre"),
                    validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: categoriaController,
                    decoration: const InputDecoration(labelText: "Categoría"),
                    validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: montoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Monto"),
                    validator: _validarMonto,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: guardarCambios,
                      child: const Text("Guardar"),
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
