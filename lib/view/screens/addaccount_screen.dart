import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/customAppbar.dart';
import '../components/custom_button.dart';
import '../components/custom_text_form_field.dart';
import '../constants/color.dart';
import 'package:intl/intl.dart';

class AddAccount extends StatefulWidget {
  final Function(int) changeTab;

  const AddAccount({super.key, required this.changeTab});
  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final List<String> banks = [
    "Select Bank",
    "Banque Misr",
    "National Bank of Egypt",
    "Egyptian Arab Land Bank",
    "Agricultural Bank of Egypt",
    "Industrial Development Bank",
    "Banque Du Caire",
    "The United Bank",
    "Bank of Alexandria",
    "MIDBank S.A. E",
    "Qatar National Bank Alahli S.A.E",
    "Commercial International Bank (CIB)",
    "Attijariwafa bank Egypt S.A.E",
    "Societe Arabe Internationale de Banque",
    "Credit Agricole Egypt S.A.E",
    "Emirates National Bank of Dubai S.A.E.",
    "Suez Canal Bank",
    "Arab Investment Bank",
    "AL Ahli Bank of Kuwait",
    "First Abu Dhabi Bank - Misr",
    "Ahli United Bank ",
    "Faisal Islamic Bank of Egypt",
    "Housing and Development Bank",
    "Al Baraka Bank of Egypt S.A.E",
    "National Bank ofKuwait (NBK)",
    "Abu Dhabi Islamic Bank",
    "ABU DHABI COMMERCIAL BANK",
    "Egyptian Gulf Bank",
    "Arab African International Bank",
    "HSBC Bank Egypt S.A.E",
    "Arab Banking Corporation",
    "Export Development Bank of Egypt",
    "Arab International Bank",
    "Citi Bank N A / Egypt" ,
    "Arab Bank PLC",
    "Mashreq Bank",
    "National Bank of Greece",
    "Standard Chartered Bank",
  ];
  String? selectedBank;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _addBankAccount() async {
    if (_formKey.currentState!.validate() && selectedBank != "Select Bank" && startDate != null && endDate != null) {
      try {
        final User? user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).update({
            'banks': FieldValue.arrayUnion([
              {
                'bankName': selectedBank,
                'amount': double.parse(amountController.text),
                'percentage': double.parse(percentageController.text),
                'startDate': startDate,
                'endDate': endDate,
                'createdAt': Timestamp.now(),
              }
            ]),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bank account added successfully!')),
          );
          widget.changeTab(0); // Go back to My Accounts
        }
      } catch (e) {
        print("Error adding bank account: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add bank account.')),
        );
      }
    } else if (selectedBank == "Select Bank") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bank.')),
      );
    } else if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rbackgroundcolor,
      appBar: const CustomAppBar(title: "Add Account"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Bank",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  value: selectedBank,
                  items: banks.map((String bank) {
                    return DropdownMenuItem<String>(
                      value: bank,
                      child: Text(bank),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedBank = newValue!;
                    });
                  },
                  validator: (value) => value == null || value == "Select Bank" ? "You must choose the bank." : null,
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CustomTextFormField(
                        labelText: "Enter the amount",
                        hintText: "0.00",
                        prefixIconColor: rmaincolor,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.attach_money,
                        controller: amountController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the amount";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: CustomTextFormField(
                        labelText: "Percentage",
                        hintText: "0",
                        prefixIconColor: rmaincolor,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.percent,
                        controller: percentageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the percentage.";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          final percentage = double.tryParse(value);
                          if (percentage != null && (percentage < 0 || percentage > 100)) {
                            return "Percentage must be between 0 and 100.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: Icon(Icons.calendar_today, color: rmaincolor),
                            ),
                            readOnly: true,
                            controller: TextEditingController(text: startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : ''),
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  startDate = pickedDate;
                                  if (endDate != null && endDate!.isBefore(startDate!)) {
                                    endDate = null; // Reset end date if start date changes
                                  }
                                });
                              }
                            },
                            validator: (value) {
                              if (startDate == null) {
                                return 'Please select the start date';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: Icon(Icons.calendar_today, color: rmaincolor),
                            ),
                            readOnly: true,
                            controller: TextEditingController(text: endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : ''),
                            onTap: () async {
                              if (startDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please select the start date first.')),
                                );
                                return;
                              }
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: startDate!.add(const Duration(days: 1)),
                                firstDate: startDate!.add(const Duration(days: 1)),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  endDate = pickedDate;
                                });
                              }
                            },
                            validator: (value) {
                              if (endDate == null) {
                                return 'Please select the end date';
                              }
                              if (startDate != null && endDate != null && endDate!.isBefore(startDate!)) {
                                return 'End date cannot be before start date';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Center(
                  child: CustomButton(
                    onTap: _addBankAccount,
                    text: 'Add Account',
                  ),
                ),
                Center(
                  child: Image.asset('assets/images/Na_Nov_15.jpg' ,
                    height: 250,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}