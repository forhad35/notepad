
import 'package:flutter/material.dart';

import '../core/database.dart';

class ViewUpdate extends StatefulWidget {
  String? title , desc;
  int? id;
  ViewUpdate({
     this.desc,
     this.title,
     this.id
  });

  @override
  State<ViewUpdate> createState() => _ViewUpdateState();
}

class _ViewUpdateState extends State<ViewUpdate> {
  final _title = TextEditingController();
  final _details = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.id != null){
      if(widget.title!.isNotEmpty){
        _title.text = widget.title!;
      }
      if(widget.desc!.isNotEmpty){
        _details.text= widget.desc!;
      }
    }
  }
  bool title_is_read_only = true;
  bool details_is_read_only = true;
  bool is_has= false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Notes"),
        actions: is_has?[
          IconButton(onPressed: (){
            Map<String,dynamic> data ={
              'name': _title.text,
              'description': _details.text
            };

            if(widget.id != null){

              DBHelper.updateData(table, data,widget.id!);
            }else{
              DBHelper.insertData(table, data);
            }
            FocusManager.instance.primaryFocus?.unfocus();
            is_has = false;
            setState(() {

            });

          }, icon: Icon(Icons.done,weight:5,))]:null,),

      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: _title,
              onChanged: (value){
                setState(() {
                  if(_title.text.isNotEmpty || _details.text.isNotEmpty){
                    is_has = true;
                  }else{
                    is_has = false;
                  }
                });
              },
              onTap: (){
                title_is_read_only= false;
                setState(() {

                });
              },
              readOnly: title_is_read_only,
              decoration: InputDecoration(
                hintText: "T i t l e",
                border: InputBorder.none,

              ),
            ),
            TextFormField(
              controller: _details,
              readOnly: details_is_read_only,
              onChanged: (value){
                setState(() {
                  if(_title.text.isNotEmpty || _details.text.isNotEmpty){
                    is_has = true;
                  }else{
                    is_has = false;
                  }
                });
              },
              onTap: (){
                details_is_read_only= false;
                setState(() {

                });
              },
              decoration: InputDecoration(
                hintText: "Note somthing down",
                border: InputBorder.none,

              ),
            ),
          ],
        ),
      ),

    );
  }
}
