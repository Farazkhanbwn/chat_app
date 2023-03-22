import 'package:flutter/material.dart';

class ReusableTextFormField extends StatelessWidget {
  final String? hint;
  final String? label;
  final String initialValue;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool autofocus;

  ReusableTextFormField({
    @required this.hint,
    @required this.label,
    @required this.validator,
    @required this.onSaved,
    this.initialValue = '',
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: label, hintText: hint, border: const OutlineInputBorder()),
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofocus: autofocus,
    );
  }
}
