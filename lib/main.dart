import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'view/constants/color.dart';
import 'view/screens/splash_screen.dart';
import 'view/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

//without rep/// ////
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(seconds: 900), () {
      if (!LoginScreen.isLoginScreenOpened) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: const Text(
                  "Session Expired",
                  style: TextStyle(
                      color: Color(0xff3C0061), fontWeight: FontWeight.bold),
                ),
                content: const Text(
                    "Your session has expired. Please log in again."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.offAll(() => const SplashScreen());
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(
                          color: RED_COLOR, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const SplashScreen());
      });
    }
  }

  //@override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banks Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: rmaincolor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

//first//////////
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'view/constants/color.dart';
// import 'view/screens/splash_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Banks Manager',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: rmaincolor),
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }

// // //
/// rep
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   bool isSessionExpired = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     startSessionTimer();
//   }
//
//   void startSessionTimer() {
//     Future.delayed(const Duration(seconds: 30), () {
//       if (!LoginScreen.isLoginScreenOpened) {
//         setState(() {
//           isSessionExpired = true;
//         });
//         showDialog(
//           context: Get.context!,
//           barrierDismissible: false,
//           builder: (context) {
//             return WillPopScope(
//               onWillPop: () async => false,
//               child: AlertDialog(
//                 title: const Text(
//                   "Session Expired",
//                   style: TextStyle(
//                       color: Color(0xff3C0061), fontWeight: FontWeight.bold),
//                 ),
//                 content: const Text(
//                     "Your session has expired. Please log in again."),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       Get.offAll(() => const LoginScreen());
//                     },
//                     child: const Text(
//                       "OK",
//                       style: TextStyle(
//                           color: RED_COLOR, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }
//       if (!LoginScreen.isLoginScreenOpened) {
//         startSessionTimer();
//       }
//     });
//   }
//
//   // @override
//   // void dispose() {
//   //   WidgetsBinding.instance.removeObserver(this);
//   //   super.dispose();
//   // }
//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   if (state == AppLifecycleState.resumed) {
//   //     WidgetsBinding.instance.addPostFrameCallback((_) {
//   //       Get.offAll(() => const SplashScreen());
//   //     });
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Banks Manager',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: rmaincolor),
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }
