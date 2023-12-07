import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listdata = [];
  bool _isloading = true;

  Future _getdata() async {
    try {
      final respose =
          await http.get(Uri.parse('http://192.168.18.6/flutter-api/db.php'));
      if (respose.statusCode == 200) {
        print(respose.body);
        final data = jsonDecode(respose.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    // print(_listdata);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latihan Rest API dengan PHP Native'),
        backgroundColor: Colors.green[400],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      _listdata[index]['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_listdata[index]['price']),
                  ),
                );
              }),
            ),
    );
  }
}
