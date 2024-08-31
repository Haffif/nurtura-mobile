// login_page.dart

import 'package:flutter/material.dart';
import 'package:nurtura/components/auth_button.dart';
import 'package:nurtura/components/auth_textfield.dart';
import 'package:nurtura/provider/auth_provider.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:nurtura/view/auth_screen.dart';
import 'package:nurtura/view/register_page.dart';
import 'package:nurtura/view/startup_screen.dart';
import 'package:provider/provider.dart';

import '../components/app_name.dart';

class LoginPage extends StatelessWidget {
  LoginPage ({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                child: Column(
                  children: [
                    const Text(
                      'Hello, selamat datang kembali!',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist'
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      obscureText: false,
                      hintText: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      obscureText: true,
                      hintText: 'Password',
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return authProvider.isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                              width: double.infinity,
                              child: AuthButton(
                                text: 'Login',
                                onPressed: () async {
                                    try {
                                      await authProvider.login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                      final user = authProvider.user;
                                      final token = authProvider.token;
                                      if (user != null && token != null) {
                                        print('User: $user');
                                        print('Token: $token');
                                        // Navigate to the StartupScreen
                                        final route = MaterialPageRoute(builder: (context) => const StartupScreen());
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const StartupScreen()),
                                        );
                                      } else {
                                        print('Login failed');
                                      }
                                    } catch (error) {
                                      print('Error: $error');
                                    }
                                },
                                color: AppColors.primaryColor, // Set the color you want for the button
                              ),
                            );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                          },
                          child: const Text(
                            'Belum memiliki akun?',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Urbanist',
                              color: Color(0xFF6A707C),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AuthPage()),
                            );
                          },
                          child: const Text(
                            'Lupa password?',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Urbanist',
                              color: Color(0xFF6A707C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
