import 'package:flutter/material.dart';


 Widget  backIcon(BuildContext context, {updateData}){
     return IconButton(onPressed: (){
       updateData;
       Navigator.pop(context);
     },icon: const Icon(Icons.arrow_back,color: Colors.lightBlue,size: 25,),);

   }
