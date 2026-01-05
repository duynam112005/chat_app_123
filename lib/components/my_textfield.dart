import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  const MyTextField({super.key, required this.hintText, required this.obscureText, required this.controller, this.focusNode});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        focusNode: widget.focusNode,
        obscureText: widget.obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary,),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: widget.hintText,
        )
      ),
    );
  }
}
