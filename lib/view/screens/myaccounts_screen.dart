import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import '../components/customAppbar.dart';
import '../constants/color.dart';
import 'details_screen.dart';
import 'package:intl/intl.dart';

class MyAccounts extends StatefulWidget {
  const MyAccounts({super.key, required this.changeTab});

  final void Function(int index) changeTab;

  @override
  State<MyAccounts> createState() => _MyAccountsState();
}

class _MyAccountsState extends State<MyAccounts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _removeBankAccount(int index) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userDocRef = _firestore.collection('users').doc(user.uid);
      final snapshot = await userDocRef.get();
      final userData = snapshot.data() as Map<String, dynamic>?;
      final List<dynamic>? banksData = userData?['banks'];

      if (banksData != null && index >= 0 && index < banksData.length) {
        final bankToRemove = banksData[index];
        try {
          await userDocRef.update({
            'banks': FieldValue.arrayRemove([bankToRemove]),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bank account removed successfully!')),
          );
        } catch (e) {
          print("Error removing bank account: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to remove bank account.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      backgroundColor: rbackgroundcolor,
      appBar: const CustomAppBar(title: "My Accounts"),
      body: user == null
          ? const Center(child: Text("Not logged in"))
          : StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error fetching data: ${snapshot.error}"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userData = snapshot.data?.data() as Map<String, dynamic>?;
                final List<dynamic>? banksData = userData?['banks'];

                if (banksData == null || banksData.isEmpty) {
                  return const Center(
                      child: Text(
                          "No bank accounts added yet. Click '+' to add one."));
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: banksData.length,
                  itemBuilder: (context, index) {
                    final bank = banksData[index] as Map<String, dynamic>;
                    return CustomBankCard(
                      bankName: bank['bankName'] as String?,
                      balance: bank['amount'] != null
                          ? (bank['amount'] as num).toStringAsFixed(2)
                          : '0.00',
                      percentage: bank['percentage'] != null
                          ? (bank['percentage'] as num).toStringAsFixed(2)
                          : '0',
                      startDate: bank['startDate'] != null
                          ? (bank['startDate'] as Timestamp).toDate()
                          : null,
                      endDate: bank['endDate'] != null
                          ? (bank['endDate'] as Timestamp).toDate()
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AccountDetailsScreen(bankDetails: bank),
                          ),
                        );
                      },
                      onRemove: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm Removal"),
                              content: const Text(
                                  "Are you sure you want to remove this bank account?"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  child: const Text("Remove"),
                                  onPressed: () {
                                    _removeBankAccount(index);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

class CustomBankCard extends StatelessWidget {
  const CustomBankCard({
    super.key,
    this.bankName,
    this.balance,
    this.percentage,
    this.startDate,
    this.endDate,
    this.onTap,
    this.onRemove,
  });

  final String? bankName;
  final String? balance;
  final String? percentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Card(
            //card color
            color: Color(0xffd4d7f3),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bankName ?? "Bank Name Not Available",
                          style: const TextStyle(
                            color: Color(0xff3C0061),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Balance: $balance",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        if (percentage != null &&
                            startDate != null &&
                            endDate != null)
                          Text(
                            "Interest: $percentage%, Start: ${DateFormat('yyyy-MM-dd').format(startDate!)}, End: ${DateFormat('yyyy-MM-dd').format(endDate!)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (onRemove != null)
                    IconButton(
                      icon: const Icon(Icons.delete_forever,
                          color: Colors.redAccent),
                      onPressed: onRemove,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
