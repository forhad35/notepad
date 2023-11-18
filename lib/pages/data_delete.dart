// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:note_pads/pages/home.dart';
import '../core/database.dart';

class DataDelete extends StatefulWidget {
  List data;
   DataDelete({super.key, required this.data});

  @override
  State<DataDelete> createState() => _DataDeleteState();
}

class _DataDeleteState extends State<DataDelete> {
  bool isChecked = false;
  var notesUid =[];
  int selectedItemCounts=0 ;
  var itemID=StringBuffer();


  // bool isSelectAll = false;
  var flag =[];
  // bool isCheckedAll = false;
  // int? checkID ;
  @override
  void initState() {
    super.initState();
    setFlag("initState");
  }

    setFlag (String whereCalled) {
      for (int i = 0;i< widget.data.length; i++ ){
        if(whereCalled == "initState"){
          flag.add(isChecked);
        }else{
          flag[i] = isChecked;
        }
      }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Navigator.pop(context),icon: const Icon(Icons.close,color: Colors.lightBlue,size: 25,),),

        title: Text(selectedItemCounts >0? "$selectedItemCounts item selected":"Please select items",style: const TextStyle(color: Color(
            0xFF484644),fontSize: 16)),
        actions: [
          Checkbox(value: isChecked, onChanged: (value){
            isChecked = value!;
            setFlag("All-check");
            if(value){
              selectedItemCounts = flag.length;
            }else{
              selectedItemCounts -=flag.length;
            }
            setState(() {

            });
          })
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 10,right: 10),
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFFF3F3F3),
            elevation: 0,
            child: CheckboxListTile(
              title:Container(child:  widget.data[index]['name']!=""? Text('${widget.data[index]['name']}',overflow: TextOverflow.ellipsis,):null,),
              onChanged: (value) {
                flag[index] = value!;
                if(value == false){
                  isChecked = false;
                }
                if( value){
                  selectedItemCounts ++;
                }else{
                  selectedItemCounts--;
                }
                // checkID = widget.data[index]['id'];
                // isCheckedAll !=value;

                setState(() {
                });
              },
              subtitle:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child:widget.data[index]['description']!=""? Text('${widget.data[index]['description']}',overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 14),):null,
                  ),
                  Text("${widget.data[index]['createDate']}",style: const TextStyle(fontSize: 10),),
                ],
              ),
              value :flag[index],
            )
          );
        },
      ),
      bottomSheet: ElevatedButton(
        onPressed: () {
        for( int i =0; i<flag.length ; i++){
          if( flag[i] == true){
            if(i < (flag.length-1)){
              itemID.write("${widget.data[i]['id']},");
            }else{
              itemID.write("${widget.data[i]['id']}");

            }

          }
        }
        showDialog(context: context, builder: (context,)=> AlertDialog(
          title: const Text("Delete the notes?"),
          content: Text("Are you sure to delete the $selectedItemCounts note"),
          actions: [
            TextButton(onPressed: (){
              itemID = StringBuffer();
              Navigator.pop(context);
            }, child:const Text("Cancel")),
            TextButton(onPressed: (){
             var itemIDs = itemID.toString();
              DBHelper.deleteData(table, itemIDs);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()), (route) => false);
            }, child:const Text("Delete")),
          ],
        ));

      },
        style: ElevatedButton.styleFrom(
          backgroundColor:  Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 5),
          shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
          )

        ),
        child:  SizedBox(
          width: MediaQuery.sizeOf(context).width,
            child: const Icon(Icons.delete,size: 50,color: Color(0xFF85807C),)),

      ),
    );
  }

}
