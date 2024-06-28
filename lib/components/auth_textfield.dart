import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final bool obscureText;
  final String hintText;
  final controller;

  const AuthTextField({
    super.key,
    required this.obscureText,
    required this.hintText,
    required this.controller,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        filled: true,
        fillColor: const Color(0xFFF7F8F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        suffixIcon: widget.obscureText
            ? IconButton(
          onPressed: _toggleObscureText,
          icon: Icon(
            _obscureText
                ? Icons.visibility_off
                : Icons.visibility,
            color: const Color(0xFFA0A3B1),
          ),
        )
            : null,
      ),
      obscureText: _obscureText,
    );
  }
}
