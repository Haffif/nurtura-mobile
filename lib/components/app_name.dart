import 'package:flutter/material.dart';
import 'package:nurtura/theme/colors.dart';

class AppName extends StatelessWidget {
  final int textSize;
  const AppName({super.key, required this.textSize});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Nurtura',
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize.toDouble(),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Grow',
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: textSize.toDouble(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
