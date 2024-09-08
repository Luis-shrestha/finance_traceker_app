import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final int line;
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? errorText;
  final bool readOnly;
  final FormFieldValidator<String?>? validator;
  final bool obscureText;
  final VoidCallback? suffixIconOnPressed;

  const CustomTextFormField({
    super.key,
    required this.line,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.validator,
    required this.hintText,
    required this.labelText,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixIconOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: line,
      controller: controller,
      style: const TextStyle(
        color: Colors.black,
      ),
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          color: Colors.grey,
        )
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
          icon: Icon(
            suffixIcon,
            color: Colors.grey,
          ),
          onPressed: suffixIconOnPressed,
        )
            : null,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        fillColor: Colors.yellow,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontFamily: "verdana_regular",
          fontWeight: FontWeight.w400,
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontFamily: "verdana_regular",
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
        ),
      ),
      validator: validator,
    );
  }
}
