import 'package:flutter/material.dart';
import 'favorite_screen.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'noti_screen.dart';
import 'profile_screen.dart';
import 'package:camera/camera.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription camera;
  const HomeScreen({required this.camera, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const MainHomeContent(),
      const FavoriteScreen(),
      ScanScreen(camera: widget.camera), 
      const HistoryScreen(),
      NotiScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<String> iconPaths = [
      'assets/icons/home.png',
      'assets/icons/heart.png',
      'assets/icons/rescan-document.png',
      'assets/icons/time.png',
      'assets/icons/bell.png',
      'assets/icons/user.png',
    ];

    List<String> labels = [
      'Home',
      'Favorites',
      'Scan',
      'History',
      'Notices',
      'Profile',
      // '', '', '', '', '', '',
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 70, // fixed height that avoids overflow
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(iconPaths.length, (index) {
              final bool isActive = _currentIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: isActive
                      ? BoxDecoration(
                          color: const Color(0xFFFBE096),
                          borderRadius: BorderRadius.circular(16),
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        iconPaths[index],
                        width: 22,
                        height: 22,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),

    );
  }

}

class MainHomeContent extends StatelessWidget {
  const MainHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header box
            Stack(
              children: [
                // Background image container
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(56),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 180, // Increased height to accommodate text and search bar
                    child: Image.asset(
                      'assets/images/home1.jpeg',
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Overlay content
                Container(
                  width: double.infinity,
                  height: 240,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(flex: 1),
                      
                      // Title text
                      const Text(
                        'Hi, fellow!',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      
                      // const SizedBox(height: 8),
                      
                      // Subtitle text
                      const Text(
                        'Welcome to Fruit ToGo.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Search bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE7A1),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.search,
                              color: Colors.black54,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'What do you want to find?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTopButton('assets/icons/apple-fruit.png', 'Suggest'),
                _buildTopButton('assets/icons/binoculars.png', 'Explore'),
                _buildTopButton('assets/icons/grid.png', 'All'),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: const Text('For you', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 178/220, // This sets the width/height ratio to match your images
              children: [
                _buildCard('Seasonal Fruit', 'assets/images/home2.jpeg'),
                _buildCard('Recipes', 'assets/images/home3.jpeg'),
                _buildCard('Market', 'assets/images/home4.jpeg'),
                _buildCard('Storage tips', 'assets/images/home5.jpeg'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButton(String icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          decoration: BoxDecoration(
            color: Color(0xFFFFE7A1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          
          child: Image.asset(icon, width: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14))
      ],
    );
  }

  Widget _buildCard(String label, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

}

// Dummy other screens
