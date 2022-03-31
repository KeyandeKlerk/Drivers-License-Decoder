import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:license_scanner/pages/in_or_out.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:license_scanner/rsa_scan.dart';
import 'package:license_scanner/pages/login_page.dart';
import 'model/insert_card_model.dart';
import 'pages/takeAPicture.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SharedPreferences pref = await SharedPreferences.getInstance();
  var userID = pref.getString('UserID');
  runApp(MaterialApp(home: userID == null ? LoginPage() : InOrOut()));
}

Future<InsertCard> insertCard(
    String inOrOut,
    String scannerType,
    String id,
    String firstName,
    String lastName,
    String birthDate,
    String gender,
    String nationality,
    String countryOfBirth,
    String issueDate,
    String smartIdNumber) async {
  String url =
      "https://www.zentylvms.co.za/API/1d-camera/camera_insert_card.php";
  const headers = {'Content-Type': 'application/json'};
  final response = await http.post(Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        "inorout": inOrOut,
        "scannerType": scannerType,
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "birthDate": birthDate,
        "gender": gender,
        "nationality": nationality,
        "countryOfBirth": countryOfBirth,
        "issueDate": issueDate,
        "smartIdNumber": smartIdNumber
      }));
  if (response.statusCode == 200 || response.statusCode == 400) {
    return InsertCard.fromJson(
      json.decode(response.body),
    );
  } else {
    return null;
  }
}

Future<InsertBook> insertBook(String inOrOut, String scannerType, String id,
    String birthDate, String gender, String citizenshipStatus) async {
  String url =
      "https://www.zentylvms.co.za/API/1d-camera/camera_insert_book.php";
  const headers = {'Content-Type': 'application/json'};
  final response = await http.post(Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        "inorout": inOrOut,
        "scannerType": scannerType,
        "id": id,
        "birthDate": birthDate,
        "gender": gender,
        "citizenshipStatus": citizenshipStatus
      }));
  if (response.statusCode == 200 || response.statusCode == 400) {
    return InsertBook.fromJson(
      json.decode(response.body),
    );
  } else {
    return null;
  }
}

Future<InsertDriver> insertDriver(
    String inOrOut,
    String scannerType,
    String licenseNumber,
    String id,
    String idType,
    String countryOfIssue,
    String firstName,
    String lastName,
    String birthDate,
    String gender,
    String driverRestriction,
    String issueDate,
    String licenseIssueNumber,
    String licenseCountryIssue,
    String pdpCode,
    String pdpExpiry,
    String validFrom,
    String validTo,
    String vehicleCode,
    String vehicleRestrictions) async {
  String url =
      "https://www.zentylvms.co.za/API/1d-camera/camera_insert_driver.php";
  const headers = {'Content-Type': 'application/json'};
  final response = await http.post(Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        "site": "PBSA",
        "inorout": inOrOut,
        "scannerType": scannerType,
        "licenseNumber": licenseNumber,
        "id": id,
        "idType": idType,
        "countryOfIssue": countryOfIssue,
        "firstName": firstName,
        "lastName": lastName,
        "birthDate": birthDate,
        "gender": gender,
        "driverRestriction": driverRestriction,
        "issueDate": issueDate,
        "licenseIssueNumber": licenseIssueNumber,
        "licenseCountryIssue": licenseCountryIssue,
        "pdpCode": pdpCode,
        "pdpExpiry": pdpExpiry,
        "validFrom": validFrom,
        "validTo": validTo,
        "vehicleCode": vehicleCode,
        "vehicleRestrictions": vehicleRestrictions
      }));
  if (response.statusCode == 200 || response.statusCode == 400) {
    print(response.body);
    return InsertDriver.fromJson(
      json.decode(response.body),
    );
  } else {
    return null;
  }
}

