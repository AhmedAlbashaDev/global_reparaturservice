import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({super.key, required this.onPresses , this.child});

  final Widget? child;
  final VoidCallback onPresses;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPresses,
      padding: EdgeInsets.zero,
      shape: const CircleBorder(),
      color: Colors.white,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child:  child ?? Image.asset('assets/images/add.png' , height: 50,),
    );
  }
}
