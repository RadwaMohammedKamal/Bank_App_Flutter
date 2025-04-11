import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../screens/login_screen.dart';
import 'navigate.dart';
import 'show_toaster.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: rmaincolor,
      title: Text(title ,
        style: TextStyle(
          color: rbackgroundcolor,
        fontSize: 30,
          fontWeight: FontWeight.bold
      ),),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout , color: rbackgroundcolor, size: 30,),
          onPressed: () {
            showtoaster(
                color: greenM,
                msg:'You are logged out.');
           // ScaffoldMessenger.of(context).showSnackBar(
             // const SnackBar(content: Text("You are logged out.")),
         //   );
              navigateAndFinish(context, LoginScreen());
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); //لتعريف Scaffold بارتفاع appbar
}
