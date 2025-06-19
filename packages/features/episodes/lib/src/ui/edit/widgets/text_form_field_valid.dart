import 'package:flutter/material.dart';

class TextFormFieldValid extends StatefulWidget {
  final String value;
  final String hint;
  final bool autocorrect;
  final String? Function(String?)? onCheckText;
  final Function(String) onChanged;

  const TextFormFieldValid({
    super.key,
    required this.value,
    required this.hint,
    this.autocorrect = false,
    this.onCheckText,
    required this.onChanged,
  });

  @override
  State<TextFormFieldValid> createState() => _TextFormFieldValidState();
}

class _TextFormFieldValidState extends State<TextFormFieldValid> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant TextFormFieldValid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.value;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hint,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: const OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
        autocorrect: widget.autocorrect,
        validator: widget.onCheckText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: widget.onChanged,
      ),
    );
  }
}
