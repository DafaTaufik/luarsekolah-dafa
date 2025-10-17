import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/input_field_register.dart';
import '../../../../core/constants/app_routes.dart';
import './login_page.dart';
import '../../../../main_navigation.dart';
import '../../../../core/services/local_storage_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRobotChecked = false;
  bool _isLoading = false;

  // Validators
  final _nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Nama tidak boleh kosong'),
    MinLengthValidator(3, errorText: 'Nama minimal 3 karakter'),
  ]);

  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email tidak boleh kosong'),
    EmailValidator(errorText: 'Format email tidak valid'),
  ]);

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!value.startsWith('62')) {
      return 'Format nomor harus diawali 62';
    }
    if (value.length < 10) {
      return 'Nomor telepon minimal 10 angka';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung minimal 1 huruf kapital';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung minimal 1 angka';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password harus mengandung minimal 1 karakter simbol';
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isRobotChecked) {
      _showSnackBar('Mohon centang "I\'m not a robot"', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await LocalStorageService.saveUserData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      if (success) {
        _showSnackBar('Registrasi berhasil!', Colors.green);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            AppRoutes.fadeTransition(const MainNavigation()),
            (route) => false,
          );
        }
      } else {
        _showSnackBar('Gagal menyimpan data. Silakan coba lagi.', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/logo.png', height: 40),
                  const SizedBox(height: 40),
                  Text(
                    'Daftar Akun Untuk Lanjut Akses ke Luarsekolah',
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
                      color: const Color(0xFF7B7F95),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Daftar dengan Google',
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
                    onPressed: () {},
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      '------------- atau gunakan email -------------',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF3F3F4B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  InputFieldRegister(
                    label: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkapmu',
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                    validator: _nameValidator,
                    realTimeValidations: const ['Nama minimal 3 karakter'],
                  ),
                  const SizedBox(height: 16),
                  InputFieldRegister(
                    label: 'Email Aktif',
                    hintText: 'Masukkan alamat emailmu',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: _emailValidator,
                    realTimeValidations: const [
                      'Format email yang valid (contoh: nama@email.com)',
                    ],
                  ),
                  const SizedBox(height: 16),
                  InputFieldRegister(
                    label: 'Nomor Whatsapp Aktif',
                    hintText: 'Masukkan nomor whatsapp yang bisa dihubungi',
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    validator: _validatePhone,
                    realTimeValidations: const [
                      'Format nomor diawali 62',
                      'Minimal 10 angka',
                    ],
                  ),
                  const SizedBox(height: 16),
                  InputFieldRegister(
                    label: 'Password',
                    hintText: 'Masukkan password untuk akunmu',
                    isPassword: true,
                    controller: _passwordController,
                    validator: _validatePassword,
                    realTimeValidations: const [
                      'Minimal 8 karakter',
                      'Terdapat 1 huruf kapital',
                      'Terdapat 1 angka',
                      'Terdapat 1 karakter simbol (!, @, dst)',
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD3D3D3)),
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
                              setState(() => _isRobotChecked = value ?? false);
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
                          style: GoogleFonts.inter(fontSize: 14),
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
                    text: _isLoading ? 'Mendaftar...' : 'Daftarkan Akun',
                    backgroundColor: const Color(0xFF077E60),
                    textColor: Colors.white,
                    onPressed: _isLoading ? null : _handleRegister,
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF7B7F95),
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'Dengan mendaftar di Luarsekolah, kamu menyetujui ',
                        ),
                        TextSpan(
                          text: 'syarat dan ketentuan kami',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF4169E1),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: '',
                    backgroundColor: const Color(0xFFEFF5FF),
                    borderColor: const Color(0xFF2570EB),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        AppRoutes.slideTransition(const LoginPage()),
                      );
                    },
                    customContent: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('👋', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 2),
                        const Text(
                          'Punya akun? ',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          'Masuk ke Akunmu',
                          style: GoogleFonts.inter(
                            fontSize: 14,
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
