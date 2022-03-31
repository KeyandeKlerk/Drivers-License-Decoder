import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:license_scanner/main.dart';

Future<Null> uploadFoodPhoto(filepath) async {
  String url =
      'https://www.zentylvms.co.za/API/1d-camera/camera_insert_image.php';
  try {
    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(filepath, filename: filepath);
    FormData formData = FormData.fromMap(map);
    await Dio().post('$url', data: formData).then((value) {
      print('Res = $value');
    });
  } catch (e) {}
}

class TakePhoto extends StatefulWidget {
  @override
  _TakePhoto createState() => _TakePhoto();
}

class _TakePhoto extends State<TakePhoto> {
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        var res = uploadFoodPhoto(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take a photo'),
      ),
      body: ListView(children: <Widget>[
        _image == null ? Text('No image selected.') : Image.file(_image),
        Container(height: 8.0),
        RaisedButton(
          child: Text('Submit another photo'),
          onPressed: () async {
            getImage();
          },
          color: Colors.lightBlue,
          textColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        ),
        Container(height: 8.0),
        RaisedButton(
          child: Text('Done'),
          onPressed: () async {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          },
          color: Colors.lightBlue,
          textColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
