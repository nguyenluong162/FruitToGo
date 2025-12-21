import 'package:flutter/material.dart';

class DoubleCircle extends StatelessWidget {
  final double outerRadius;
  final double innerRadius;

  const DoubleCircle({
    super.key,
    required this.outerRadius,
    required this.innerRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: outerRadius * 2,
      height: outerRadius * 2,
      child: Center(
        child: Container(
          width: outerRadius * 2,
          height: outerRadius * 2,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF9DA82), // outer circle
          ),
          child: Center(
            child: Container(
              width: innerRadius * 2,
              height: innerRadius * 2,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFE7A1), // inner circle
              ),
            ),
          ),
        ),
      ),
    );
  }
}
