import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.borderRadius,
    this.focusColor,
    this.obscureText,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.validator,
    this.maxLength,
    this.onChanged,
    this.readOnly = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final double? borderRadius;
  final Color? focusColor;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLength;
  final bool readOnly;
  final AutovalidateMode autovalidateMode;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = false;
  late FocusNode _focusNode;
  bool _hasFocused = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText ?? false;
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // أول ما المستخدم يضغط على الحقل نخفي الخطأ
        setState(() {
          _hasFocused = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      controller: widget.controller,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: obscureText,
      maxLength: widget.maxLength,
      autovalidateMode: widget.autovalidateMode,
      validator: (val) {
        if (_hasFocused) {
          // لو المستخدم ضغط على الحقل → ما نرجع خطأ
          return null;
        }
        return widget.validator?.call(val);
      },
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText == true
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.remove_red_eye,
                  color: Colors.grey,
                ),
              )
            : null,
        labelText: widget.label,
      ),
    );
  }
}