Future<InsertDisk> insertDisk(
    String diskNumber,
    String licenseNumber,
    String vehicleRegisterNumber,
    String description,
    String make,
    String model,
    String color,
    String vin,
    String engineNumber,
    String expiryDate) async {
  String url =
      "https://www.zentylvms.co.za/API/1d-camera/camera_insert_disk.php";
  const headers = {'Content-Type': 'application/json'};
  final response = await http.post(Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        "diskNumber": diskNumber,
        "licenseNumber": licenseNumber,
        "vehicleRegisterNumber": vehicleRegisterNumber,
        "description": description,
        "make": make,
        "model": model,
        "color": color,
        "vin": vin,
        "engineNumber": engineNumber,
        "expiryDate": expiryDate
      }));
  if (response.statusCode == 200 || response.statusCode == 400) {
    return InsertDisk.fromJson(
      json.decode(response.body),
    );
  } else {
    return null;
  }
}

class HomePage extends StatelessWidget {
  final String inOrOut, scannerType;
  HomePage({Key key, this.inOrOut, this.scannerType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zentyl Smart Camera')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (scannerType == "Pedestrian")
              ElevatedButton(
                child: Text('Scan ID Card'),
                onPressed: () async {
                  final idCard = await scanIdCard(context);
                  // Nothing was scanned
                  if (idCard == null) return;

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => IdCardDetailsPage(
                        rsaIdCard: idCard,
                        inOrOut: this.inOrOut,
                        scannerType: scannerType),
                  ));
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            if (scannerType == "Pedestrian") SizedBox(height: 8.0),
            if (scannerType == "Pedestrian")
              ElevatedButton(
                child: Text('Scan ID Book'),
                onPressed: () async {
                  final idBook = await scanIdBook(context);

                  // Nothing was scanned
                  if (idBook == null) return;

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => IdBookDetailsPage(
                        rsaIdBook: idBook,
                        inOrOut: this.inOrOut,
                        scannerType: scannerType),
                  ));
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            if (scannerType != "Pedestrian") SizedBox(height: 8.0),
            if (scannerType != "Pedestrian")
              ElevatedButton(
                child: Text('Scan Driver\'s License'),
                onPressed: () async {
                  print(this.inOrOut);
                  final drivers = await scanDrivers(context);

                  // Nothing was scanned
                  if (drivers == null) return;

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DriversDetailsPage(
                        rsaDrivers: drivers,
                        inOrOut: this.inOrOut,
                        scannerType: scannerType),
                  ));
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            if (scannerType != "Pedestrian") SizedBox(height: 8.0),
            if (scannerType != "Pedestrian")
              ElevatedButton(
                child: Text('Scan Vehicle Disk'),
                onPressed: () async {
                  String barcodeScanRes =
                      await FlutterBarcodeScanner.scanBarcode(
                          "#00AAFF", "Cancel", true, ScanMode.BARCODE);
                  List<String> result = barcodeScanRes.split("%");
                  var placeholder1 = result[1];
                  var placeholder2 = result[2];
                  var placeholder3 = result[3];
                  var placeholder4 = result[4];
                  var diskNumber = result[5];
                  var licenseNumber = result[6];
                  var vehicleRegisterNumber = result[7];
                  var description = result[8];
                  var make = result[9];
                  var model = result[10];
                  var color = result[11];
                  var vin = result[12];
                  var engineNumber = result[13];
                  var expiryDate = result[14];
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DiskDetailsPage(
                          diskNumber: diskNumber,
                          licenseNumber: licenseNumber,
                          vehicleRegisterNumber: vehicleRegisterNumber,
                          description: description,
                          make: make,
                          model: model,
                          color: color,
                          vin: vin,
                          engineNumber: engineNumber,
                          expiryDate: expiryDate)));
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            SizedBox(height: 8.0),
            ElevatedButton(
              child: Text('Take A Picture'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TakePhoto(),
                ));
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 10),
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

class IdCardDetailsPage extends StatefulWidget {
  final RsaIdCard rsaIdCard;
  final String inOrOut;
  final String scannerType;
  const IdCardDetailsPage(
      {Key key, @required this.rsaIdCard, this.inOrOut, this.scannerType})
      : super(key: key);

  @override
  State<IdCardDetailsPage> createState() => _IdCardDetailsPageState();
}

class _IdCardDetailsPageState extends State<IdCardDetailsPage> {
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String mtoken = "";
  String usrID, usrEmail, usrCompanyID, usrSite;

  @override
  void initState() {
    super.initState();
    requestPermission();
    loadFCM();
    listenFCM();
    getToken();
  }

  void getTokenFromFirestore(String id, String header, String body) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("UserTokens").doc(id).get();
    String token = snap["token"];
    sendPushNotification(header, body, token);
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
      saveToken(token);
    });
  }

  void saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    usrID = pref.getString('UserID');
    await FirebaseFirestore.instance.collection("UserTokens").doc(usrID).set({
      'token': token,
    });
  }

  void sendPushNotification(String title, String body, String recipient) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAC26E5zA:APA91bEH_QRcvnVXqAsb1CILS13bPU-IyDZtJ8Ae078C3tmOFgGxDohQv0blK330nC-Hgrxmr7ktRKPafNtvdbocBq2we12F95mDdL4nE47xP8ekoYFgU1NtcFahPzwjezIlSHk0xiec'
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{'body': body, 'title': title},
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              "to": recipient,
            },
          ));
    } catch (e) {
      print("error push notification" + e.toString());
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Authorised");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Provisional");
    } else {
      print("declined/not accepted");
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void readPref() async {
    final pref = await SharedPreferences.getInstance();
    usrID = pref.getString('UserID');
    usrEmail = pref.getString('Email');
    usrCompanyID = pref.getString("CompanyID");
    usrSite = pref.getString('Site');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ID Card Details')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('ID Number: ${widget.rsaIdCard.idNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('First Names: ${widget.rsaIdCard.firstNames}'),
          ),
          Divider(),
          ListTile(
            title: Text('Last Name: ${widget.rsaIdCard.surname}'),
          ),
          Divider(),
          ListTile(
            title: Text('Date Of Birth: ${widget.rsaIdCard.birthDate}'),
          ),
          Divider(),
          ListTile(
            title: Text('Gender: ${widget.rsaIdCard.gender}'),
          ),
          Divider(),
          ListTile(
            title: Text('National: ${widget.rsaIdCard.nationality}'),
          ),
          Divider(),
          ListTile(
            title: Text('Country Of Birth: ${widget.rsaIdCard.countryOfBirth}'),
          ),
          Divider(),
          ListTile(
            title: Text('Issue Date: ${widget.rsaIdCard.issueDate}'),
          ),
          Divider(),
          ListTile(
            title: Text('Smart ID Number: ${widget.rsaIdCard.smartIdNumber}'),
          ),
          Container(height: 8.0),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () async {
              final InsertCard user = await insertCard(
                  widget.inOrOut,
                  widget.scannerType,
                  widget.rsaIdCard.idNumber,
                  widget.rsaIdCard.firstNames,
                  widget.rsaIdCard.surname,
                  widget.rsaIdCard.birthDate.toString(),
                  widget.rsaIdCard.gender,
                  widget.rsaIdCard.nationality,
                  widget.rsaIdCard.countryOfBirth,
                  widget.rsaIdCard.issueDate.toString(),
                  widget.rsaIdCard.smartIdNumber);
              if (widget.inOrOut == "IN") {
                getTokenFromFirestore("52", "ID CARD IN", "Test scan in");
              } else {
                getTokenFromFirestore(usrID, "ID CARD OUT", "Test Scan out");
              }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => InOrOut()),
                (Route<dynamic> route) => false,
              );
            },
            color: Colors.lightBlue,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          ),
        ],
      ),
    );
  }
}

