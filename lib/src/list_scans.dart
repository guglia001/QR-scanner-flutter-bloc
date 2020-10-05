import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:restaurant_menu_scanner/src/bloc/scan_bloc.dart';

import 'model/scanmodel.dart';

class ListScans extends StatelessWidget {
  final scansBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamm,
      builder: (context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final scans = snapshot.data;

        if (scans.length == 0) {
          return Center(
            child: Text("No hay informacion"),
          );
        }

        return Container(
          height: 200,
          width: double.infinity,
          child: ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, index) => Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (direction) => scansBloc.borrarScan(scans[index].id),
              child: ListTile(
                onTap: () {
                  FlutterWebBrowser.openWebPage(
                    url: scans[index].url,
                    androidToolbarColor: Colors.black87,
                  );
                },
                subtitle: Text(scans[index].url),
                title: Text(scans[index].titulo),
                trailing:
                    Icon(Icons.keyboard_arrow_right, color: Colors.white70),
              ),
            ),
          ),
        );
      },
    );
  }
}
