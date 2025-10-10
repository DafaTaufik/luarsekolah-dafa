import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class InputFieldLogin extends StatefulWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixIconPressed;

  const InputFieldLogin({
    Key? key,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.onSuffixIconPressed,
  }) : super(key: key);

  @override
  State<InputFieldLogin> createState() => _InputFieldLoginState();
}

class _InputFieldLoginState extends State<InputFieldLogin> {
  bool _obscureText = true;
  bool _hasInteracted = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _onFieldInteraction() {
    if (!_hasInteracted) {
      setState(() {
        _hasInteracted = true;
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          validator: widget.validator,
          autovalidateMode: _autovalidateMode,
          onChanged: (_) => _onFieldInteraction(),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.borderField),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.borderField),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
