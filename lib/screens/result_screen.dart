import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path/path.dart';
import '../widgets/double_circle.dart';

class ResultScreen extends StatelessWidget {
  final dynamic data;

  const ResultScreen({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    String fruit = data['fruit'] ?? 'Unknown';
    String ripeness = data['ripeness_stage'] ?? 'Unknown';
    String characteristics = data['characteristics'] ?? '';
    String benefits = data['benefits'] ?? '';
    String limitations = data['limitations'] ?? '';
    Map<String, dynamic> nutrition = Map<String, dynamic>.from(data['nutritional_estimation'] ?? {});

    final chartData = _generateChartData(fruit, ripeness);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Fixed header with padding
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/icons/left-arrow.png', width: 24),
                    ),
                    const Text(
                      'Result',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Image.asset('assets/icons/right-arrow.png', width: 24, color: Colors.white),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Pie chart with padding
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: chartData,
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Title with padding
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$fruit - $ripeness',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Legend with padding
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 6,
                          children: fruit == 'banana' ? const [
                            LegendItem(color: Colors.lightGreenAccent, text: 'Fresh unripe'),
                            LegendItem(color: Colors.lightGreen, text: 'Unripe'),
                            LegendItem(color: Color.fromARGB(255, 220, 248, 95), text: 'Fresh ripe'),
                            LegendItem(color: Color(0xFFFFF176), text: 'Ripe'),
                            LegendItem(color: Color(0xFFFFD700), text: 'Overripe'),
                            LegendItem(color: Colors.brown, text: 'Rotten'),
                          ] : const [
                            LegendItem(color: Color.fromARGB(255, 158, 225, 106), text: 'Unripe'),
                            LegendItem(color: Color.fromARGB(255, 200, 234, 113), text: 'Early ripe'),
                            LegendItem(color: Color.fromARGB(255, 229, 244, 116), text: 'Partial ripe'),
                            LegendItem(color: Color(0xFFFFF176), text: 'Fully ripe'),
                            LegendItem(color: Colors.brown, text: 'Rotten'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Yellow container full width
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9DA82),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 120,
                              left: -110,
                              child: DoubleCircle(outerRadius: 80, innerRadius: 70),
                            ),
                            Positioned(
                              top: 70,
                              right: -90,
                              child: DoubleCircle(outerRadius: 80, innerRadius: 75),
                            ),
                            Positioned(
                              top: 190,
                              left: 110,
                              child: DoubleCircle(outerRadius: 80, innerRadius: 70),
                            ),
                            Positioned(
                              top: 470,
                              left: -15,
                              child: DoubleCircle(outerRadius: 80, innerRadius: 70),
                            ),
                            Positioned(
                              top: 530,
                              right: -70,
                              child: DoubleCircle(outerRadius: 80, innerRadius: 70),
                            ),
                            Positioned(
                              top: 670,
                              left: -70,
                              child: DoubleCircle(outerRadius: 80, innerRadius: 70),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'What should you know?',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset('assets/icons/note.png', width: 24),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Evaluation',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          characteristics
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset('assets/icons/combo-chart.png', width: 24),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Nutritional Information',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        // Calories
                                        NutrientBar(
                                          name: 'Calorie: ~' + nutrition['Calories (kcal)'][0].toString() + '-' + nutrition['Calories (kcal)'][1].toString() + ' kcal', 
                                          start: 1.0 * nutrition['Calories (kcal)'][0], 
                                          end: 1.0 * nutrition['Calories (kcal)'][1], 
                                          max: fruit == 'banana' ? 100.0 : 70.0,
                                          lightColor: Color(0xFFFFCDD2),
                                          darkColor: Color(0xFFC62828),
                                        ),

                                        // Carbohydrates
                                        NutrientBar(
                                          name: 'Carbohydrate: ~' + nutrition['Carbohydrate (g)'][0].toString() + '-' + nutrition['Carbohydrate (g)'][1].toString() + ' g', 
                                          start: 1.0 * nutrition['Carbohydrate (g)'][0], 
                                          end: 1.0 * nutrition['Carbohydrate (g)'][1], 
                                          max: fruit == 'banana' ? 22.0 : 20.0,
                                          lightColor: Color(0xFFFFCCBC),
                                          darkColor: Color(0xFFE65100),
                                        ),

                                        // Sugar
                                        NutrientBar(
                                          name: 'Sugar: ~' + nutrition['Sugar (g)'][0].toString() + '-' + nutrition['Sugar (g)'][1].toString() + ' g', 
                                          start: 1.0 * nutrition['Sugar (g)'][0], 
                                          end: 1.0 * nutrition['Sugar (g)'][1], 
                                          max: fruit == 'banana' ? 17.0 : 15.0,
                                          lightColor: Color(0xFFD1C4E9),
                                          darkColor: Color(0xFF7B1FA2),
                                        ),

                                        // Fiber
                                        NutrientBar(
                                          name: 'Fiber: ~' + nutrition['Fiber (g)'][0].toString() + '-' + nutrition['Fiber (g)'][1].toString() + ' g', 
                                          start: 1.0 * nutrition['Fiber (g)'][0], 
                                          end: 1.0 * nutrition['Fiber (g)'][1], 
                                          max: fruit == 'banana' ? 20.0 : 4.7,
                                          lightColor: Color(0xFFAFEEEE),
                                          darkColor: Color(0xFF006666),
                                        ),

                                        // Potassium
                                        NutrientBar(
                                          name: 'Potassium: ~' + nutrition['Potassium (mg)'][0].toString() + '-' + nutrition['Potassium (mg)'][1].toString() + ' mg', 
                                          start: 1.0 * nutrition['Potassium (mg)'][0], 
                                          end: 1.0 * nutrition['Potassium (mg)'][1], 
                                          max: fruit == 'banana' ? 420.0 : 210.0,
                                          lightColor: Color(0xFFC5CAE9),
                                          darkColor: Color(0xFF1565C0),
                                        ),

                                        // Vitamin B6/A
                                        fruit == "banana" ? NutrientBar(
                                          name: 'Vitamin B6: ~' + nutrition['Vitamin B6 (% DV)'][0].toString() + '-' + nutrition['Vitamin B6 (% DV)'][1].toString() + '% DV', 
                                          start: 1.0 * nutrition['Vitamin B6 (% DV)'][0], 
                                          end: 1.0 * nutrition['Vitamin B6 (% DV)'][1], 
                                          max: 30.0,
                                          lightColor: Color(0xFFFFECB3),
                                          darkColor: Color(0xFFF57F17),
                                        ) : NutrientBar(
                                          name: 'Vitamin A: ~' + nutrition['Vitamin A (% DV)'][0].toString() + '-' + nutrition['Vitamin A (% DV)'][1].toString() + '% DV', 
                                          start: 1.0 * nutrition['Vitamin A (% DV)'][0], 
                                          end: 1.0 * nutrition['Vitamin A (% DV)'][1], 
                                          max: 10.0,
                                          lightColor: Color(0xFFFFECB3),
                                          darkColor: Color(0xFFF57F17),
                                        ),

                                        // Vitamin C
                                        fruit == 'banana' ? NutrientBar(
                                          name: 'Vitamin C: ~' + nutrition['Vitamin C (% DV)'][0].toString() + '-' + nutrition['Vitamin C (% DV)'][1].toString() + '% DV', 
                                          start: 1.0 * nutrition['Vitamin C (% DV)'][0], 
                                          end: 1.0 * nutrition['Vitamin C (% DV)'][1], 
                                          max: 12.0,
                                          lightColor: Color(0xFFB2DFDB),
                                          darkColor: Color(0xFF00695C),
                                        ) : NutrientBar(
                                          name: 'Vitamin C: ~' + nutrition['Vitamin C (mg)'][0].toString() + '-' + nutrition['Vitamin C (mg)'][1].toString() + ' mg', 
                                          start: 1.0 * nutrition['Vitamin C (mg)'][0], 
                                          end: 1.0 * nutrition['Vitamin C (mg)'][1], 
                                          max: 90.0,
                                          lightColor: Color(0xFFB2DFDB),
                                          darkColor: Color(0xFF00695C),
                                        ),

                                        // Resistant Starch
                                        fruit == 'banana' ? NutrientBar(
                                          name: 'Resistant Starch: ~' + nutrition['Resistant starch (g)'][0].toString() + '-' + nutrition['Resistant starch (g)'][1].toString() + ' g', 
                                          start: 1.0 * nutrition['Resistant starch (g)'][0], 
                                          end: 1.0 * nutrition['Resistant starch (g)'][1], 
                                          max: 18.0,
                                          lightColor: Color(0xFFFFCCCB),
                                          darkColor: Color(0xFFAD1457),
                                        ) : NutrientBar(
                                          name: 'Resistant Starch: ~' + nutrition['Resistant starch (%)'][0].toString() + '-' + nutrition['Resistant starch (%)'][1].toString() + '%', 
                                          start: 1.0 * nutrition['Resistant starch (%)'][0], 
                                          end: 1.0 * nutrition['Resistant starch (%)'][1], 
                                          max: 20.0,
                                          lightColor: Color(0xFFFFCCCB),
                                          darkColor: Color(0xFFAD1457),
                                        ),

                                        // Antioxidants
                                        NutrientBar(
                                          name: 'Antioxidants: ' + nutrition['Antioxidants'],
                                          isAntioxidents: true,
                                          level: nutrition['Antioxidants'],
                                        ),
                                        // NutrientBar(name: 'Carbohydrate (g)', value: 0.4, color: Colors.blue),
                                        // NutrientBar(name: 'Sugar (g)', value: 0.9, color: Colors.pinkAccent),
                                        // NutrientBar(name: 'Fiber (g)', value: 0.7, color: Colors.purpleAccent),
                                        // NutrientBar(name: 'Kali (g)', value: 0.6, color: Colors.pink),
                                        // NutrientBar(name: 'Vitamin B6 (%)', value: 0.3, color: Colors.orangeAccent),
                                        // NutrientBar(name: 'Vitamin C (%)', value: 0.2, color: Colors.orange),
                                        // NutrientBar(name: 'Mineral starch (g)', value: 0.001, color: Colors.greenAccent),
                                        // NutrientBar(name: 'Antioxidant', value: 0.85, color: Colors.cyanAccent),
                                        // HorizontalProgressBar(start: 10, end: 80, max: 100),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: AdviceBox(
                                            icon: 'assets/icons/message-bot.png',
                                            title: 'Benefits',
                                            texts: [
                                              // 'Ideal for quick energy boosts.',
                                              // 'May not be suitable for people needing low sugar diets.',
                                              // 'Aids digestion thanks to softer fiber content.',
                                              benefits
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          flex: 2,
                                          child: AdviceBox(
                                            icon: 'assets/icons/smiling-face-with-heart.png',
                                            title: 'Limitations',
                                            texts: [
                                              // 'Use fully ripe bananas in baking for extra moisture and natural sweetness, perfect for banana bread or muffins.',
                                              limitations
                                            ],
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateChartData(String fruit, String stage) {
    var stages = fruit == "banana" ? {
      "fresh unripe": 0.0,
      "unripe": 25.0,
      "fresh ripe": 50.0,
      "ripe": 75.0,
      "overripe": 100.0,
      "rotten": 100.0,
    } : {
      "unripe": 0.0,
      "early ripe": 33.33,
      "partial ripe": 66.67,
      "fully ripe": 100.0,
      "rotten": 100.0,
    };

    var colors = fruit == "banana" ? {
      "fresh unripe": Colors.lightGreenAccent,
      "unripe": Colors.lightGreen,
      "fresh ripe": Color.fromARGB(255, 220, 248, 95),
      "ripe": Color(0xFFFFF176),
      "overripe": Color(0xFFFFD700),
      "rotten": Colors.brown,
    } : {
      "unripe": Color.fromARGB(255, 158, 225, 106),
      "early ripe": Color.fromARGB(255, 200, 234, 113),
      "partial ripe": Color.fromARGB(255, 229, 244, 116),
      "fully ripe": Color(0xFFFFF176),
      "rotten": Colors.brown,
    };

    final percentage = stages[stage.toLowerCase()] ?? 0.0;
    final activeColor = colors[stage.toLowerCase()] ?? Colors.grey;

    return [
      PieChartSectionData(
        color: activeColor,
        value: percentage,
        title: percentage == 0 ? '' : '${percentage.toInt()}% ripeness',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.grey[300],
        value: 100 - percentage,
        title: '',
        radius: 50,
      ),
    ];
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({required this.color, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class NutrientBar extends StatelessWidget {
  final String name;
  final double start;
  final double end;
  final double max;
  final Color lightColor;
  final Color darkColor;
  final bool isAntioxidents;
  final String level;

  const NutrientBar({
    required this.name, 
    this.start = 0.0, 
    this.end = 0.0, 
    this.max = 0.0, 
    this.lightColor = Colors.white, 
    this.darkColor = Colors.white, 
    this.isAntioxidents = false,
    this.level = 'none', 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          isAntioxidents ? TripleBarIndicator(level: level) :
          HorizontalProgressBar(start: start, end: end, max: max, lightColor: lightColor, darkColor: darkColor),
        ],
      ),
    );
  }
}

class AdviceBox extends StatelessWidget {
  final String icon;
  final String title;
  final List<String> texts;

  const AdviceBox({required this.icon, required this.title, required this.texts, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(icon, width: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...texts.map((text) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(text, style: const TextStyle(fontSize: 12)),
          )),
        ],
      ),
    );
  }
}

class HorizontalProgressBar extends StatelessWidget {
  final double start;
  final double end;
  final double max;
  final double height;
  final Color lightColor;
  final Color darkColor;
  final bool showLabels;

  const HorizontalProgressBar({
    super.key,
    required this.start,
    required this.end,
    required this.max,
    this.height = 12.0,
    required this.lightColor,
    required this.darkColor,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure valid values
    final double safeStart = start.clamp(0.0, max);
    final double safeEnd = end.clamp(safeStart, max);
    final double safeMax = max <= 0 ? 100 : max;
    
    // Calculate percentages
    final double startPercent = safeStart / safeMax;
    final double endPercent = safeEnd / safeMax;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: Colors.grey[300],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              
              return Stack(
                children: [ 
                  // Light section after end
                  if (startPercent > 0.0)
                    Positioned(
                      left: 0,
                      child: Container(
                        height: height,
                        width: width * startPercent,
                        decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(height / 2),
                            bottomLeft: Radius.circular(height / 2),
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    left: width * (startPercent - (startPercent > 1e-6 ? 1 : 0) * 0.01),
                    child: Container(
                      height: height,
                      width: width * (endPercent - startPercent + (endPercent < 1.0 - 1e-6 ? 2 : 1) * 0.01 - (startPercent > 1e-6 ? 0 : 1) * 0.01),
                      // color: darkColor,
                      decoration: BoxDecoration(
                        color: darkColor,
                        borderRadius: BorderRadius.circular(height / 2),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 2,
                    child: Text(
                      safeMax.toInt().toString(), 
                      style: TextStyle(
                        fontSize: 10,
                        color: end == max ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class TripleBarIndicator extends StatelessWidget {
  final String level;
  final double barHeight;
  final double spacing;

  const TripleBarIndicator({
    super.key,
    required this.level,
    this.barHeight = 12.0,
    this.spacing = 4.0,
  });

  int _getLevelValue(String level) {
    switch (level.toLowerCase()) {
      case 'none':
        return 0;
      case 'low':
        return 1;
      case 'moderate':
        return 2;
      case 'high':
        return 3;
      default:
        return 0;
    }
  }

  Color _getBarColor(int barIndex, int activeLevel) {
    if (barIndex >= activeLevel) {
      return Colors.grey[300]!; // Inactive color
    }
    
    // Return colors based on intensity
    switch (barIndex) {
      case 0:
        return Color.fromARGB(255, 228, 232, 172); // First bar - green
      case 1:
        return Color.fromARGB(255, 214, 226, 114); // Second bar - orange
      case 2:
        return Color.fromARGB(255, 149, 198, 107); // Third bar - red
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int activeLevel = _getLevelValue(level);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: List.generate(3, (index) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < 2 ? spacing : 0,
                ),
                height: barHeight,
                decoration: BoxDecoration(
                  color: _getBarColor(index, activeLevel),
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}