import 'package:flutter/material.dart';
import 'package:note_pads/pages/data_delete.dart';
import '../core/database.dart';
import 'data_view.dart';

class SearchData extends StatefulWidget {
  const SearchData({super.key});

  @override
  State<SearchData> createState() => _SearchDataState();
}
class _SearchDataState extends State<SearchData> {
  static List<Map<String, dynamic>> data = [];
  bool isChecked = false;
  var search = TextEditingController();
  bool showCheckBox = false;
  bool clearBtn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: const Icon(Icons.close,color: Colors.lightBlue,size: 30,),),
        title:Transform.translate(
          offset: const Offset(-10,0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 40,
            child: TextFormField(
              controller: search,
              autofocus: true,
              onChanged:(value) async{
                if(search.text.isNotEmpty) {
                  List<Map<String, dynamic>> result = await DBHelper.searchData(search.text);
                  setState(() {
                    data = result;
                  });

                  clearBtn = true;
                }else{
                  clearBtn = false;
                  data=[];
                  setState(() {

                  });
                }
              },
              decoration:  InputDecoration(
                prefixIcon: const Icon(Icons.search,size: 22,),
                prefixIconColor: Colors.grey,
                hintText: "Search notes",
                hintStyle: const TextStyle(
                  color: Colors.grey
                ),
                isDense: true,
                contentPadding: const EdgeInsets.all(5),
                border: InputBorder.none,
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                suffixIcon:clearBtn? IconButton(
                  icon: const Icon(Icons.close,size: 22,),
                  onPressed: () {
                     search.clear();
                     data=[];
                     clearBtn= false;
                     setState(() {

                     });
                  },
                ):null,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),

                ),

                ),
          ),
        ),

    ),
    body: Container(
    height: MediaQuery.sizeOf(context).height,
    width: MediaQuery.sizeOf(context).width,
    padding: const EdgeInsets.only(left: 10,right: 10),
    child: ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
    return Card(
    color: const Color(0xFFF3F3F3),
    elevation: 0,
    child: InkWell(
    onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewUpdate(desc: data[index]['description'], title: data[index]['name'],id: data[index]['id'],createDate: data[index]['createDate'],modifyDate: data[index]['modifyDate'],)));
    },
    onLongPress: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>DataDelete(data: data,)));
    },
    child: ListTile(
    title:Container(child:  data[index]['name']!=""? Text('${data[index]['name']}',overflow: TextOverflow.ellipsis,):null,),

    subtitle:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
    child:data[index]['description']!=""? Text('${data[index]['description']}',overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 14),):null,
    ),
    Text("${data[index]['createDate']}",style: const TextStyle(fontSize: 10),),
    ],
    ),

    // leading: Text(' ${data[index]['id']} '),
    ),
    ),
    );
    },
        ),
      ),
    );
  }
}
