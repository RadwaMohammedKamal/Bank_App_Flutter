import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/color.dart';
import 'models.dart';

class NewsDetailScreen extends StatelessWidget {
  final Rx<Article> article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rbackgroundcolor,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          // bottomLeft: Radius.circular(20),
                          // bottomRight: Radius.circular(20),
                          ),
                      child: (article.value.urlToImage != null &&
                              article.value.urlToImage!.trim().isNotEmpty)
                          ? Image.network(
                              article.value.urlToImage!,
                              height: 400,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/404.jpg',
                              height: 400,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 10,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: Transform.translate(
                            offset: Offset(4, 0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 10, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.value.title ?? "No Title available.",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3C0061),
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Published at: ${article.value.publishedAt ?? "Unknown"}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            article.value.content ?? "No content available.",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../components/customAppbar.dart';
// import '../../constants/color.dart';
// import 'models.dart';
//
// class NewsDetailScreen extends StatelessWidget {
//   final Rx<Article> article;
//
//   const NewsDetailScreen({super.key, required this.article});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: rbackgroundcolor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black), // اختاري اللون
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//
//       // appBar: AppBar(
//       //   backgroundColor: rmaincolor,
//       //   title: Text(
//       //     "News Details",
//       //     style: TextStyle(
//       //         color: rbackgroundcolor,
//       //         fontSize: 25,
//       //         fontWeight: FontWeight.bold),
//       //   ),
//       //   centerTitle: false,
//       //   iconTheme: IconThemeData(
//       //     color: Colors.white,
//       //   ),
//       // ),
//
//       // appBar: AppBar(
//       //   title: Obx(() => Text(article.value.title ?? "News Detail")),
//       //   backgroundColor: Color(0xff8085c9),
//       // ),
//       body: Obx(() => Padding(
//             padding:
//                 const EdgeInsets.only(top: 16, bottom: 0, right: 16, left: 16),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (article.value.urlToImage != null)
//                     Card(
//                       elevation: 20,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           article.value.urlToImage!,
//                           height: 300,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   SizedBox(height: 30),
//                   Text(
//                     article.value.title ?? "Unknown",
//                     style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff3C0061)),
//                   ),
//                   SizedBox(height: 20),
//                   Card(
//                     color: rbackgroundcolor,
//                     elevation: 10,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Published at: ${article.value.publishedAt ?? "Unknown"}",
//                             style: TextStyle(fontSize: 18, color: Colors.grey),
//                           ),
//                           SizedBox(height: 12),
//                           Text(
//                             article.value.content ?? "No content available.",
//                             style: TextStyle(fontSize: 20),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }
