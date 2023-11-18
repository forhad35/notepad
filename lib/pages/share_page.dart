import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_pads/helper_widget/back_icon_widget.dart';
import 'package:share_plus/share_plus.dart';

class SharePage extends StatefulWidget {
  final String? title,details;
  const SharePage({super.key, this.title,this.details});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {

  String copyContent(){
    var shareContent = StringBuffer();
    if(widget.title != null){
      shareContent.write("${widget.title} \n");
    }
    if(widget.details != null){
      shareContent.write('${widget.details}');
    }
    return '$shareContent';
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.lightBlue, child: const Text("Share preview")),
        actions: [
          IconButton(onPressed: (){
            FlutterClipboard.copy(copyContent()).then((value)=> Fluttertoast.showToast(
                msg: "Copied",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0
            ));
          }, icon: const Icon(Icons.copy, color: Colors.lightBlue,))
        ],
        leading: backIcon(context),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(10),
          color: Colors.white,
          child: Container(
            width: MediaQuery.sizeOf(context).width-10,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title != null ?"${widget.title}":"",style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Text(widget.details != null ?"${widget.details}":"",textAlign: TextAlign.justify,style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () {
          Share.share(copyContent());
        },
        style: TextButton.styleFrom(
            backgroundColor: const Color(0xffefefef),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape:const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero
            )
        ),
        child:  SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 50,
            child: const Column(
              children: [
                Icon(Icons.share,size: 30,color: Colors.lightBlue,),
                Text("Share",style: TextStyle(color:Colors.lightBlue,),),
              ],
            )),

      ),    );
  }
  toast(){
    Fluttertoast.showToast(
        msg: "Copied",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
