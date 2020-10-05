import 'dart:async';
import 'package:restaurant_menu_scanner/src/providers/db_provider.dart';

class ScansBloc {
  static final _singleton = new ScansBloc._internal();
  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    // obtener scans bd
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStreamm => _scansController.stream;

  dispose() {
    _scansController?.close();
  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();

  }

  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getTodosLosScans());
  }

  borrarScan(int id) async {

    await DBProvider.db.deleteScan(id);
    obtenerScans(); //se ejecuta esto para que se actualize


  }

  borrarTodos() async {

    await DBProvider.db.deleteAllScans();
    // _scansController.sink.add([]); 
    obtenerScans();
  }
}
