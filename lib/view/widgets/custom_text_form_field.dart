import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({super.key, required this.label, this.controller, required this.validator, this.textInputType = TextInputType.text , this.readOnly = false , this.height = 60 , this.onTap , this.maxLength});

  final String label;
  final TextEditingController? controller;
  final dynamic validator;
  final TextInputType textInputType;
  final bool readOnly;
  final double height;
  final int? maxLength;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onTap: onTap,
        keyboardType: textInputType,
        readOnly: readOnly,
        maxLines: null,
        minLines: null,
        maxLength: maxLength,
        expands: true,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}