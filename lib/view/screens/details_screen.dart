import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constants/color.dart';
import 'package:intl/intl.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key, required this.bankDetails});

  final Map<String, dynamic> bankDetails;

  int _calculateBankDays(DateTime startDate, DateTime endDate) {
    int d1 = startDate.day;
    int d2 = endDate.day;
    int m1 = startDate.month;
    int m2 = endDate.month;
    int y1 = startDate.year;
    int y2 = endDate.year;

    if (d1 == 31) d1 = 30;
    if (d2 == 31 && d1 == 30) d2 = 30;

    return (y2 - y1) * 360 + (m2 - m1) * 30 + (d2 - d1);
  }

  double _calculateBankInterest(
      double principal, double rate, DateTime startDate, DateTime endDate) {
    final days = _calculateBankDays(startDate, endDate);
    final years = days / 360;
    return principal * pow(1 + rate, years) - principal;
  }

  @override
  Widget build(BuildContext context) {
    final String? bankName = bankDetails['bankName'] as String?;
    final double? initialBalance = bankDetails['amount'] as double?;
    final double? percentage = bankDetails['percentage'] as double?;
    final DateTime? startDate = (bankDetails['startDate'] as dynamic)?.toDate();
    final DateTime? endDate = (bankDetails['endDate'] as dynamic)?.toDate();
    final DateTime createdAt =
        (bankDetails['createdAt'] as dynamic)?.toDate() ?? DateTime.now();

    final DateTime now = DateTime.now();

    double calculatedInterest = 0;
    double currentBalance = initialBalance ?? 0;
    double projectedFinalBalance = initialBalance ?? 0;
    DateTime? finalBalanceAt;
    double? finalBalanceValue;

    if (initialBalance != null &&
        percentage != null &&
        startDate != null &&
        endDate != null) {
      final double annualInterestRate = percentage / 100;

      final double interestFull = _calculateBankInterest(
          initialBalance, annualInterestRate, startDate, endDate);

      projectedFinalBalance = initialBalance + interestFull;

      if (now.isAfter(endDate) || now.isAtSameMomentAs(endDate)) {
        calculatedInterest = interestFull;
        currentBalance = projectedFinalBalance;
        finalBalanceAt = endDate;
        finalBalanceValue = projectedFinalBalance;
      } else if (now.isAfter(startDate)) {
        final double interestUntilNow = _calculateBankInterest(
            initialBalance, annualInterestRate, startDate, now);
        currentBalance = initialBalance + interestUntilNow;
        calculatedInterest = interestUntilNow;
      } else {
        calculatedInterest = 0;
        currentBalance = initialBalance;
      }

      calculatedInterest = double.parse(calculatedInterest.toStringAsFixed(2));
      currentBalance = double.parse(currentBalance.toStringAsFixed(2));
      projectedFinalBalance =
          double.parse(projectedFinalBalance.toStringAsFixed(2));
    }

    final double principal = initialBalance ?? 0;
    final double interest = calculatedInterest;
    final double total = principal + interest;

    return Scaffold(
      backgroundColor: rbackgroundcolor,
      appBar: AppBar(
        backgroundColor: rmaincolor,
        title: Text(
          "${bankName ?? 'Account'} Details",
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(bankName ?? "Account Details",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: rmaincolor)),
                  const SizedBox(height: 8),
                  Text(
                      "Created on: ${DateFormat('yyyy-MM-dd').format(createdAt)}",
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                      "Initial Balance",
                      "${initialBalance?.toStringAsFixed(2) ?? 'N/A'} EGP",
                      Icons.account_balance_wallet),
                  const Divider(thickness: 1),
                  _buildDetailRow(
                      "Final Balance",
                      "${projectedFinalBalance.toStringAsFixed(2)} EGP",
                      Icons.attach_money,
                      valueColor: Colors.green),
                  const Divider(thickness: 1),
                  _buildDetailRow(
                      "Interest Rate",
                      "${percentage?.toStringAsFixed(2) ?? 'N/A'}%",
                      Icons.percent),
                  const Divider(thickness: 1),
                  _buildDetailRow(
                      "Start Date",
                      startDate != null
                          ? DateFormat('yyyy-MM-dd').format(startDate)
                          : 'N/A',
                      Icons.calendar_today),
                  const Divider(thickness: 1),
                  _buildDetailRow(
                      "End Date",
                      endDate != null
                          ? DateFormat('yyyy-MM-dd').format(endDate)
                          : 'N/A',
                      Icons.calendar_today),
                  const Divider(thickness: 1),
                  _buildDetailRow(
                      "Calculated Interest",
                      "${calculatedInterest.toStringAsFixed(2)} EGP",
                      Icons.trending_up,
                      valueColor: Colors.blueAccent),
                  const Divider(thickness: 1),
                  _buildDetailRow("Current Balance",
                      "${currentBalance.toStringAsFixed(2)} EGP", Icons.money,
                      valueColor: rmaincolor),
                  const Divider(thickness: 1),
                  if (finalBalanceAt != null && finalBalanceValue != null)
                    _buildDetailRow(
                        "Final Balance at",
                        "${DateFormat('yyyy-MM-dd HH:mm:ss').format(finalBalanceAt)} - ${finalBalanceValue.toStringAsFixed(2)} EGP",
                        Icons.timer,
                        valueColor: rmaincolor),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Account Overview",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 30,
                        sections: [
                          PieChartSectionData(
                              value: principal,
                              title: "",
                              color: Colors.green.shade400,
                              radius: 50),
                          if (interest > 0)
                            PieChartSectionData(
                                value: interest,
                                title: "",
                                color: Colors.blueAccent.shade400,
                                radius: 50),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildChartIndicator(
                          color: Colors.green.shade400,
                          text:
                              "Balance (${total > 0 ? (principal / total * 100).toStringAsFixed(1) : '0'}%)"),
                      if (interest > 0)
                        _buildChartIndicator(
                            color: Colors.blueAccent.shade400,
                            text:
                                "Interest (${total > 0 ? (interest / total * 100).toStringAsFixed(1) : '0'}%)"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: valueColor ?? Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartIndicator({required Color color, required String text}) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

//comp
// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import '../constants/color.dart';
// import 'package:intl/intl.dart';
//
// class AccountDetailsScreen extends StatelessWidget {
//   const AccountDetailsScreen({super.key, required this.bankDetails});
//
//   final Map<String, dynamic> bankDetails;
//
//   double _calculateBankInterest(
//       double principal, double rate, DateTime startDate, DateTime endDate) {
//     final days = endDate.difference(startDate).inDays;
//     final years = days / 360;
//     return principal * pow(1 + rate, years) - principal;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final String? bankName = bankDetails['bankName'] as String?;
//     final double? initialBalance = bankDetails['amount'] as double?;
//     final double? percentage = bankDetails['percentage'] as double?;
//     final DateTime? startDate = (bankDetails['startDate'] as dynamic)?.toDate();
//     final DateTime? endDate = (bankDetails['endDate'] as dynamic)?.toDate();
//     final DateTime createdAt =
//         (bankDetails['createdAt'] as dynamic)?.toDate() ?? DateTime.now();
//
//     final DateTime now = DateTime.now();
//
//     double calculatedInterest = 0;
//     double currentBalance = initialBalance ?? 0;
//     double projectedFinalBalance = initialBalance ?? 0;
//     DateTime? finalBalanceAt;
//     double? finalBalanceValue;
//
//     if (initialBalance != null &&
//         percentage != null &&
//         startDate != null &&
//         endDate != null) {
//       final double annualInterestRate = percentage / 100;
//
//       final int totalDays = endDate.difference(startDate).inDays;
//       final double totalYears = totalDays / 360;
//
//       projectedFinalBalance =
//           initialBalance * pow(1 + annualInterestRate, totalYears);
//
//       if (now.isAfter(endDate) || now.isAtSameMomentAs(endDate)) {
//         calculatedInterest = projectedFinalBalance - initialBalance;
//         currentBalance = projectedFinalBalance;
//         finalBalanceAt = endDate;
//         finalBalanceValue = projectedFinalBalance;
//       } else if (now.isAfter(startDate)) {
//         final int elapsedDays = now.difference(startDate).inDays;
//         final double elapsedYears = elapsedDays / 360;
//
//         currentBalance =
//             initialBalance * pow(1 + annualInterestRate, elapsedYears);
//         calculatedInterest = currentBalance - initialBalance;
//       } else {
//         calculatedInterest = 0;
//         currentBalance = initialBalance;
//       }
//
//       calculatedInterest = double.parse(calculatedInterest.toStringAsFixed(2));
//       currentBalance = double.parse(currentBalance.toStringAsFixed(2));
//       projectedFinalBalance =
//           double.parse(projectedFinalBalance.toStringAsFixed(2));
//     }
//
//     final double principal = initialBalance ?? 0;
//     final double interest = calculatedInterest;
//     final double total = principal + interest;
//
//     return Scaffold(
//       backgroundColor: rbackgroundcolor,
//       appBar: AppBar(
//         backgroundColor: rmaincolor,
//         title: Text(
//           "${bankName ?? 'Account'} Details",
//           style: const TextStyle(
//               fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                       offset: const Offset(0, 3)),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(bankName ?? "Account Details",
//                       style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: rmaincolor)),
//                   const SizedBox(height: 8),
//                   Text(
//                       "Created on: ${DateFormat('yyyy-MM-dd').format(createdAt)}",
//                       style: TextStyle(color: Colors.grey[600])),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                       offset: const Offset(0, 3)),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildDetailRow(
//                       "Initial Balance",
//                       "${initialBalance?.toStringAsFixed(2) ?? 'N/A'} EGP", // تغيير إلى EGP
//                       Icons.account_balance_wallet),
//                   const Divider(thickness: 1),
//                   _buildDetailRow(
//                       "Final Balance",
//                       "${projectedFinalBalance.toStringAsFixed(2)} EGP",
//                       Icons.attach_money,
//                       valueColor: Colors.green),
//                   const Divider(thickness: 1),
//                   _buildDetailRow(
//                       "Interest Rate",
//                       "${percentage?.toStringAsFixed(2) ?? 'N/A'}%",
//                       Icons.percent),
//                   const Divider(thickness: 1),
//                   _buildDetailRow(
//                       "Start Date",
//                       startDate != null
//                           ? DateFormat('yyyy-MM-dd').format(startDate)
//                           : 'N/A',
//                       Icons.calendar_today),
//                   const Divider(thickness: 1),
//                   _buildDetailRow(
//                       "End Date",
//                       endDate != null
//                           ? DateFormat('yyyy-MM-dd').format(endDate)
//                           : 'N/A',
//                       Icons.calendar_today),
//                   const Divider(thickness: 1),
//                   _buildDetailRow(
//                       "Calculated Interest",
//                       "${calculatedInterest.toStringAsFixed(2)} EGP",
//                       Icons.trending_up,
//                       valueColor: Colors.blueAccent),
//                   const Divider(thickness: 1),
//                   _buildDetailRow("Current Balance",
//                       "${currentBalance.toStringAsFixed(2)} EGP", Icons.money,
//                       valueColor: rmaincolor),
//                   const Divider(thickness: 1),
//                   if (finalBalanceAt != null && finalBalanceValue != null)
//                     _buildDetailRow(
//                         "Final Balance at",
//                         "${DateFormat('yyyy-MM-dd HH:mm:ss').format(finalBalanceAt)} - ${finalBalanceValue.toStringAsFixed(2)} EGP",
//                         Icons.timer,
//                         valueColor: rmaincolor),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                       offset: const Offset(0, 3)),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Account Overview",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     height: 180,
//                     child: PieChart(
//                       PieChartData(
//                         sectionsSpace: 0,
//                         centerSpaceRadius: 30,
//                         sections: [
//                           PieChartSectionData(
//                               value: principal,
//                               title: "",
//                               color: Colors.green.shade400,
//                               radius: 50),
//                           if (interest > 0)
//                             PieChartSectionData(
//                                 value: interest,
//                                 title: "",
//                                 color: Colors.blueAccent.shade400,
//                                 radius: 50),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _buildChartIndicator(
//                           color: Colors.green.shade400,
//                           text:
//                               "Balance (${total > 0 ? (principal / total * 100).toStringAsFixed(1) : '0'}%)"),
//                       if (interest > 0)
//                         _buildChartIndicator(
//                             color: Colors.blueAccent.shade400,
//                             text:
//                                 "Interest (${total > 0 ? (interest / total * 100).toStringAsFixed(1) : '0'}%)"),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value, IconData icon,
//       {Color? valueColor}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey[600]),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label,
//                     style: TextStyle(fontSize: 16, color: Colors.grey[700])),
//                 const SizedBox(height: 4),
//                 Text(value,
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         color: valueColor ?? Colors.black87)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChartIndicator({required Color color, required String text}) {
//     return Row(
//       children: [
//         Container(
//             width: 12,
//             height: 12,
//             decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//         const SizedBox(width: 8),
//         Text(text, style: const TextStyle(fontSize: 14)),
//       ],
//     );
//   }
// }

//simple
// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import '../constants/color.dart';
// import 'package:intl/intl.dart';
//
// class AccountDetailsScreen extends StatelessWidget {
//   const AccountDetailsScreen({super.key, required this.bankDetails});
//
//   final Map<String, dynamic> bankDetails;
//
//   @override
//   Widget build(BuildContext context) {
//     final String? bankName = bankDetails['bankName'] as String?;
//     final double? initialBalance = bankDetails['amount'] as double?;
//     final double? percentage = bankDetails['percentage'] as double?;
//     final DateTime? startDate = (bankDetails['startDate'] as dynamic)?.toDate();
//     final DateTime? endDate = (bankDetails['endDate'] as dynamic)?.toDate();
//     final DateTime createdAt =
//         (bankDetails['createdAt'] as dynamic)?.toDate() ?? DateTime.now();
//
//     final DateTime now = DateTime.now();
//
//     double calculatedInterest = 0;
//     double currentBalance = initialBalance ?? 0;
//     double projectedFinalBalance = initialBalance ?? 0;
//     DateTime? finalBalanceAt;
//     double? finalBalanceValue;
//
//     if (initialBalance != null &&
//         percentage != null &&
//         startDate != null &&
//         endDate != null) {
//       final double annualInterestRate = percentage / 100;
//       final Duration duration = endDate.difference(startDate);
//       final double totalYears = duration.inDays / 365;
//
//       final double interest =
//           initialBalance * pow(1 + annualInterestRate, totalYears) -
//               initialBalance;
//       projectedFinalBalance = initialBalance + interest;
//
//       final double interestPerSecond =
//           annualInterestRate / (365 * 24 * 60 * 60);
//       if (now.isAfter(endDate) || now.isAtSameMomentAs(endDate)) {
//         calculatedInterest = projectedFinalBalance - initialBalance;
//         currentBalance = projectedFinalBalance;
//         finalBalanceAt = endDate;
//         finalBalanceValue = projectedFinalBalance;
//       } else if (now.isAfter(startDate)) {
//         final int secondsElapsed = now.difference(startDate).inSeconds;
//         calculatedInterest =
//             secondsElapsed * interestPerSecond * initialBalance;
//         currentBalance = initialBalance + calculatedInterest;
//       } else {
//         calculatedInterest = 0;
//         currentBalance = initialBalance;
//       }
//     }
//
//     final double principal = initialBalance ?? 0;
//     final double interest = calculatedInterest;
//     final double total = principal + interest;
//
//     return Scaffold(
//       backgroundColor: rbackgroundcolor,
//       appBar: AppBar(
//         backgroundColor: rmaincolor,
//         title: Text(
//           "${bankName ?? 'Account'} Details",
//           style: const TextStyle(
//               fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                       offset: const Offset(0, 3)),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(bankName ?? "Account Details",
//                       style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: rmaincolor)),
//                   const SizedBox(height: 8),
//                   Text(
//                       "Created on: ${DateFormat('yyyy-MM-dd').format(createdAt)}",
//                       style: TextStyle(color: Colors.grey[600])),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                       offset: const Offset(0, 3)),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildDetailRow(
//                       "Initial Balance",
//                       "\$${initialBalance?.toStringAsFixed(3) ?? 'N/A'}",
//                       Icons.account_balance_wallet),
//                   const Divider(thickness: 1),
//                   _buildDetailRow(
//                       "Final Balance",
//                       "\$${projectedFinalBalance.toStringAsFixed(3)}",
//                       Icons.attach_money,
//                       valueColor: Colors.green),
//                   const Divider(thickness: 1),
//                   _buildDetailRow(
//                       "Interest Rate",
//                       "${percentage?.toStringAsFixed(2) ?? 'N/A'}%",
//                       Icons.percent),
//                   const Divider(thickness: 1),
//                   _buildDetailRow(
//                       "Start Date",
//                       startDate != null
//                           ? DateFormat('yyyy-MM-dd').format(startDate)
//                           : 'N/A',
//                       Icons.calendar_today),
//                   const Divider(thickness: 1),
//                   _buildDetailRow(
//                       "End Date",
//                       endDate != null
//                           ? DateFormat('yyyy-MM-dd').format(endDate)
//                           : 'N/A',
//                       Icons.calendar_today),
//                   const Divider(thickness: 1),
//                   _buildDetailRow(
//                       "Calculated Interest",
//                       "\$${calculatedInterest.toStringAsFixed(3)}",
//                       Icons.trending_up,
//                       valueColor: Colors.blueAccent),
//                   const Divider(thickness: 1),
//                   _buildDetailRow("Current Balance",
//                       "\$${currentBalance.toStringAsFixed(3)}", Icons.money,
//                       valueColor: rmaincolor),
//                   const Divider(thickness: 1),
//                   if (finalBalanceAt != null && finalBalanceValue != null)
//                     _buildDetailRow(
//                         "Final Balance at",
//                         "${DateFormat('yyyy-MM-dd HH:mm:ss').format(finalBalanceAt)} - \$${finalBalanceValue.toStringAsFixed(3)}",
//                         Icons.timer,
//                         valueColor: rmaincolor),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                       offset: const Offset(0, 3)),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Account Overview",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     height: 180,
//                     child: PieChart(
//                       PieChartData(
//                         sectionsSpace: 0,
//                         centerSpaceRadius: 30,
//                         sections: [
//                           PieChartSectionData(
//                               value: principal,
//                               title: "",
//                               color: Colors.green.shade400,
//                               radius: 50),
//                           if (interest > 0)
//                             PieChartSectionData(
//                                 value: interest,
//                                 title: "",
//                                 color: Colors.blueAccent.shade400,
//                                 radius: 50),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _buildChartIndicator(
//                           color: Colors.green.shade400,
//                           text:
//                               "Balance (${total > 0 ? (principal / total * 100).toStringAsFixed(1) : '0'}%)"),
//                       if (interest > 0)
//                         _buildChartIndicator(
//                             color: Colors.blueAccent.shade400,
//                             text:
//                                 "Interest (${total > 0 ? (interest / total * 100).toStringAsFixed(1) : '0'}%)"),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value, IconData icon,
//       {Color? valueColor}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey[600]),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label,
//                     style: TextStyle(fontSize: 16, color: Colors.grey[700])),
//                 const SizedBox(height: 4),
//                 Text(value,
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         color: valueColor ?? Colors.black87)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChartIndicator({required Color color, required String text}) {
//     return Row(
//       children: [
//         Container(
//             width: 12,
//             height: 12,
//             decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//         const SizedBox(width: 8),
//         Text(text, style: const TextStyle(fontSize: 14)),
//       ],
//     );
//   }
// }
