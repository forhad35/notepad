import 'package:flutter/material.dart';

import '../core/database.dart';
import 'dataView.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> data = [];

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
  @override
  Widget build(BuildContext context) {
    setState(() {
      fetchData();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes",),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          padding: EdgeInsets.only(left: 10,right: 10),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Card(
              color: Color(0xFFF3F3F3),
              elevation: 0,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewUpdate(desc: data[index]['description'], title: data[index]['name'],id: data[index]['id'],)));
                },
                child: ListTile(
                  title: data[index]['name']!=""? Text('${data[index]['name']}'):null,
                  trailing: IconButton(onPressed: (){
                    DBHelper.deleteData(table, data[index]['id']);
                    setState(() {
                      fetchData();
                    });
                  },icon: Icon(Icons.delete),),
                  subtitle:data[index]['description']!=""? Text('${data[index]['description']}'):null,
                  // leading: Text(' ${data[index]['id']} '),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.large(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewUpdate()));
      },
        backgroundColor:Colors.lightBlue,
        child: Icon(Icons.add,color: Colors.white,),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),

      ),
    );
  }
}
