import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width*0.1,size.height*0.3818714);
    path_0.lineTo(size.width*0.1,size.height*0.3649857);
    path_0.lineTo(size.width*0.5,size.height*0.3821000);
    path_0.lineTo(size.width*0.8333333,size.height*0.4642857);
    path_0.lineTo(size.width*0.5010250,size.height*0.4450714);
    path_0.lineTo(size.width*0.1667250,size.height*0.4640429);
    path_0.lineTo(size.width*0.1661000,size.height*0.3818714);

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