class IdBookDetailsPage extends StatefulWidget {
  final RsaIdBook rsaIdBook;
  final String inOrOut;
  final String scannerType;
  const IdBookDetailsPage(
      {Key key, @required this.rsaIdBook, this.inOrOut, this.scannerType})
      : super(key: key);

  @override
  State<IdBookDetailsPage> createState() => _IdBookDetailsPageState();
}

class _IdBookDetailsPageState extends State<IdBookDetailsPage> {
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String mtoken = "";
  String usrID, usrEmail, usrCompanyID, usrSite;

  @override
  void initState() {
    super.initState();
    requestPermission();
    loadFCM();
    listenFCM();
    getToken();
  }

  void getTokenFromFirestore(String id, String header, String body) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("UserTokens").doc(id).get();
    String token = snap["token"];
    sendPushNotification(header, body, token);
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
      saveToken(token);
    });
  }

  void saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    usrID = pref.getString('UserID');
    await FirebaseFirestore.instance.collection("UserTokens").doc(usrID).set({
      'token': token,
    });
  }

  void sendPushNotification(String title, String body, String recipient) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAC26E5zA:APA91bEH_QRcvnVXqAsb1CILS13bPU-IyDZtJ8Ae078C3tmOFgGxDohQv0blK330nC-Hgrxmr7ktRKPafNtvdbocBq2we12F95mDdL4nE47xP8ekoYFgU1NtcFahPzwjezIlSHk0xiec'
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{'body': body, 'title': title},
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              "to": recipient,
            },
          ));
    } catch (e) {
      print("error push notification" + e.toString());
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Authorised");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Provisional");
    } else {
      print("declined/not accepted");
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void readPref() async {
    final pref = await SharedPreferences.getInstance();
    usrID = pref.getString('UserID');
    usrEmail = pref.getString('Email');
    usrCompanyID = pref.getString("CompanyID");
    usrSite = pref.getString('Site');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ID Book Details')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('ID Number: ${widget.rsaIdBook.idNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('Date Of Birth: ${widget.rsaIdBook.birthDate}'),
          ),
          Divider(),
          ListTile(
            title: Text('Gender: ${widget.rsaIdBook.gender}'),
          ),
          Divider(),
          ListTile(
            title: Text(
                'Citizenship Status: ${widget.rsaIdBook.citizenshipStatus}'),
          ),
          Container(height: 8.0),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () async {
              final InsertBook user = await insertBook(
                  widget.inOrOut,
                  widget.scannerType,
                  widget.rsaIdBook.idNumber,
                  widget.rsaIdBook.birthDate.toString(),
                  widget.rsaIdBook.gender,
                  widget.rsaIdBook.citizenshipStatus);
              if (widget.inOrOut == "IN") {
                getTokenFromFirestore(usrID, "ID BOOK IN", "Test scan in");
              } else {
                getTokenFromFirestore(usrID, "ID BOOK OUT", "Test Scan out");
              }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              );
            },
            color: Colors.lightBlue,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          ),
        ],
      ),
    );
  }
}

