import 'package:flutter/material.dart';
import 'package:nurtura_grow/components/app_name.dart';
import 'package:nurtura_grow/screens/lahan/add_lahan.dart';
import 'package:nurtura_grow/screens/manual/tinggi_tanaman.dart';
import 'package:nurtura_grow/screens/penanaman/add_penanaman.dart';
import 'package:nurtura_grow/screens/profile_screens.dart';
import 'package:nurtura_grow/theme/colors.dart';
import 'package:nurtura_grow/theme/text_styles.dart';

import '../components/dropdown_button.dart';

class FeatureScreen extends StatefulWidget {
  const FeatureScreen({super.key});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  void _toProfile() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ProfileScreen()),
    // );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/Logo.png',
                        width: 36,
                      ),
                      const SizedBox(width: 8),
                      const AppName(
                        textSize: 18,
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: _toProfile,
                      icon: const Icon(
                          Icons.person,
                          color: Colors.black87
                      )
                  )
                ],
              ),

            ],
          ),
          backgroundColor: AppColors.primaryColor,
        ),
      body: SafeArea(
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
                    fontWeight: FontWeight.bold
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddLahanScreen()),
                            );
                          },
                        ),
                        CustomDropdownMenuItem(
                          text: 'Tambah Lahan',
                          icon: Icons.add,
                          color: Colors.black87,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddLahanScreen()),
                            );
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
                          color: Colors.black87, onTap: () {  },
                        ),
                        CustomDropdownMenuItem(
                          text: 'Tambah Penanaman',
                          icon: Icons.add,
                          color: Colors.black87, onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddPenanamanScreen()),
                            );
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
                          color: Colors.black87, onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TinggiTanamanScreen()),
                          );
                        },
                        ),
                        CustomDropdownMenuItem(
                          text: 'Pengairan',
                          icon: Icons.water,
                          color: Colors.black87, onTap: () {  },
                        ),
                        CustomDropdownMenuItem(
                          text: 'Pemupukan',
                          icon: Icons.landslide,
                          color: Colors.black87, onTap: () {  },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const DropdownButtonComponent(
                      text: 'Panduan',
                      icon: Icons.book,
                      hasDropdown: false,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
