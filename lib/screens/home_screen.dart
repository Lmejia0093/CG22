import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/gastos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Gasto> gastos = [];
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final data = await DBHelper().obtenerGastos();
    final suma = await DBHelper().obtenerTotal();
    setState(() {
      gastos = data;
      total = suma;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control de Gastos:CG22"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: const Color(0xFFEDE7F6),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          await Navigator.pushNamed(context, '/nuevo');
          cargarDatos();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total gastado",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: gastos.isEmpty
                ? const Center(
                    child: Text(
                      "No hay gastos aún",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 80), // 🟣 ESPACIO para el FAB
                    child: ListView.builder(
                      itemCount: gastos.length,
                      itemBuilder: (context, index) {
                        final gasto = gastos[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              title: Text(
                                "${gasto.categoria}: ${gasto.nombre}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              subtitle: Text(
                                "${gasto.fecha} - \$${gasto.monto.toStringAsFixed(2)}",
                                style: const TextStyle(color: Colors.black87),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                        context,
                                        '/editar',
                                        arguments: gasto,
                                      );
                                      cargarDatos();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          title: Row(
                                            children: const [
                                              Icon(Icons.warning_amber_rounded,
                                                  color: Colors.deepPurple),
                                              SizedBox(width: 10),
                                              Text(
                                                "¿Estás seguro?",
                                                style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: const Text(
                                            "Esta acción eliminará el gasto de forma permanente.",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          actionsPadding: const EdgeInsets.only(
                                              right: 10, bottom: 10),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(false),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.deepPurple,
                                              ),
                                              child: const Text("Cancelar"),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.deepPurple,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(true),
                                              child: const Text("Eliminar"),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        await DBHelper().eliminarGasto(gasto.id!);
                                        cargarDatos();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
