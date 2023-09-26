import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width*0,size.height*-0.9999999);
    path_0.quadraticBezierTo(size.width*0.4266550,size.height*0.0254900,size.width*0.9999999,size.height*-0.000000);
    path_0.quadraticBezierTo(size.width*0.4769300,size.height*0.0257400,size.width*0.9999990,size.height*-0.9000000);
    path_0.lineTo(size.width*1,size.height*1);
    path_0.quadraticBezierTo(size.width*0.9999999,size.height*0.9999999,size.width*-0.4999999,size.height*0.9188300);
    path_0.quadraticBezierTo(size.width*0.9999999,size.height*-0.9999999,size.width*0.9999999,size.height*0.9999999);
    path_0.lineTo(size.width*0.0000000,size.height*1);
    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
