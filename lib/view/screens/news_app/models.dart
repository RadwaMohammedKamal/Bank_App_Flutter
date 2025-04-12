/*
// models.dart

class NewsResponse {
  String status;
  int totalResults;
  List<Article> articles;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['articles'] as List;
    List<Article> articlesList = list.map((i) => Article.fromJson(i)).toList();

    return NewsResponse(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: articlesList,
    );
  }
}

class Article {
  String title;
  String description;
  String? urlToImage;
  String publishedAt;

  Article({
    required this.title,
    required this.description,
    this.urlToImage,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
    );
  }
}
*/


class NewsResponse {
  String status;
  int totalResults;
  List<Article> articles;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['articles'] as List;
    List<Article> articlesList = list.map((i) => Article.fromJson(i)).toList();

    return NewsResponse(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: articlesList,
    );
  }
}

class Article {
  String? title;
  String? description;
  String? urlToImage;
  String? publishedAt;

  Article({
    this.title,
    this.description,
    this.urlToImage,
    this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String?,
      description: json['description'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
    );
  }
}
