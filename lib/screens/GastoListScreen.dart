import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// Modelo de Gasto y DBHelper ya están definidos en tu código

class GastoListScreen extends StatefulWidget {
  @override
  _GastoListScreenState createState() => _GastoListScreenState();
}

class _GastoListScreenState extends State<GastoListScreen> {
  // Método para cargar todos los gastos
  Future<List<Gasto>> _getGastos() async {
    return await DBHelper.getAllGastos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Gastos'),
      ),
      body: FutureBuilder<List<Gasto>>(
        future: _getGastos(),  // Llamamos a la función que obtiene todos los gastos
        builder: (context, snapshot) {
          // Verificamos el estado de la consulta
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay gastos registrados.'));
          } else {
            // Si los datos están disponibles, mostramos la lista
            List<Gasto> gastos = snapshot.data!;
            return ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(gastos[index].descripcion),
                  subtitle: Text('Monto: \$${gastos[index].monto}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Aquí puedes agregar la funcionalidad para eliminar un gasto
                      DBHelper.deleteGasto(gastos[index].id!);
                      setState(() {}); // Para refrescar la lista después de eliminar
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
