// currency_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class CurrencyApiService {
  final String apiKey = 'cda5100ad6ab5dbc1c460d31';
  final String baseUrl = 'https://v6.exchangerate-api.com/v6/';

  Future<CurrencyResponse> getRates(String baseCurrency) async {
    final response = await http.get(
      Uri.parse('$baseUrl$apiKey/latest/$baseCurrency'),
    );

    if (response.statusCode == 200) {
      return CurrencyResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load rates');
    }
  }
}
