import 'package:flutter/material.dart';

class TextFormFieldValid extends StatelessWidget {
  final String hint;
  final bool autocorrect;
  final bool isDone;
  final String? Function(String?)? onCheckText;
  final Function(String) onChanged;
  const TextFormFieldValid({
    super.key,
    required this.hint,
    this.autocorrect = false,
    this.isDone = false,
    this.onCheckText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(),
        ),
        textInputAction: isDone ? TextInputAction.done : TextInputAction.next,
        autocorrect: autocorrect,
        validator: onCheckText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
      ),
    );
  }
}
