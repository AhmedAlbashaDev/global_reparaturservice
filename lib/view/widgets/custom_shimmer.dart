import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFC3C3CC),
    Color(0xFFD9D8D8),
    Color(0xFFCACAD0),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class CustomSkeleton extends StatelessWidget {
  final Widget child;

  const CustomSkeleton({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(gradient: shimmerGradient, child: child);
  }
}

class RoundedShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final double? radius;
  final BoxShape shape;

  const RoundedShimmerContainer({
    Key? key,
    required this.width,
    required this.height,
    this.radius,
    this.shape = BoxShape.rectangle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSkeleton(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RoundedColoredContainer(
          color: Colors.grey,
          radius: radius,
          shape: shape,
          child: SizedBox(
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }
}

class RoundedColoredContainer extends StatelessWidget {
  final Color color;
  final Widget? child;
  final double? radius;
  final BoxShape shape;

  const RoundedColoredContainer(
      {Key? key, required this.color, required this.child, this.radius, this.shape = BoxShape.rectangle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final r = radius ?? 16;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? BorderRadius.all(
          Radius.circular(r) ,
        ) : null,
      ),
      child: child,
    );
  }
}