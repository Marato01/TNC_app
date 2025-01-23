import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// A StatefulWidget for displaying a performance graph
class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  // Gradient colors for the line graph
  List<Color> gradientColors = [
    const Color(0xff23b6e6), // First gradient color
    const Color(0xff02d39a), // Second gradient color
  ];

  // Flag to toggle between showing average and not showing average
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and button to toggle average display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance Metrics', // Title of the graph
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // IconButton to toggle the `showAvg` flag
              IconButton(
                icon: Icon(
                    Icons.show_chart,
                    color: showAvg ? Colors.blue : Colors.grey // Change icon color based on `showAvg`
                ),
                onPressed: () {
                  setState(() {
                    showAvg = !showAvg; // Toggle the `showAvg` flag when button is pressed
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16), // Add spacing between header and chart
          // Aspect ratio for the chart, ensuring it maintains a specific width/height ratio
          AspectRatio(
            aspectRatio: 1.70,
            child: LineChart(
              mainData(), // Line chart with data from the `mainData` method
            ),
          ),
        ],
      ),
    );
  }

  // Data for the main line chart
  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true, // Show grid lines
        drawVerticalLine: true, // Draw vertical grid lines
        horizontalInterval: 1, // Horizontal grid interval
        verticalInterval: 1, // Vertical grid interval
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black12, // Color of horizontal grid lines
            strokeWidth: 1, // Width of horizontal grid lines
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.black12, // Color of vertical grid lines
            strokeWidth: 1, // Width of vertical grid lines
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true, // Show axis titles
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false), // Disable right axis titles
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false), // Disable top axis titles
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, // Show bottom axis titles
            reservedSize: 30, // Reserved space for bottom titles
            interval: 1, // Interval for bottom titles
            getTitlesWidget: bottomTitleWidgets, // Custom widget for bottom titles
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, // Show left axis titles
            interval: 1, // Interval for left titles
            getTitlesWidget: leftTitleWidgets, // Custom widget for left titles
            reservedSize: 42, // Reserved space for left titles
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false, // Hide chart border
      ),
      minX: 0, // Minimum x-axis value
      maxX: 4, // Maximum x-axis value
      minY: 0, // Minimum y-axis value
      maxY: 5, // Maximum y-axis value
      lineBarsData: [
        // Data for the line chart
        LineChartBarData(
          spots: [
            FlSpot(0, 1), // First point (x: 0, y: 1)
            FlSpot(1, 3), // Second point (x: 1, y: 3)
            FlSpot(2, 2), // Third point (x: 2, y: 2)
            FlSpot(3, 1.5), // Fourth point (x: 3, y: 1.5)
            FlSpot(4, 4), // Fifth point (x: 4, y: 4)
          ],
          isCurved: true, // Make the line curved
          gradient: LinearGradient(
            colors: gradientColors, // Gradient colors for the line
          ),
          barWidth: 5, // Width of the line
          isStrokeCapRound: true, // Rounded ends for the line
          dotData: const FlDotData(
            show: true, // Show dots on the line
          ),
          belowBarData: BarAreaData(
            show: true, // Show area under the line
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(), // Gradient with reduced opacity for the area under the line
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  // Widget for the bottom axis titles (months)
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.black54,
    );
    Widget text;
    // Return the month abbreviation based on the x-axis value
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 1:
        text = const Text('Feb', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 3:
        text = const Text('Apr', style: style);
        break;
      case 4:
        text = const Text('May', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 10.0),
      child: text,
    );
  }

  // Widget for the left axis titles (values)
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.black54,
    );
    String text = value.toString(); // Convert y-axis value to string
    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
