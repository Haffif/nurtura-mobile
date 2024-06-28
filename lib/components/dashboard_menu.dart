import 'package:flutter/material.dart';
import 'package:nurtura_grow/theme/colors.dart';

class DashboardMenu extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Icon icon;

  const DashboardMenu({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Center(
            child: Container(
              height: 80,
              width: 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(2)
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon,
                  ],
                )
              )
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
          )
        ],
      ),
    );
  }
}
