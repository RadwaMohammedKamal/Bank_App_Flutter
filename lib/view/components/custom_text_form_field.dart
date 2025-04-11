import 'package:flutter/material.dart';
import '../constants/color.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconToggle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.onSuffixIconPressed,
    this.onFieldSubmitted,
    this.keyboardType,
    this.focusNode,
    this.validator,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  final String? hintText, labelText;
  final Color? prefixIconColor, suffixIconColor;
  final IconData? suffixIcon, prefixIcon, suffixIconToggle;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final Function()? onSuffixIconPressed;
  final Function()? onTap;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final bool readOnly;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });

    if (widget.onSuffixIconPressed != null) {
      widget.onSuffixIconPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      validator: widget.validator ??
              (data) {
            if (data?.isEmpty ?? true) return "This field is required.";
            return null;
          },
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        hintStyle: const TextStyle(color: rmaincolor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: rmaincolor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: rmaincolor),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: widget.prefixIconColor)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? widget.suffixIcon : widget.suffixIconToggle,
            color: widget.suffixIconColor ?? rmaincolor,
          ),
          onPressed: _togglePasswordVisibility,
        )
            : (widget.suffixIcon != null
            ? Icon(widget.suffixIcon, color: widget.suffixIconColor)
            : null),
      ),
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
    );
  }
}


