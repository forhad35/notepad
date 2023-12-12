import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

exportFile( files)async
{
  // await Permission.manageExternalStorage.request();

  var status = await Permission.storage.status;
  var statuss =   await Permission.manageExternalStorage.status;

  if(status.isDenied || statuss.isDenied){
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }
  if(status.isGranted || statuss.isGranted){
    var fileName = "/${files['title'].toString().isNotEmpty?files['title']:"Untitled"}-id-${files['id']}.txt";
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    // var directory = Directory((await getExternalStorageDirectory())!.path );
    // var directory=Directory('/storage/emulated/0/com.notepads.notes');
    // directory.create(recursive: true);
    // print(directory);
    if (selectedDirectory != null) {
      File file = File("$selectedDirectory$fileName");
      file.writeAsString(jsonEncode(files));
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

  Future<Map<String,dynamic>?> importFile()async{
  FilePickerResult? result = await FilePicker.platform.pickFiles(
  );
  if(result != null){
    Map<String,dynamic>? data ;
    File file = File(result.files.first.path!);
    await file.readAsString().then((value) {
      data = jsonDecode(value.toString());
    });
    if(data !=null){
      return data ;
    }
  }else{
    return null;
  }
  return null;
}