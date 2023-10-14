import 'package:flutter/material.dart';

class CustomSnakeBarContent extends StatelessWidget {
  const CustomSnakeBarContent({super.key, this.message, this.icon, this.bgColor, this.borderColor});

  final String? message;
  final Icon? icon;
  final Color? bgColor;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8 , vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor!, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: icon,
          contentPadding: EdgeInsets.zero,
          title:  Text( message!, style: const TextStyle(color: Colors.white),maxLines: 2,overflow: TextOverflow.ellipsis,),
        )
    );
  }
}
