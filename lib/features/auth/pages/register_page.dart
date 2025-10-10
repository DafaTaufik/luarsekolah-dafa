import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../shared/widgets/CustomButton.dart';
import '../../../shared/widgets/InputFieldRegister.dart';
import '../../../../core/constants/app_routes.dart';
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

  // Validators menggunakan form_field_validator untuk nama dan email
  final _nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Nama tidak boleh kosong'),
    MinLengthValidator(3, errorText: 'Nama minimal 3 karakter'),
  ]);

  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email tidak boleh kosong'),
    EmailValidator(errorText: 'Format email tidak valid'),
  ]);

  // Custom validator untuk nomor telepon
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!value.startsWith('62')) {
      return null; // Error akan ditampilkan di real-time validation
    }
    if (value.length < 10) {
      return null; // Error akan ditampilkan di real-time validation
    }
    return null;
  }

  // Custom validator untuk password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    // Validasi detail akan ditampilkan di real-time validation
    if (value.length < 8) return null;
    if (!value.contains(RegExp(r'[A-Z]'))) return null;
    if (!value.contains(RegExp(r'[0-9]'))) return null;
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return null;
    return null;
  }

  // Real-time validation messages
  List<String> get _phoneValidations => [
    'Format nomor diawali 62',
    'Minimal 10 angka',
  ];

  List<String> get _passwordValidations => [
    'Minimal 8 karakter',
    'Terdapat 1 huruf kapital',
    'Terdapat 1 angka',
    'Terdapat 1 karakter simbol (!, @, dst)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validasi custom untuk nomor telepon
    String phone = _phoneController.text;
    if (!phone.startsWith('62') || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor telepon harus diawali 62 dan minimal 10 angka'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi custom untuk password
    String password = _passwordController.text;
    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak memenuhi persyaratan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi reCAPTCHA
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
      // Simpan data ke SharedPreferences
      final success = await LocalStorageService.saveUserData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registrasi berhasil!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate ke home page
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menyimpan data. Silakan coba lagi.'),
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
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7B7F95),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Btn Google
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

                  // Name Input
                  InputFieldRegister(
                    label: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkapmu',
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                    validator: _nameValidator,
                  ),

                  const SizedBox(height: 16),

                  // Email Input
                  InputFieldRegister(
                    label: 'Email Aktif',
                    hintText: 'Masukkan alamat emailmu',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: _emailValidator,
                  ),

                  const SizedBox(height: 16),

                  // Phone Input with real-time validation
                  InputFieldRegister(
                    label: 'Nomor Whatsapp Aktif',
                    hintText: 'Masukkan nomor whatsapp yang bisa dihubungi',
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    validator: _validatePhone,
                    realTimeValidations: _phoneValidations,
                  ),

                  const SizedBox(height: 16),

                  // Password Input with real-time validation
                  InputFieldRegister(
                    label: 'Password',
                    hintText: 'Masukkan password untuk akunmu',
                    isPassword: true,
                    controller: _passwordController,
                    validator: _validatePassword,
                    realTimeValidations: _passwordValidations,
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
                        fontWeight: FontWeight.w400,
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
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF4169E1),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Button Have Account
                  CustomButton(
                    text: '',
                    backgroundColor: const Color(0xFFEFF5FF),
                    borderColor: const Color(0xFF2570EB),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    customContent: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('👋', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 2),
                        const Text(
                          'Sudah punya akun? ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Masuk ke Akunmu',
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
