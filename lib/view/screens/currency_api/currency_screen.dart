import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../components/customAppbar.dart';
import '../../constants/color.dart';
import 'currency_api_service.dart';
import 'models.dart';
import 'package:get/get.dart';

class CurrencyScreen extends StatelessWidget {
  final Function(int) changeTab;
  CurrencyScreen({super.key, required this.changeTab});
  final RxString selectedCurrency = 'EGP'.obs;
  final Rx<Future<CurrencyResponse>> currencyResponse =
      (CurrencyApiService().getRates('EGP')).obs;
  @override
  Widget build(BuildContext context) {
    final List<String> toCurrencies = [
      "USD",
      "EUR",
      "GBP",
      "INR",
      "EGP",
      "SAR",
      "JPY"
    ];
    return Scaffold(
      appBar: CustomAppBar(title: "Currency Rates"),
      backgroundColor: rbackgroundcolor,
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
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
              child: Obx(() {
                return DropdownButton<String>(
                  value: selectedCurrency.value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedCurrency.value = newValue;
                      currencyResponse.value =
                          CurrencyApiService().getRates(selectedCurrency.value);
                    }
                  },
                  isExpanded: true,
                  underline: SizedBox(),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                  items: toCurrencies
                      .map<DropdownMenuItem<String>>((String value) {
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
                );
              }),
            ),
            SizedBox(height: 20),
            // FutureBuilder to fetch and display currency rates
            Obx(() {
              return FutureBuilder<CurrencyResponse>(
                future: currencyResponse.value,
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
                  } else if (!snapshot.hasData ||
                      snapshot.data!.conversionRates.isEmpty) {
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
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
              );
            }),
          ],
        ),
      ),
    );
  }
}
//1
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import '../../components/customAppbar.dart';
// import '../../constants/color.dart';
// import 'currency_api_service.dart';
// import 'models.dart';
//
// class CurrencyScreen extends StatefulWidget {
//   final Function(int) changeTab;
//
//   const CurrencyScreen({super.key, required this.changeTab});
//   @override
//   _CurrencyScreenState createState() => _CurrencyScreenState();
// }
//
// class _CurrencyScreenState extends State<CurrencyScreen> {
//   late Future<CurrencyResponse> currencyResponse;
//   final List<String> toCurrencies = [
//     "USD",
//     "EUR",
//     "GBP",
//     "INR",
//     "EGP",
//     "SAR",
//     "JPY"
//   ];
//   String selectedCurrency = 'EGP'; // Default currency is set to EGP
//
//   @override
//   void initState() {
//     super.initState();
//     currencyResponse = CurrencyApiService().getRates(selectedCurrency);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: "Currency Rates"),
//       backgroundColor: rbackgroundcolor,
//       body: Padding(
//         padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
//         child: Column(
//           children: [
//             // Dropdown for selecting the currency
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Color(0xff7c8fee),
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 6,
//                     spreadRadius: 3,
//                   ),
//                 ],
//               ),
//               child: DropdownButton<String>(
//                 value: selectedCurrency,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedCurrency = newValue!;
//                     currencyResponse =
//                         CurrencyApiService().getRates(selectedCurrency);
//                   });
//                 },
//                 isExpanded: true,
//                 underline: SizedBox(),
//                 dropdownColor: Colors.white,
//                 icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
//                 items:
//                     toCurrencies.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(
//                       value,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xff353857),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             SizedBox(height: 20),
//             // FutureBuilder to fetch and display currency rates
//             FutureBuilder<CurrencyResponse>(
//               future: currencyResponse,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: SpinKitCircle(
//                       color: Colors.blueAccent,
//                       size: 50.0,
//                     ),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData ||
//                     snapshot.data!.conversionRates.isEmpty) {
//                   return Center(child: Text('No rates available.'));
//                 }
//
//                 final rates = snapshot.data!.conversionRates;
//                 return Expanded(
//                   child: ListView.builder(
//                     itemCount: rates.length,
//                     itemBuilder: (context, index) {
//                       final currency = rates.keys.elementAt(index);
//                       final rate = rates[currency]!;
//                       return Card(
//                         margin: EdgeInsets.symmetric(vertical: 10),
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         color: Color(0xffd4d7f3),
//                         child: ListTile(
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 20),
//                           title: Text(
//                             '$selectedCurrency to $currency',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.deepPurple.shade900,
//                               fontSize: 18,
//                             ),
//                           ),
//                           subtitle: Text(
//                             rate.toStringAsFixed(2),
//                             style: TextStyle(
//                               color: Colors.deepPurple.shade900,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
