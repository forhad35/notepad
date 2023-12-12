import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

exportFile( files)async
{
  await Permission.manageExternalStorage.request();

  var status = await Permission.storage.status;
  var statuss =   await Permission.manageExternalStorage.status;

  if(status.isDenied || statuss.isDenied){
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }
  // if (!await FlutterFileDialog.isPickDirectorySupported()) {
  //   print("Picking directory not supported");
  //   return;
  // }

  // final pickedDirectory = await FlutterFileDialog.pickDirectory();
  //
  // if (pickedDirectory != null) {
  //   var file =files['title'].toString().isNotEmpty?"${files['title']}\n${files['desc']}":"${files['desc']}";
  //
  //   List<int> list = utf8.encode(file);
  //   Uint8List bytes = Uint8List.fromList(list);
  //    await FlutterFileDialog.saveFileToDirectory(
  //     directory: pickedDirectory,
  //     data: bytes,
  //     mimeType: "document/txt",
  //     fileName: "fileName.txt",
  //     replace: true,
  //   );
  // }
  if(status.isGranted || statuss.isGranted){
    var fileName = "/${files['title'].toString().isNotEmpty?files['title']:"Untitled"}-2.txt";
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    // var directory = Directory((await getExternalStorageDirectory())!.path );
    // var directory=Directory('/storage/emulated/0/com.notepads.notes');
    // directory.create(recursive: true);
    // print(directory);
    if (selectedDirectory != null) {
      File file = File("$selectedDirectory$fileName");
      // if title is empty then only description convert text file
      file.writeAsString(files['title'].toString().isNotEmpty?"${files['title']}\n${files['desc']}":"${files['desc']}");

      // var parms = SaveFileDialogParams(sourceFilePath: file.path);
      // final finalPath = await FlutterFileDialog.saveFile(params: parms);
      // if(finalPath!=null){
      //   print('success');
      // }

    }

  }else{
    if (kDebugMode) {
      print(" permission denied");
      await Permission.manageExternalStorage.request();
      await Permission.storage.request();
    }
  }

}
//=========================================  export function end ================================================


//=========================================  import function start ================================================

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
      print(result.files.first.extension);
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
Future<String> getPDFText(String path) async {
  String text = "";
  try {
    text = await ReadPdfText.getPDFtext(path);
  } on PlatformException {
    if (kDebugMode) {
      print('Failed to get PDF text.');
    }
  }
  return text;
}