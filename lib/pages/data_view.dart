
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/database.dart';
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
  bool titleIsReadOnly = true;
  bool detailsIsReadOnly = true;
  bool isHas= false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Notes"),
        leading: IconButton(onPressed: ()=>Navigator.pop(context),icon: const Icon(Icons.arrow_back,color: Colors.lightBlue,size: 25,),),
        actions: isHas?[
          IconButton(onPressed: (){

            if(widget.id != null){
            String  modifyDate  = DateFormat.yMMMd().add_jm().format(DateTime.now());
              Map<String,dynamic> data ={
                'name': _title.text,
                'description': _details.text,
                'modifyDate' : modifyDate
              };
              DBHelper.updateData(table, data,widget.id!);


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

          }, icon: const Icon(Icons.done,color: Colors.lightBlue,size: 35,))]:[
            IconButton(onPressed: (){}, icon:const Icon(Icons.share,color: Colors.lightBlue,size: 25,) ),
            IconButton(onPressed: (){}, icon:const Icon(Icons.menu,color: Colors.lightBlue,size: 25,) ),

        ],),

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
