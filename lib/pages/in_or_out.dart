import 'package:flutter/material.dart';
import 'package:license_scanner/pages/type_of_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class InOrOut extends StatelessWidget {
  void scanQRCode(BuildContext context, String InOrOut) async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      String cameraScanResult = await scanner.scan();
      print(cameraScanResult);
      var scannedResult = cameraScanResult.split("_");
      String visitor_name = scannedResult[0];
      String visitor_surname = scannedResult[1];
      String visitor_email = scannedResult[2];
      String visitor_datetime = scannedResult[3];
      String visitor_duration = scannedResult[4];
      String visitor_venue = scannedResult[5];
      String visitor_agenda = scannedResult[6];
      String host_name = scannedResult[7];
      String host_surnname = scannedResult[8];
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ScanType(inOrOut: InOrOut)));
    }

// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    print(statuses.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zentyl Smart Camera')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('IN'),
              onPressed: () {
                // ignore: non_constant_identifier_names
                final String InOrOut = "IN";
                scanQRCode(context, InOrOut);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 56, vertical: 10),
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              child: Text('OUT'),
              onPressed: () {
                // ignore: non_constant_identifier_names
                final String InOrOut = "OUT";
                scanQRCode(context, InOrOut);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 46, vertical: 10),
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
