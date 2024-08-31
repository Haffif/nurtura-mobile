import 'package:flutter/material.dart';
import 'package:nurtura/theme/colors.dart';

class DetailButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DetailButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor, // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Rounded edges
        ),
        padding: EdgeInsets.symmetric(horizontal: 24), // Button padding
      ),
      child: Text('Detail', style: TextStyle(color: Colors.white)), // Button text
    );
  }
}
