import 'package:flutter/material.dart';
import 'custom_text_form_field.dart';
import '../constants/color.dart';


class DatePickerField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;

  const DatePickerField({
    Key? key,
    required this.labelText,
    this.controller,
  }) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = widget.controller ?? TextEditingController();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      labelText: widget.labelText,
      hintText: "DD-MM-YYYY",
      controller: _dateController,
      prefixIconColor: rmaincolor,
      prefixIcon: Icons.calendar_month_sharp,
      keyboardType: TextInputType.none,
      readOnly: true,
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select a date";
        }
        return null;
      },
    );
  }
}

