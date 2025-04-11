import 'package:flutter/material.dart';

void navigateTo(context,Widget page){
  Navigator.push(context, MaterialPageRoute(
      builder: (context) => page),);
}

void navigateAndFinish(context,Widget page){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) => page,
  ),
      (route) {
      return false;
    },
  );
}