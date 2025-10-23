import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class InputFieldRegister extends StatefulWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<String>?
  realTimeValidations; // showing validation messages in real-time
  final VoidCallback? onSuffixIconPressed;

  const InputFieldRegister({
    Key? key,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.realTimeValidations,
    this.onSuffixIconPressed,
  }) : super(key: key);

  @override
  State<InputFieldRegister> createState() => _InputFieldRegisterState();
}

class _InputFieldRegisterState extends State<InputFieldRegister> {
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

  // Check if all real-time validations are passed
  bool _allValidationsPassed() {
    if (widget.realTimeValidations == null ||
        widget.realTimeValidations!.isEmpty ||
        !_hasInteracted) {
      return true;
    }

    for (String message in widget.realTimeValidations!) {
      if (!_checkValidation(message)) {
        return false;
      }
    }
    return true;
  }

  Color _getBorderColor() {
    if (!_hasInteracted) {
      return AppColors.borderField;
    }

    // For fields with real-time validations
    if (widget.realTimeValidations != null &&
        widget.realTimeValidations!.isNotEmpty) {
      return _allValidationsPassed() ? AppColors.secondary : Colors.red;
    }

    // Check if validator returns null (valid)
    if (widget.validator != null && widget.controller != null) {
      String? error = widget.validator!(widget.controller!.text);
      if (error == null && widget.controller!.text.isNotEmpty) {
        return AppColors.secondary;
      } else if (error != null && widget.controller!.text.isNotEmpty) {
        return Colors.red;
      }
    }

    return AppColors.borderField;
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = _getBorderColor();

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
          onChanged: (_) {
            _onFieldInteraction();
            // Trigger rebuild to update border color and validations
            setState(() {});
          },
          inputFormatters: widget.keyboardType == TextInputType.phone
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.borderField),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            errorStyle: TextStyle(height: 0, fontSize: 0),
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
        // Real-time validation messages
        if (widget.realTimeValidations != null &&
            widget.realTimeValidations!.isNotEmpty &&
            _hasInteracted)
          ...widget.realTimeValidations!.map((message) {
            // Check if validation is passed or failed
            bool isPassed = _checkValidation(message);
            bool hasText = widget.controller?.text.isNotEmpty ?? false;
            Color color = isPassed
                ? AppColors.greenDecorative
                : (hasText ? Colors.red : Colors.grey);

            return Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                children: [
                  Icon(
                    isPassed ? Icons.check_circle : Icons.cancel,
                    size: 20,
                    color: color,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 13,
                        color: color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }

  bool _checkValidation(String message) {
    if (widget.controller == null) return false;
    String value = widget.controller!.text;

    // Password validations
    if (message.contains('Minimal 8 karakter')) {
      return value.length >= 8;
    } else if (message.contains('1 huruf kapital')) {
      return value.contains(RegExp(r'[A-Z]'));
    } else if (message.contains('1 angka')) {
      return value.contains(RegExp(r'[0-9]'));
    } else if (message.contains('1 karakter simbol')) {
      return value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    }
    // Phone validations
    else if (message.contains('Minimal 10 angka')) {
      return value.length >= 10;
    } else if (message.contains('Format nomor diawali 62')) {
      return value.startsWith('62');
    }
    // Name validation
    else if (message.contains('Nama minimal 3 karakter')) {
      return value.length >= 3;
    }
    // Email validation
    else if (message.contains('Format email valid')) {
      // Basic email validation regex
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      return emailRegex.hasMatch(value);
    }

    return false;
  }
}
