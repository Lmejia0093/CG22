import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/gastos.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    return _db ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'gastos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE gastos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            categoria TEXT,
            nombre TEXT,
            monto REAL,
            fecha TEXT
          )
        ''');
        // Añadir un índice para mejorar las búsquedas
        await db.execute('CREATE INDEX idx_categoria ON gastos(categoria)');
        await db.execute('CREATE INDEX idx_fecha ON gastos(fecha)');
      },
    );
  }

  Future<int> insertarGasto(Gasto gasto) async {
    final database = await db;
    try {
      return await database.insert('gastos', gasto.toMap());
    } catch (e) {
      print("Error al insertar gasto: $e");
      return 0;
    }
  }

  Future<List<Gasto>> obtenerGastos() async {
    final database = await db;
    try {
      final List<Map<String, dynamic>> maps = await database.query('gastos');
      return maps.map((e) => Gasto.fromMap(e)).toList();
    } catch (e) {
      print("Error al obtener los gastos: $e");
      return [];
    }
  }

  Future<double> obtenerTotal() async {
    final database = await db;
    try {
      final result = await database.rawQuery("SELECT SUM(monto) as total FROM gastos");
      return result.first['total'] != null ? result.first['total'] as double : 0.0;
    } catch (e) {
      print("Error al obtener el total: $e");
      return 0.0;
    }
  }

  Future<int> eliminarGasto(int id) async {
    final database = await db;
    try {
      return await database.delete('gastos', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error al eliminar el gasto: $e");
      return 0;
    }
  }

  // Método para actualizar un gasto
  Future<int> actualizarGasto(Gasto gasto) async {
    final database = await db;
    try {
      return await database.update(
        'gastos',
        gasto.toMap(),
        where: 'id = ?',
        whereArgs: [gasto.id],
      );
    } catch (e) {
      print("Error al actualizar el gasto: $e");
      return 0;
    }
  }

  // Método para cerrar la base de datos
  Future<void> closeDB() async {
    final database = await db;
    await database.close();
  }
}
