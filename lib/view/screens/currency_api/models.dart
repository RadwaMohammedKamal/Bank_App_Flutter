// models.dart

class CurrencyResponse {
  final String result;
  final String baseCode;
  final Map<String, double> conversionRates;

  CurrencyResponse({
    required this.result,
    required this.baseCode,
    required this.conversionRates,
  });

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) {
    // Here we handle both int and double values for conversion rates
    Map<String, double> rates = {};
    json['conversion_rates'].forEach((key, value) {
      rates[key] = (value is int) ? value.toDouble() : value.toDouble();
    });

    return CurrencyResponse(
      result: json['result'],
      baseCode: json['base_code'],
      conversionRates: rates,
    );
  }
}
