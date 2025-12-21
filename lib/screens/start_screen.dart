import 'package:flutter/material.dart';
import '../widgets/double_circle.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool check = false;

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // bắt toàn bộ vùng nhấn
      onTap: () {
        if (check == false) {
          check = true;
          Navigator.pushNamed(context, '/intro1');
        } else {
          Navigator.pushNamed(context, '/login');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/banana_bg.jpeg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Color(0xCAF9DA82),
                    BlendMode.srcATop,
                  ),
                ),
              ),
            ),

            // Decorative circles
            
            Positioned(
              top: -50,
              left: 230,
              child: const DoubleCircle(outerRadius: 120, innerRadius: 90),
            ),
            Positioned(
              top: 220,
              left: -40,
              child: const DoubleCircle(outerRadius: 50, innerRadius: 40),
            ),
            Positioned(
              top: 450,
              left: 320,
              child: const DoubleCircle(outerRadius: 80, innerRadius: 60),
            ),
            Positioned(
              top: 650,
              left: -60,
              child: const DoubleCircle(outerRadius: 100, innerRadius: 80),
            ),

            // Center text
            const Center(
              child: Text(
                'Fruit ToGo',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontFamily: 'LeagueSpartan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}