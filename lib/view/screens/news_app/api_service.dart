// news_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  final String apiKey = "1ce00f2c87fc48f7bef715b91fd83f86";
  final String baseUrl = "https://newsapi.org/v2/";

  Future<NewsResponse> fetchCurrencyNews(String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/everything?q=$query&apiKey=$apiKey"),
    );

    if (response.statusCode == 200) {
      return NewsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
  }
}
