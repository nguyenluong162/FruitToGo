import 'package:flutter/material.dart';
import '../widgets/double_circle.dart';
import 'intro2_screen.dart'; // Cho navigation

class Intro1Screen extends StatelessWidget {
  const Intro1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF8),
      body: SafeArea(
        child: Column(
          children: [
            // Stack bao quanh cả ảnh và double circles
            Stack(
              clipBehavior: Clip.none,
              children: [
                // ClipRRect chỉ clip ảnh thôi
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(56),
                  ),
                  child: Image.asset(
                    'assets/images/intro1_image.jpeg',
                    width: double.infinity,
                    height: 540,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: 50,
                  left: -30,
                  child: DoubleCircle(outerRadius: 50, innerRadius: 40),
                ),
                Positioned(
                  top: 470,
                  right: -30,
                  child: DoubleCircle(outerRadius: 60, innerRadius: 47),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Fresh Detection',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'LeagueSpartan',
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Displays real-time fruit freshness based on\ndata from the FruitToGo sensor.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dots + Next button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicator
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                  // Next button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9DA82),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Intro2Screen()),
                      );
                    },

                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
