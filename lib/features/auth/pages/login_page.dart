import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:luarsekolah/shared/widgets/InputFieldLogin.dart';
import '../../../shared/widgets/CustomButton.dart';
import '../../../../core/constants/app_routes.dart';
import './register_page.dart';
import '../../../../main_navigation.dart';
import '../../../../core/services/local_storage_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRobotChecked = false;
  bool _isLoading = false;

  // Validator form_field_validator
  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email tidak boleh kosong'),
    EmailValidator(errorText: 'Format email tidak valid'),
  ]);

  final _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password tidak boleh kosong'),
    MinLengthValidator(6, errorText: 'Password minimal 6 karakter'),
  ]);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validation form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validation reCAPTCHA
    if (!_isRobotChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon centang "I\'m not a robot"'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Set loading state
    setState(() => _isLoading = true);

    try {
      // Get data from SharedPreferences
      final storedEmail = await LocalStorageService.getUserEmail();
      final storedPassword = await LocalStorageService.getUserPassword();

      // Input from user
      final inputEmail = _emailController.text.trim();
      final inputPassword = _passwordController.text;

      // Validate if user is registered
      if (storedEmail == null || storedPassword == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Akun tidak ditemukan. Silakan daftar terlebih dahulu.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Validate email and password
      if (inputEmail == storedEmail && inputPassword == storedPassword) {
        // Login success - set login status
        await LocalStorageService.setLoginStatus(true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login berhasil!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to home page
          Navigator.pushAndRemoveUntil(
            context,
            AppRoutes.fadeTransition(const MainNavigation()),
            (route) => false,
          );
        }
      } else {
        // Login failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email atau password salah'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/logo.png', height: 40),
                  const SizedBox(height: 40),
                  Text(
                    'Masuk ke Akunmu Untuk Lanjut Akses ke Luarsekolah',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Satu akun untuk akses Luarsekolah dan BelajarBekerja',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7B7F95),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Btn Login Google
                  CustomButton(
                    text: 'Masuk dengan Google',
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    borderColor: const Color(0xFF3F3F4B),
                    height: 38,
                    fontSize: 14,
                    icon: Image.asset(
                      'assets/icons/ic_google.png',
                      height: 20,
                      width: 20,
                    ),
                    onPressed: () {
                      /* handle Google login */
                    },
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      '------------- atau gunakan email -------------',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3F3F4B),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Email Field
                  InputFieldLogin(
                    label: 'Email',
                    hintText: 'Masukkan email terdaftar',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: _emailValidator,
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  InputFieldLogin(
                    label: 'Password',
                    hintText: 'Masukkan password',
                    isPassword: true,
                    controller: _passwordController,
                    validator: _passwordValidator,
                  ),

                  const SizedBox(height: 8),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lupa password',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // reCAPTCHA Checkbox
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFD3D3D3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _isRobotChecked,
                            onChanged: (value) {
                              setState(() {
                                _isRobotChecked = value ?? false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            side: const BorderSide(
                              color: Color(0xFF3F3F4B),
                              width: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'I\'m not a robot',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.network(
                              'https://www.gstatic.com/recaptcha/api2/logo_48.png',
                              height: 30,
                              width: 30,
                            ),
                            Text(
                              'reCAPTCHA',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Privacy - Terms',
                              style: GoogleFonts.inter(
                                fontSize: 8,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  CustomButton(
                    text: _isLoading ? 'Memproses...' : 'Masuk',
                    backgroundColor: const Color(0xFF077E60),
                    textColor: Colors.white,
                    onPressed: _isLoading ? null : _handleLogin,
                  ),

                  const SizedBox(height: 24),

                  // Button Regis
                  CustomButton(
                    text: '',
                    backgroundColor: const Color(0xFFEFF5FF),
                    borderColor: const Color(0xFF2570EB),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        AppRoutes.slideTransition(const RegisterPage()),
                      );
                    },
                    customContent: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('👋', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Daftar Sekarang',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF2570EB),
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
