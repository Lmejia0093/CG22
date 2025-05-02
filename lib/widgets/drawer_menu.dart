import 'package:flutter/material.dart';
import 'package:prueba1/screens/nuevo_gasto.dart';  // Importamos la pantalla de Nuevo Gasto1

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Luis David Mejía"),
            accountEmail: Text("luisdavid@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.account_circle, size: 50),
            ),
          ),
          ListTile(
            title: const Text('Inicio'),
            leading: const Icon(Icons.home),
            onTap: () {
              // Lógica para navegar a la pantalla principal
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Nuevo Gasto'),
            leading: const Icon(Icons.add),
            onTap: () {
              // Navegar a la pantalla Nuevo Gasto
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NuevoGasto()),
              );
            },
          ),
          ListTile(
            title: const Text('Ajustes'),
            leading: const Icon(Icons.settings),
            onTap: () {
              // Lógica para navegar a la pantalla de ajustes
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
