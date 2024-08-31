// history_page.dart

import 'package:flutter/material.dart';
import 'package:nurtura/components/app_name.dart';
import 'package:nurtura/view/profile_page.dart';

import '../theme/colors.dart';
import '../theme/text_styles.dart';

class HistoryPage extends StatefulWidget {
  final void Function(int) onPageSelected;
  const HistoryPage({Key? key, required this.onPageSelected}) : super(key: key);
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void _toProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Riwayat Aksi Alat',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('Pilih riwayat aksi yang ingin dilakukan oleh pengguna'),
              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () => widget.onPageSelected(1),
                icon: Icon(Icons.nature, size: 24),
                label: Text('Tinggi Tanaman', style: AppTextStyles.titleMedium),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: AppColors.primaryColor,
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => widget.onPageSelected(2),
                icon: Icon(Icons.sensors, size: 24),
                label: Text('Data Sensor', style: AppTextStyles.titleMedium),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: AppColors.primaryColor,
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => widget.onPageSelected(3),
                icon: Icon(Icons.build, size: 24),
                label: Text('Aksi Alat', style: AppTextStyles.titleMedium),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: AppColors.primaryColor,
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ]
        ),
      ),
    );
  }
}
