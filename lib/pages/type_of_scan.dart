import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:license_scanner/main.dart';

import 'in_or_out.dart';

class ScanType extends StatefulWidget {

  @override
  _ScanTypeState createState() => _ScanTypeState();
  final String inOrOut, scannerType;

  // ignore: non_constant_identifier_names
  const ScanType({Key key, this.inOrOut, this.scannerType}) : super(key: key);
}
var _isChecked = false;
var _isChecked1 = false;
var _isChecked2 = false;
var _isChecked3 = false;
var _isChecked4 = false;
var _isChecked5 = false;
class _ScanTypeState extends State<ScanType> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zentyl Smart Camera')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Visitor'),
              onPressed: () async {
                final String scanType = "Visitor";
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context, scanType, widget.inOrOut),
                );
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 66, vertical: 10),
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              child: Text('Contractor'),
              onPressed: () async {
                final String scanType = "Contractor";
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context, scanType, widget.inOrOut),
                );
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              child: Text('Pedestrian'),
              onPressed: () async {
                final String scanType = "Pedestrian";
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context, scanType, widget.inOrOut),
                );
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
  Widget _buildPopupDialog(BuildContext context, scanType, inOrOut) {
    return  new AlertDialog(
      title: const Text('Covid 19 Questionnaire'),
      content: SingleChildScrollView(
      child:new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Do you currently have symptoms of a respiratory infection?"),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width:117,
                child: CheckboxListTile(
                  title: const Text('YES'),
                  checkColor: Colors.blue,
                  selected: _isChecked,
                  value: _isChecked,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked = value;
                      if (_isChecked1 = true){
                        _isChecked1 = false;
                      }
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPopupDialog(context, scanType, widget.inOrOut),
                      );
                    });
                  },
                ),
              ),
              Container(
                width:112,
                child: CheckboxListTile(
                  title: const Text('NO'),
                  checkColor: Colors.blue,
                  selected: _isChecked1,
                  value: _isChecked1,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked1 = value;
                      if (_isChecked = true){
                        _isChecked = false;
                      }
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPopupDialog(context, scanType, widget.inOrOut),
                      );
                    });
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Text("Have you travelled outside this area (Country) within the past 10 days?"),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width:117,
                child: CheckboxListTile(
                  title: const Text('YES'),
                  checkColor: Colors.blue,
                  selected: _isChecked2,
                  value: _isChecked2,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked2 = value;
                      if (_isChecked3 = true){
                        _isChecked3 = false;
                      }
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPopupDialog(context, scanType, widget.inOrOut),
                      );
                    });
                  },
                ),
              ),
              Container(
                width:112,
                child: CheckboxListTile(
                  title: const Text('NO'),
                  checkColor: Colors.blue,
                  selected: _isChecked3,
                  value: _isChecked3,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked3 = value;
                      if (_isChecked2 = true){
                        _isChecked2 = false;
                      }
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPopupDialog(context, scanType, widget.inOrOut),
                      );
                    });
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Text("Have you been exposed to someone who has tested positive or diagnosed with Covid-19?"),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width:117,
                child: CheckboxListTile(
                  title: const Text('YES'),
                  checkColor: Colors.blue,
                  selected: _isChecked4,
                  value: _isChecked4,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked4 = value;
                      if (_isChecked5 = true){
                        _isChecked5 = false;
                      }
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPopupDialog(context, scanType, widget.inOrOut),
                      );
                    });
                  },
                ),
              ),
              Container(
                width:112,
                child: CheckboxListTile(
                  title: const Text('NO'),
                  checkColor: Colors.blue,
                  selected: _isChecked5,
                  value: _isChecked5,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked5 = value;
                      if (_isChecked4 = true){
                        _isChecked4 = false;
                      }
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPopupDialog(context, scanType, widget.inOrOut),
                      );
                    });
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Text("Temperature"),
          TextField(
            textAlign: TextAlign.start,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.singleLineFormatter
            ],
          ),
        ],
      ),
      ),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomePage(inOrOut: widget.inOrOut,scannerType: scanType)));
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}


