import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
class ImageConverter extends StatefulWidget {
  const ImageConverter({super.key});

  @override
  State createState() => ImageConverterState();
}

class ImageConverterState extends State {
  late String _base64="";

  @override
  void initState() {
    super.initState();
    (() async {
      http.Response response = await http.get(Uri.parse("https://www.prepostseo.com/imgs/blog/2020/07/1594466867group-339-png.png"),
      );
      if (mounted) {
        setState(() {
          _base64 = Base64Encoder().convert(response.bodyBytes);
        });
      }
    })();
  }

  @override
  Widget build(BuildContext context) {
    if (_base64.isEmpty)
      return new Container();
    Uint8List bytes = Base64Codec().decode(_base64);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Base64 String'),
        backgroundColor: Colors.orange,),
      body: Container(
          child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    child: Image.memory(bytes,fit: BoxFit.cover,)),
              ))),


    );
  }
}