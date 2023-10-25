import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({super.key, required this.label, this.controller, required this.validator, this.textInputType = TextInputType.text , this.readOnly = false , this.height = 50 , this.onTap , this.maxLength , this.minLength , this.hint , this.searchSuffix});

  final String label;
  final TextEditingController? controller;
  final dynamic validator;
  final TextInputType textInputType;
  final bool readOnly;
  final double height;
  final int? maxLength;
  final int? minLength;
  final VoidCallback? onTap;
  final String? hint;
  final Widget? searchSuffix;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        validator: validator,
        textAlignVertical: TextAlignVertical.top,
        onTap: onTap,
        keyboardType: textInputType,
        readOnly: readOnly,
        maxLines: null,
        minLines: null,
        inputFormatters: textInputType == TextInputType.number? [FilteringTextInputFormatter.digitsOnly] : null,
        maxLength: maxLength,
        expands: true,
        style: TextStyle(color: Theme.of(context).primaryColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          hintText: hint,
          suffixIcon: searchSuffix,
        ),
      ),
    );
  }
}
