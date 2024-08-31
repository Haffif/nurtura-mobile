// FeaturePage.dart

import 'package:flutter/material.dart';
import 'package:nurtura/components/dropdown_button.dart';
import 'package:nurtura/theme/text_styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/app_name.dart';
import '../theme/colors.dart';

class FeaturePage extends StatelessWidget {
  final Function(int) onPageSelected;

  const FeaturePage({Key? key, required this.onPageSelected}) : super(key: key);

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
              'Daftar Fitur',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 400,
              child: ListView(
                children: [
                  DropdownButtonComponent(
                    text: 'Lahan',
                    icon: Icons.terrain,
                    hasDropdown: true,
                    dropdownItems: [
                      CustomDropdownMenuItem(
                        text: 'Daftar Lahan',
                        icon: Icons.list,
                        color: Colors.black87,
                        onTap: () {
                          onPageSelected(6);
                        },
                      ),
                      CustomDropdownMenuItem(
                        text: 'Tambah Lahan',
                        icon: Icons.add,
                        color: Colors.black87,
                        onTap: () {
                          onPageSelected(7);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonComponent(
                    text: 'Penanaman',
                    icon: Icons.energy_savings_leaf,
                    hasDropdown: true,
                    dropdownItems: [
                      CustomDropdownMenuItem(
                        text: 'Daftar Penanaman',
                        icon: Icons.list,
                        color: Colors.black87,
                        onTap: () {
                          onPageSelected(4); // Navigate to DaftarPenanamanPage
                        },
                      ),
                      CustomDropdownMenuItem(
                        text: 'Tambah Penanaman',
                        icon: Icons.add,
                        color: Colors.black87,
                        onTap: () {
                          onPageSelected(5);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonComponent(
                    text: 'Input Manual',
                    icon: Icons.exit_to_app,
                    hasDropdown: true,
                    dropdownItems: [
                      CustomDropdownMenuItem(
                        text: 'Tinggi Tanaman',
                        icon: Icons.height,
                        color: Colors.black87,
                        onTap: () {
                          onPageSelected(1); // Navigate to ManualTinggiTanamanPage
                        },
                      ),
                      CustomDropdownMenuItem(
                        text: 'Pengairan',
                        icon: Icons.water,
                        color: Colors.black87,
                        onTap: () {
                          onPageSelected(2);
                        },
                      ),
                      CustomDropdownMenuItem(
                        text: 'Pemupukan',
                        icon: Icons.landslide,
                        color: Colors.black87,
                        onTap: () {
                          onPageSelected(3);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const DropdownButtonComponent(
                    text: 'Panduan',
                    icon: Icons.book,
                    hasDropdown: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
