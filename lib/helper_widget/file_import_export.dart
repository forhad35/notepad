import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

exportFile( files)async{
  var status = await Permission.storage.status;
  if(status.isDenied){
    await Permission.storage.request();
  }
  if(status.isGranted){
    var fileName = "/${files['title'].toString().isNotEmpty?files['title']:"Untitled"}-id-${files['id']}.txt";
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      File file = File("$selectedDirectory$fileName");
      file.writeAsString(jsonEncode(files));
    }
    print(selectedDirectory);
    print(files);

  }else{
    print(" permission denied");
  }

}

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
      print(data);
      return data ;
    }
  }else{
    print("result is null");
    return null;
  }
  return null;
}