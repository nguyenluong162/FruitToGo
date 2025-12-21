import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'dart:io';
import '../widgets/double_circle.dart';

// Data model for fruit classification results
class FruitResult {
  final DateTime scanDate;
  final String imagePath; // Path to the fruit image
  final dynamic data;
  final String id;

  FruitResult({
    required this.scanDate,
    required this.imagePath,
    required this.data,
    required this.id,
  });
}

// Global history manager (In a real app, use Provider, Riverpod, or similar)
class HistoryManager {
  static final HistoryManager _instance = HistoryManager._internal();
  factory HistoryManager() => _instance;
  HistoryManager._internal();

  final List<FruitResult> _history = [];

  List<FruitResult> get history => List.unmodifiable(_history);

  void addResult(FruitResult result) {
    _history.insert(0, result); // Add to beginning for newest first
  }

  void clearHistory() {
    _history.clear();
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryManager historyManager = HistoryManager();

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
          'History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 34,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 300,
            left: -70,
            child: const DoubleCircle(outerRadius: 70, innerRadius: 59),
          ),
          Positioned(
            top: 0,
            right: -70,
            child: const DoubleCircle(outerRadius: 70, innerRadius: 59),
          ),
          Positioned(
            top: 500,
            right: -30,
            child: const DoubleCircle(outerRadius: 65, innerRadius: 52),
          ),
          historyManager.history.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No scans yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your fruit scans will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "You've scanned",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: historyManager.history.length,
            itemBuilder: (context, index) {
              final result = historyManager.history[index];
              return _buildHistoryItem(result, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(FruitResult result, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFFFFE7A1),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToResult(result),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.data['fruit'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(result.scanDate),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Status ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          _buildRatingStars(1),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _getFruitImage(result.imagePath),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars(double score) {
    int filledStars = (score * 5).round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          Icons.star,
          size: 16,
          color: index < filledStars ? Colors.amber : Colors.grey[300],
        );
      }),
    );
  }

  Widget _getFruitImage(String imagePath) {
    return Center(
      child: Image.file(
        File(imagePath),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    
    return '$day-$month-$year, $hour:$minute $ampm';
  }

  void _navigateToResult(FruitResult result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(data: result.data),
      ),
    );
  }
}

// Example of how to add a result to history (call this from your classification logic)
void addResultToHistory({
  required String imagePath,
  required dynamic data,
}) {
  final result = FruitResult(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    scanDate: DateTime.now(),
    imagePath: imagePath,
    data: data,
  );
  
  HistoryManager().addResult(result);
}

// Example usage in your main app
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fruit Scanner',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: 'Roboto',
//       ),
//       home: const MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   // For testing - adds sample data to history
//   void _addSampleData() {
//     final fruits = ['Apple', 'Orange', 'Banana', 'Watermelon', 'Kiwi', 'Pear'];
//     final randomFruit = fruits[DateTime.now().millisecond % fruits.length];
//     final randomScore = (DateTime.now().millisecond % 100) / 100.0;
    
//     addResultToHistory(
//       fruitName: randomFruit,
//       ripenessScore: randomScore,
//       imagePath: 'assets/images/$randomFruit.jpg',
//       nutritionalData: {
//         'Calories': '${80 + (DateTime.now().millisecond % 50)} kcal',
//         'Sugar': '${10 + (DateTime.now().millisecond % 15)} g',
//         'Fiber': '${2 + (DateTime.now().millisecond % 5)} g',
//         'Vitamin C': '${20 + (DateTime.now().millisecond % 30)} mg',
//       },
//     );
    
//     setState(() {}); // Refresh the screen
//   }
// }