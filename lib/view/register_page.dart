import 'package:flutter/material.dart';
import 'package:nurtura/components/app_name.dart';
import 'package:nurtura/components/auth_button.dart';
import 'package:nurtura/components/auth_textfield.dart';
import 'package:nurtura/provider/auth_provider.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:nurtura/view/login_page.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist'
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 20),
                          AuthTextField(
                            obscureText: false,
                            hintText: 'Nama',
                            controller: _nameController,
                          ),
                          const SizedBox(height: 16),
                          AuthTextField(
                            obscureText: false,
                            hintText: 'Username',
                            controller: _usernameController,
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
                          AuthTextField(
                            obscureText: true,
                            hintText: 'Konfirmasi password',
                            controller: _confirmPasswordController,
                          ),
                          const SizedBox(height: 20),
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return authProvider.isLoading
                                  ? const CircularProgressIndicator()
                                  : SizedBox(
                                    width: double.infinity,
                                    child: AuthButton(
                                      text: 'Register',
                                      onPressed: () async {
                                        if (_passwordController.text != _confirmPasswordController.text) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Password tidak sama!'),
                                            ),
                                          );
                                          return;
                                        }
                                        try {
                                          await authProvider.register(
                                            _emailController.text,
                                            _nameController.text,
                                            _passwordController.text,
                                            _usernameController.text,
                                            context,
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Register berhasil!'),
                                            ),
                                          );
                                        } catch (error) {
                                          print('Error: $error');
                                        }
                                      },
                                      color: AppColors.primaryColor,
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
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                  );
                                },
                                child: const Text(
                                  'Sudah memiliki akun?',
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
        ),
      ),
    );
  }
}
