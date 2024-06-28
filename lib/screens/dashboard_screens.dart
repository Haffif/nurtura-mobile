import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nurtura_grow/components/app_name.dart';
import 'package:nurtura_grow/components/circular_display.dart';
import 'package:nurtura_grow/components/dashboard_menu.dart';
import 'package:nurtura_grow/screens/feature_screen/map_location_screen.dart';
import 'package:nurtura_grow/screens/feature_screens.dart';
import 'package:nurtura_grow/screens/profile_screens.dart';
import 'package:nurtura_grow/theme/colors.dart';
import 'package:nurtura_grow/theme/text_styles.dart';

class DashboardScreens extends StatefulWidget {
  const DashboardScreens({super.key});

  @override
  State<DashboardScreens> createState() => _DashboardScreensState();
}

class _DashboardScreensState extends State<DashboardScreens> {
  void _toProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Fitur Unggulan',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DashboardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MapLocationScreen()),
                            );
                          },
                          text: 'Deteksi',
                          icon: const Icon(
                            Icons.monitor_heart_outlined,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        DashboardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FeatureScreen()),
                            );
                          },
                          text: 'Pengairan',
                          icon: const Icon(
                            Icons.water,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        DashboardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FeatureScreen()),
                            );
                          },
                          text: 'Pemupukan',
                          icon: const Icon(
                            Icons.landslide,
                            color: Colors.white,
                            size: 48,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Data Sensor Terkini',
                    style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircularDisplay(
                                dataName:'Suhu Udara', progress: 25,
                            ),
                            CircularDisplay(
                                dataName:'Kelembapan Udara', progress: 30,
                            ),
                            CircularDisplay(
                                dataName:'Kelembapan Tanah', progress: 28,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircularDisplay(
                                dataName:'pH Tanah', progress: 29.5,
                            ),
                            CircularDisplay(
                                dataName:'Natrium', progress: 48.5,
                            ),
                            CircularDisplay(
                                dataName:'Fosfor', progress: 100,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircularDisplay(
                                dataName:'Kalium', progress: 8,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
