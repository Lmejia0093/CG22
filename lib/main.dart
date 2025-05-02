import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/nuevo_gasto.dart';
import 'screens/EditarGastoScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos:CG22',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      routes: {
        '/': (_) => const HomeScreen(),
        '/nuevo': (_) => const NuevoGasto(),
        '/editar': (context) => const EditarGastoScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
