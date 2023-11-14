
import 'package:flutter/material.dart';
import '../core/database.dart';
class ViewUpdate extends StatefulWidget {
 final String? title , desc;
 final int? id;
  const ViewUpdate({super.key,
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
  bool titleIsReadOnly = true;
  bool detailsIsReadOnly = true;
  bool isHas= false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Notes"),
        leading: IconButton(onPressed: ()=>Navigator.pop(context),icon: const Icon(Icons.arrow_back_ios,color: Colors.lightBlue,),),
        actions: isHas?[
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
            isHas = false;
            setState(() {

            });

          }, icon: const Icon(Icons.done,color: Colors.lightBlue,))]:null,),

      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
