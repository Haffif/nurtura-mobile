import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurtura_grow/components/app_name.dart';
import 'package:nurtura_grow/components/auth_button.dart';
import 'package:nurtura_grow/theme/colors.dart';
import 'package:nurtura_grow/theme/text_styles.dart';
import '../services/auth_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nama = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('user_nama') ?? 'N/A';
      _email = prefs.getString('user_email') ?? 'N/A';
    });
  }

  void _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                    onPressed: _loadUserInfo,
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Profil',
                        style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nama',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: _nama,
                                  hintStyle: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Email',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: _email,
                                  hintStyle: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                          child: AuthButton(
                              text: 'Keluar',
                              onPressed: _signOut,
                              color: const Color(0xFFD30101)
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
