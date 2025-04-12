import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'currency_api_service.dart';
import 'models.dart';

class CurrencyScreen extends StatefulWidget {
  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  late Future<CurrencyResponse> currencyResponse;
  final List<String> toCurrencies = ["USD", "EUR", "GBP", "INR", "EGP", "SAR", "JPY"];
  String selectedCurrency = 'EGP'; // Default currency is set to EGP

  @override
  void initState() {
    super.initState();
    currencyResponse = CurrencyApiService().getRates(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff616AE6),
        title: Text(
          'Currency Rates',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting the currency
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xff7c8fee),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: selectedCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCurrency = newValue!;
                    currencyResponse = CurrencyApiService().getRates(selectedCurrency);
                  });
                },
                isExpanded: true,
                underline: SizedBox(),
                dropdownColor: Colors.white,
                icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                items: toCurrencies.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff353857),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // FutureBuilder to fetch and display currency rates
            FutureBuilder<CurrencyResponse>(
              future: currencyResponse,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.blueAccent,
                      size: 50.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.conversionRates.isEmpty) {
                  return Center(child: Text('No rates available.'));
                }

                final rates = snapshot.data!.conversionRates;
                return Expanded(
                  child: ListView.builder(
                    itemCount: rates.length,
                    itemBuilder: (context, index) {
                      final currency = rates.keys.elementAt(index);
                      final rate = rates[currency]!;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Color(0xffd4d7f3),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          title: Text(
                            '$selectedCurrency to $currency',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade900,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            rate.toStringAsFixed(2),
                            style: TextStyle(
                              color: Colors.deepPurple.shade900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
