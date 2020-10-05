import 'package:about/about.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:restaurant_menu_scanner/src/bloc/scan_bloc.dart';
import 'package:restaurant_menu_scanner/src/list_scans.dart';
import 'package:restaurant_menu_scanner/src/model/scanmodel.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

class RecentScans extends StatefulWidget {
  @override
  _RecentScansState createState() => _RecentScansState();
}

class _RecentScansState extends State<RecentScans> {
  MobileAdTargetingInfo info = MobileAdTargetingInfo(
      keywords: <String>['restaurant', 'QR', 'menu', 'food', 'Insurance', 'Loans', 'Mortgage', 'Attorney', 'Credit', 'trading', 'covid', 'coronavirus'],
      childDirected: false,
      nonPersonalizedAds: false,
      // testDevices: <String>["D6644F62971DDA7C08A57046E75EC91F"]
      );

  BannerAd createBannerAd() {
    FirebaseAdMob.instance.initialize(
      appId: "ca-app-pub-4476745438283982~6273322861",
    );
    return BannerAd(
      adUnitId: 'ca-app-pub-4476745438283982/6157858511',
      // adUnitId: BannerAd.testAdUnitId,
      targetingInfo: info,

      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          createBannerAd()
            ..load()
            ..show();
        }
        print("BannerAd event $event");
      },
    );
  }

  final scansBloc = new ScansBloc();

  scan() async {
    ScanResult scan;

    try {
      scan = await BarcodeScanner.scan();
    } catch (e) {
      scan.rawContent = e.toString();
    }
    if (scan.rawContent != '') {
      var req = await extract(scan.rawContent);

      final db = ScanModel(url: scan.rawContent, titulo: req.title);
      scansBloc.agregarScan(db);
      FlutterWebBrowser.openWebPage(
        url: scan.rawContent,
        androidToolbarColor: Colors.black87,
      );
    }
  }

  @override
  void initState() {
    final ad = createBannerAd();
    ad..load();
    ad
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );

    scan();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: size.height * 0.7,
              left: size.width * 0.77,
              child: FloatingActionButton(
                  child: Icon(
                    AntDesign.scan1,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecentScans()),
                    );
                  }),
            ),
            Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Escaneos Recientes",
                          style: TextStyle(color: Colors.white70),
                        ),
                        Spacer(),
                        IconButton(
                            icon: Icon(Entypo.info),
                            onPressed: () {
                              showAboutPage(
                                context: context,
                                applicationLegalese:
                                    'Copyright © Mario Guglia, {{ year }}',
                                applicationDescription: const Text(
                                    'Escanear codigo QR de menús de restaurantes y tener un historial de los mismos'),
                                children: <Widget>[
                                  MarkdownPageListTile(
                                    icon: Icon(Icons.list),
                                    title: const Text('Changelog'),
                                    filename: 'CHANGELOG.md',
                                  ),
                                  LicensesPageListTile(
                                    icon: Icon(Icons.favorite),
                                  ),
                                ],
                                applicationIcon: const SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image(
                                    image: AssetImage('assets/icon.png'),
                                  ),
                                ),
                              );
                            }),
                        IconButton(
                            icon: Icon(Icons.delete_forever),
                            onPressed: () => scansBloc.borrarTodos())
                      ],
                    ),
                  ),
                ),
                ListScans(),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
