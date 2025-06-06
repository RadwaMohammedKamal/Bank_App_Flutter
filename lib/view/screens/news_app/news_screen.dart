import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../components/customAppbar.dart';
import 'models.dart';
import 'api_service.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  final Function(int) changeTab;

  const NewsScreen({super.key, required this.changeTab});

  @override
  Widget build(BuildContext context) {
    Rx<NewsResponse?> newsResponse = Rx<NewsResponse?>(null);

    ApiService().fetchCurrencyNews("currency OR forex").then((response) {
      newsResponse.value = response;
    });

    return Scaffold(
      appBar: CustomAppBar(title: "Currency News"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffa3a7e0), Color(0xffc0c3ec)],
          ),
        ),
        child: Obx(() {
          if (newsResponse.value == null) {
            return Center(
              child: SpinKitCircle(
                color: Color(0xffa3a7e0),
                size: 50.0,
              ),
            );
          } else if (newsResponse.value!.articles.isEmpty) {
            return Center(child: Text('No news available.'));
          }
          final articles = newsResponse.value!.articles;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Get.to(() => NewsDetailScreen(article: Rx(article)));
                    },
                    title: Text(
                      article.title ?? "No Title",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff8085c9),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: (article.urlToImage != null &&
                                  article.urlToImage!.trim().isNotEmpty)
                              ? Image.network(
                                  article.urlToImage!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/404.jpg',
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 8.0),
                        //   child: Image.network(
                        //     article.urlToImage!,
                        //     height: 150,
                        //     width: double.infinity,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        Text(
                          article.description ?? "No Description Available",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Published at: ${article.publishedAt ?? "Unknown"}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