class DriversDetailsPage extends StatefulWidget {
  final RsaDriversLicense rsaDrivers;
  final String inOrOut;
  final String scannerType;
  const DriversDetailsPage(
      {Key key, @required this.rsaDrivers, this.inOrOut, this.scannerType})
      : super(key: key);

  @override
  State<DriversDetailsPage> createState() => _DriversDetailsPageState();
}

class _DriversDetailsPageState extends State<DriversDetailsPage> {
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String mtoken = "";
  String usrID, usrEmail, usrCompanyID, usrSite;

  @override
  void initState() {
    super.initState();
    requestPermission();
    loadFCM();
    listenFCM();
    getToken();
  }

  void getTokenFromFirestore(String id, String header, String body) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("UserTokens").doc(id).get();
    String token = snap["token"];
    sendPushNotification(header, body, token);
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
      saveToken(token);
    });
  }

  void saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    usrID = pref.getString('UserID');
    await FirebaseFirestore.instance.collection("UserTokens").doc(usrID).set({
      'token': token,
    });
  }

  void sendPushNotification(String title, String body, String recipient) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAC26E5zA:APA91bEH_QRcvnVXqAsb1CILS13bPU-IyDZtJ8Ae078C3tmOFgGxDohQv0blK330nC-Hgrxmr7ktRKPafNtvdbocBq2we12F95mDdL4nE47xP8ekoYFgU1NtcFahPzwjezIlSHk0xiec'
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{'body': body, 'title': title},
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              "to": recipient,
            },
          ));
    } catch (e) {
      print("error push notification" + e.toString());
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Authorised");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Provisional");
    } else {
      print("declined/not accepted");
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void readPref() async {
    final pref = await SharedPreferences.getInstance();
    usrID = pref.getString('UserID');
    usrEmail = pref.getString('Email');
    usrCompanyID = pref.getString("CompanyID");
    usrSite = pref.getString('Site');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Driver\'s License')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('License Number: ${widget.rsaDrivers.licenseNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('ID Number: ${widget.rsaDrivers.idNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('ID Number Type: ${widget.rsaDrivers.idNumberType}'),
          ),
          Divider(),
          ListTile(
            title:
                Text('Country Of Issue: ${widget.rsaDrivers.idCountryOfIssue}'),
          ),
          Divider(),
          ListTile(
            title: Text('First Names: ${widget.rsaDrivers.firstNames}'),
          ),
          Divider(),
          ListTile(
            title: Text('Last Name: ${widget.rsaDrivers.surname}'),
          ),
          Divider(),
          ListTile(
            title: Text('Date of Birth: ${widget.rsaDrivers.birthDate}'),
          ),
          Divider(),
          ListTile(
            title: Text('Gender: ${widget.rsaDrivers.gender}'),
          ),
          Divider(),
          ListTile(
            title: Text(
                'Driver Restrictions: ${widget.rsaDrivers.driverRestrictions}'),
          ),
          Divider(),
          ListTile(
            title: Text('Issue Dates: ${widget.rsaDrivers.issueDates}'),
          ),
          Divider(),
          ListTile(
            title:
                Text('Issue Number: ${widget.rsaDrivers.licenseIssueNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text(
                'Country Of Issue: ${widget.rsaDrivers.licenseCountryOfIssue}'),
          ),
          Divider(),
          ListTile(
            title: Text('PDP Code: ${widget.rsaDrivers.prdpCode}'),
          ),
          Divider(),
          ListTile(
            title: Text('PDP Expiry: ${widget.rsaDrivers.prdpExpiry}'),
          ),
          Divider(),
          ListTile(
            title: Text('Valid From: ${widget.rsaDrivers.validFrom}'),
          ),
          Divider(),
          ListTile(
            title: Text('Valid To: ${widget.rsaDrivers.validTo}'),
          ),
          Divider(),
          ListTile(
            title: Text('Vehicle Codes: ${widget.rsaDrivers.vehicleCodes}'),
          ),
          Divider(),
          ListTile(
            title: Text(
                'Vehicle Restrictions: ${widget.rsaDrivers.vehicleRestrictions}'),
          ),
          Container(height: 8.0),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () async {
              final InsertDriver user = await insertDriver(
                  widget.inOrOut,
                  widget.scannerType,
                  widget.rsaDrivers.licenseNumber,
                  widget.rsaDrivers.idNumber,
                  widget.rsaDrivers.idNumberType,
                  widget.rsaDrivers.idCountryOfIssue,
                  widget.rsaDrivers.firstNames,
                  widget.rsaDrivers.surname,
                  widget.rsaDrivers.birthDate.toString(),
                  widget.rsaDrivers.gender,
                  widget.rsaDrivers.driverRestrictions,
                  widget.rsaDrivers.issueDates.toString(),
                  widget.rsaDrivers.licenseIssueNumber,
                  widget.rsaDrivers.licenseCountryOfIssue,
                  widget.rsaDrivers.prdpCode,
                  widget.rsaDrivers.prdpExpiry.toString(),
                  widget.rsaDrivers.validFrom.toString(),
                  widget.rsaDrivers.validTo.toString(),
                  widget.rsaDrivers.vehicleCodes.toString(),
                  widget.rsaDrivers.vehicleRestrictions.toString());
              if (widget.inOrOut == "IN") {
                getTokenFromFirestore(usrID, "DRIVERS IN", "Test scan in");
              } else {
                getTokenFromFirestore(usrID, "DRIVERS OUT", "Test Scan out");
              }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              );
            },
            color: Colors.lightBlue,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          ),
        ],
      ),
    );
  }
}

class DiskDetailsPage extends StatefulWidget {
  final String diskNumber;
  final String licenseNumber;
  final String vehicleRegisterNumber;
  final String description;
  final String make;
  final String model;
  final String color;
  final String vin;
  final String engineNumber;
  final String expiryDate;
  const DiskDetailsPage(
      {Key key,
      this.diskNumber,
      this.licenseNumber,
      this.vehicleRegisterNumber,
      this.description,
      this.make,
      this.model,
      this.color,
      this.vin,
      this.engineNumber,
      this.expiryDate})
      : super(key: key);

  @override
  State<DiskDetailsPage> createState() => _DiskDetailsPageState();
}

class _DiskDetailsPageState extends State<DiskDetailsPage> {
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String mtoken = "";
  String usrID, usrEmail, usrCompanyID, usrSite;

  @override
  void initState() {
    super.initState();
    requestPermission();
    loadFCM();
    listenFCM();
    getToken();
  }

  void getTokenFromFirestore(String id, String header, String body) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("UserTokens").doc(id).get();
    String token = snap["token"];
    sendPushNotification(header, body, token);
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
      saveToken(token);
    });
  }

  void saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    usrID = pref.getString('UserID');
    await FirebaseFirestore.instance.collection("UserTokens").doc(usrID).set({
      'token': token,
    });
  }

  void sendPushNotification(String title, String body, String recipient) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAC26E5zA:APA91bEH_QRcvnVXqAsb1CILS13bPU-IyDZtJ8Ae078C3tmOFgGxDohQv0blK330nC-Hgrxmr7ktRKPafNtvdbocBq2we12F95mDdL4nE47xP8ekoYFgU1NtcFahPzwjezIlSHk0xiec'
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{'body': body, 'title': title},
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              "to": recipient,
            },
          ));
    } catch (e) {
      print("error push notification" + e.toString());
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Authorised");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Provisional");
    } else {
      print("declined/not accepted");
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void readPref() async {
    final pref = await SharedPreferences.getInstance();
    usrID = pref.getString('UserID');
    usrEmail = pref.getString('Email');
    usrCompanyID = pref.getString("CompanyID");
    usrSite = pref.getString('Site');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ID Card Details')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Disk Number: ${widget.diskNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('License Number: ${widget.licenseNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text(
                'Vehicle Register Number: ${widget.vehicleRegisterNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('Description: ${widget.description}'),
          ),
          Divider(),
          ListTile(
            title: Text('Make: ${widget.make}'),
          ),
          Divider(),
          ListTile(
            title: Text('Model: ${widget.model}'),
          ),
          Divider(),
          ListTile(
            title: Text('Color: ${widget.color}'),
          ),
          Divider(),
          ListTile(
            title: Text('Vin: ${widget.vin}'),
          ),
          Divider(),
          ListTile(
            title: Text('Engine Number: ${widget.engineNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('Expiry Date: ${widget.expiryDate}'),
          ),
          Container(height: 8.0),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () async {
              insertDisk(
                  widget.diskNumber,
                  widget.licenseNumber,
                  widget.vehicleRegisterNumber,
                  widget.description,
                  widget.make,
                  widget.model,
                  widget.color,
                  widget.vin,
                  widget.engineNumber,
                  widget.expiryDate);
              getTokenFromFirestore(usrID, "Vehicle Disk", "Test scan in");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              );
            },
            color: Colors.lightBlue,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          ),
        ],
      ),
    );
  }
}
