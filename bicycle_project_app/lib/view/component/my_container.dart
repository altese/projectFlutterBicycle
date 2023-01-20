import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final Color shadowColor;
  final double spreadRadius;
  final double blurRadius;
  final Offset offset;
  final BorderRadius borderRadius;

  const MyContainer({
    super.key,
    required this.height,
    this.width = 350,
    required this.child,
    this.shadowColor = const Color.fromARGB(0, 235, 235, 235),
    this.spreadRadius = 0,
    this.blurRadius = 2.0,
    this.offset = const Offset(0, 2),
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 0,
            blurRadius: 2.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
      // child: Widget,
    );
  }
}
