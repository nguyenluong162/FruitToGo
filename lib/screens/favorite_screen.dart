import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Liked',
          style: TextStyle(
            color: Colors.black,
            fontSize: 34,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seasonal fruit section
            _buildSectionTitle('Seasonal fruit'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildImageCard('assets/images/fav1.jpeg'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildImageCard('assets/images/fav2.jpeg'),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Unique recipes section
            _buildSectionTitle('Unique recipes'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildImageCard('assets/images/fav3.jpeg'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildImageCard('assets/images/fav4.jpeg'),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Storage Tips section
            _buildSectionTitle('Storage Tips'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildImageCard('assets/images/fav5.jpeg'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildImageCard('assets/images/fav6.jpeg'),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}