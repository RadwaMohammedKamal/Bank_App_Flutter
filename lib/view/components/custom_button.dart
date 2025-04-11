import 'package:flutter/material.dart';
import '../constants/color.dart';

class CustomButton extends StatelessWidget{
   CustomButton({this.onTap,required this.text});
String text;
VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:onTap ,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            color:rmaincolor,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
            child:
        Text(text,style: TextStyle(fontSize: 20,color: Colors.white),)),),
    ) ;
  }
}

Widget DefoultTextButtom({required VoidCallback onpressed,required String text,Color color=Colors.black})=>
    TextButton(onPressed: onpressed, child: Text(text.toUpperCase(),style: TextStyle(color: color),));