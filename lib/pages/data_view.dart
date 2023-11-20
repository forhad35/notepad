
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_pads/helper_widget/back_icon_widget.dart';
import 'package:note_pads/pages/share_page.dart';
import '../core/database.dart';
import 'home.dart';
class ViewUpdate extends StatefulWidget {
 final String? title , desc,createDate,modifyDate;
 final int? id;
  const ViewUpdate({super.key,
     this.desc,
     this.title,
     this.id, this.createDate, this.modifyDate
  });

  @override
  State<ViewUpdate> createState() => _ViewUpdateState();
}

class _ViewUpdateState extends State<ViewUpdate> {
  final _title = TextEditingController();
  final _details = TextEditingController();
   bool isModifyDate = false,isCreateDate = false;
  @override
  void initState() {
    super.initState();
    if(widget.id != null){
      if(widget.title!.isNotEmpty){
        _title.text = widget.title!;
      }
      if(widget.desc!.isNotEmpty){
        _details.text= widget.desc!;
      }
      if(widget.modifyDate != null && widget.modifyDate!.isNotEmpty ){
        isModifyDate = true;
      }
      if(widget.createDate != null &&widget.createDate!.isNotEmpty){
        isCreateDate = true;
      }
    }
  }
  updateData(){
    if(isHas){
      String  modifyDate  = DateFormat.yMMMd().add_jm().format(DateTime.now());
      Map<String,dynamic> data ={
        'name': _title.text,
        'description': _details.text,
        'modifyDate' : modifyDate
      };
      DBHelper.updateData(table, data,widget.id!);
    }
  }
  bool titleIsReadOnly = true;
  bool detailsIsReadOnly = true;
  bool isHas= false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Notes"),
        leading: backIcon(context),
        actions: isHas?[
          IconButton(onPressed: (){

            if(widget.id != null){
            updateData();
            }else{
            String  createDate = DateFormat.yMMMd().add_jm().format(DateTime.now());
              Map<String,dynamic> data ={
                'name': _title.text,
                'description': _details.text,
                'createDate': createDate,
              };
              DBHelper.insertData(table, data);

            }
            FocusManager.instance.primaryFocus?.unfocus();
            isHas = false;
            setState(() {

            });

          }, icon: const Icon(Icons.done,color: Colors.lightBlue,size: 35,))]: widget.id !=null?[
            IconButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=> SharePage(title: _title.text,details: _details.text,)));}, icon:const Icon(Icons.share,color: Colors.lightBlue,size: 25,) ),
            // IconButton(onPressed: (){}, icon:const Icon(FontAwesomeIcons.ellipsisVertical,color: Colors.lightBlue,size: 25,) ),
          PopupMenuButton(
            icon: const Icon(FontAwesomeIcons.ellipsisVertical,color: Colors.lightBlue,size: 25,),
            color:Colors.white,
            itemBuilder: (BuildContext context) {
              return[
                PopupMenuItem(
                  onTap:() {
                    showDialog(context: context, builder: (context,)=> AlertDialog(
                      title: const Text("Delete the notes?"),
                      content: const Text("Are you sure to delete the a note"),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child:const Text("Cancel")),
                        TextButton(onPressed: (){
                          var itemIDs = widget.id.toString();
                          DBHelper.deleteData(table, itemIDs);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()), (route) => false);
                        }, child:const Text("Delete")),
                      ],
                    ));

                  },
                  padding: const EdgeInsets.only(left: 50,right: 5),
                    child: SizedBox(
                      width:100,
                      child: Transform.translate(
                        offset: const Offset(-30,0),
                        child: const Text("Delete",style: TextStyle(color: Color(0xff444343),fontSize: 16),),
                      ),
                    ),
                ),
              ];
            },
            elevation: 2,
            offset: const Offset(-30,40),
            position: PopupMenuPosition.over,
          ),

        ]:null,),

      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child:isCreateDate? Text("Create Date : ${widget.createDate}",style: const TextStyle(fontSize: 10),):null,
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: isModifyDate ? Text("Last modify : ${widget.modifyDate}",style: const TextStyle(fontSize: 10),):null,
              ),
              TextFormField(
                controller: _title,
                onChanged: (value){
                  setState(() {
                    if(_title.text.isNotEmpty || _details.text.isNotEmpty){
                      isHas = true;
                    }else{
                      isHas = false;
                    }
                  });
                },

                style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                scribbleEnabled: false,
                smartDashesType: SmartDashesType.enabled,
                smartQuotesType: SmartQuotesType.enabled,
                // expands: true,
                onTap: (){
                  titleIsReadOnly= false;
                  setState(() {

                  });
                },
                // onEditingComplete: (){
                //   print('hello');
                //   // ScaffoldMessenger.of(context).showSnackBar(snakbar("text"));
                //
                //
                // },
                // onSaved: (v){
                //   print("cdsf $v ");
                // },
                textInputAction: TextInputAction.unspecified,
                minLines: 1,
                maxLines: 5,
                // maxLength: 300,
                readOnly: titleIsReadOnly,
                decoration: const InputDecoration(
                  hintText: "T i t l e",
                  border: InputBorder.none,

                ),
              ),
              TextFormField(
                controller: _details,
                readOnly: detailsIsReadOnly,
                onChanged: (value){
                  setState(() {
                    if(_title.text.isNotEmpty || _details.text.isNotEmpty){
                      isHas = true;
                    }else{
                      isHas = false;
                    }
                  });
                },
                maxLines: null,
                onTap: (){
                  detailsIsReadOnly= false;
                  setState(() {

                  });
                },
                decoration: const InputDecoration(
                  hintText: "Note something down",
                  border: InputBorder.none,

                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
