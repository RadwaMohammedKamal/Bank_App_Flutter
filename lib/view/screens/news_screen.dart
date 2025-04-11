import 'package:flutter/material.dart';

import '../components/customAppbar.dart';
import '../constants/color.dart';

class News extends StatelessWidget {
  const News({super.key, required void Function(int index) changeTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rbackgroundcolor,
      appBar: const CustomAppBar(title: "News" ),

    );
  }
}
