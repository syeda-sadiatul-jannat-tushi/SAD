import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final controller, keyboardType, label, hint, icon, validator;

  const InputField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hint,
    required this.label,
    required this.icon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,

      validator: validator,
      // obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
    );
  }
}
