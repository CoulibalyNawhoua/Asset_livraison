import 'package:flutter/material.dart';


class SelectInput extends StatelessWidget {
  
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final Function(String?)? onChanged;
  final String hint;
  final String? Function(String?)? validator;

  const SelectInput({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint, 
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      value: value,
      items: items,
      onChanged: onChanged,
      hint: Text(hint),
      validator: validator,
    );
  }
}
