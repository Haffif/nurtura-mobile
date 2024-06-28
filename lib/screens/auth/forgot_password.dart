import 'package:flutter/material.dart';
import 'package:nurtura_grow/components/app_name.dart';
import 'package:nurtura_grow/components/auth_button.dart';
import 'package:nurtura_grow/components/auth_textfield.dart';
import 'package:nurtura_grow/theme/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  void _forgotPassword() {
    // Add forgot password logic here
  }

  void _backToLogin() {
    // Add back to login logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      width: 40,
                    ),
                    const SizedBox(width: 8),
                    const AppName(
                        textSize: 20
                    )
                  ],
                ),
                const SizedBox(height: 20),
                IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist'
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Jangan khawatir! Masukkan alamat email yang ditautkan  dengan akun Anda.',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                            obscureText: false,
                            hintText: 'Email',
                            controller: _emailController,
                        ),
                        const SizedBox(height: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AuthButton(text: 'Login',
                                      onPressed: _forgotPassword,
                                      color: AppColors.primaryColor
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextButton(onPressed: _backToLogin,
                                child: const Text(
                                  'Kembali ke Login',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline
                                  ),
                                  textAlign: TextAlign.center,
                                )
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
