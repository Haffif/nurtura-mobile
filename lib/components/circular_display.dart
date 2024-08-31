import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CircularDisplay extends StatelessWidget {
  final double progress;
  final String dataName;

  const CircularDisplay({
    Key? key,
    required this.progress,
    required this.dataName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: progress / 100,
                color: AppColors.primaryColor,
                backgroundColor: Colors.grey[400],
                strokeWidth: 8.0,
              ),
            ),
            Text(
              '${(progress)}%',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Center(
            child: Text(
              dataName,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
