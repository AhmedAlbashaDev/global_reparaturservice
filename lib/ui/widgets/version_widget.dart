import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      'v 1.0.0',
      style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold
      ),
    );
  }
}
