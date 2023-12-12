import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:flutter/material.dart';


Future<void> exportFile(BuildContext context,files) async {
  String? message;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    // Get temporary directory
    final dir = await getTemporaryDirectory();
    // Create an file name
    var fileName = "${dir.path}/${files['title'].toString().isNotEmpty?files['title']:"${files['id']}"}-2.txt";

    // Save to filesystem
    final file = File(fileName);
    await file.writeAsString(files['title'].toString().isNotEmpty?"${files['title']}\n${files['desc']}":"${files['desc']}");

    // Ask the user to save it
    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final finalPath = await FlutterFileDialog.saveFile(params: params);

    if (finalPath != null) {
      message = 'File saved to disk';
    }
  } catch (e) {
    message = 'An error occurred while saving the file';
  }

  if (message != null) {
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

  Future<String?> importFile()async{
  FilePickerResult? result = await FilePicker.platform.pickFiles( type: FileType.custom,
    allowedExtensions: ['txt','pdf']
  );
  if(result != null){
    String data ='';

    if(result.files.first.extension == 'txt'){
      File file = File(result.files.first.path!);
      await file.readAsString().then((value) {
        data = value;
      });
      if(data.isNotEmpty){
        return data ;
      }
    }else if(result.files.first.extension == 'pdf'){
      String text = "";
      try {
        text = await ReadPdfText.getPDFtext(result.files.first.path!);
      } on PlatformException {
        if (kDebugMode) {
          print('Failed to get PDF text.');
        }
      }
     if(text.isNotEmpty){

       return text;

     }
    }

  }else{
    return null;
  }
  return null;
}