import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
Future directory()async{
  var status = await Permission.storage.status;
  if(!status.isGranted){
    await Permission.storage.request();
  }
  try{
    final dir = Directory('${(Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory() //FOR IOS
    )!.path}/notes');
    // var dir = Directory("/storage/emulated/0/com.Notebook.notes/");
    // var dir = Directory("${dirr.path}/notes");
    if(await dir.exists()){
      print("this is true $dir");
      return dir.path;
    }else{
      print("creat :  $dir");
      await dir.create(recursive: true);
      return dir;
    }
  }catch(e){
    print("ERror :  $e");
  }
}
var dir ;
exportFile(files)async{
  var filePath = "/${files['title']}${files['id']}.txt";
  print(files.toString());
 await directory().then((value){
    dir = "$value$filePath";
  });
  File file = await File(dir);
  file.writeAsString(jsonEncode(files));
}
importFile()async{
  Map<String,dynamic>? read ;
  var file =await File(dir);
   await file.readAsString().then((value) {
   read = jsonDecode(value);
  });
  print(read!);
}