import 'package:flutter/material.dart';
import 'package:note_pads/helper_widget/image_convater.dart';
import 'package:note_pads/pages/data_delete.dart';
import '../core/database.dart';
import 'data_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 static List<Map<String, dynamic>> data = [];
  bool isChecked = false;
  // bool isCheckedAll = false;
  // int? checkID ;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> result = await DBHelper.getData(table);
    setState(() {
      data = result;
    });
  }
  bool showCheckBox = false;
  @override
  Widget build(BuildContext context) {
    setState(() {
      fetchData();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes",),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(left: 10,right: 10),
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
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ViewUpdate()));

      },
        backgroundColor:Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        child: const Icon(Icons.add,color: Colors.white,),

      ),
    );
  }
}
