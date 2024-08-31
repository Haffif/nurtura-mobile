import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../theme/colors.dart';

class SensorDataChart extends StatelessWidget {
  final List<Map<String, dynamic>> sensorData;
  final String? sensorType;

  const SensorDataChart({
    Key? key,
    required this.sensorData,
    required this.sensorType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5, // Adjust this value as needed
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: sensorData.length.toDouble() * 24, // Adjust the width dynamically based on the data length
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      if (value.toInt() >= 0 && value.toInt() < sensorData.length) {
                        return sensorData[value.toInt()]['timestamp_pengukuran'].toString();
                      }
                      return '';
                    },
                    getTextStyles: (context, value) => const TextStyle(
                      color: Color(0xff68737d),
                      fontSize: 6,
                    ),
                    rotateAngle: -20,
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (context, value) => const TextStyle(
                      color: Color(0xff67727d),
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xff37434d),
                      strokeWidth: 0.5,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: const Color(0xff37434d),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                minX: 0,
                maxX: sensorData.length.toDouble() - 1,
                minY: 0,
                maxY: sensorData
                    .map((data) => data[sensorType] != null ? (data[sensorType] as num).toDouble() : 0.0)
                    .reduce((a, b) => a > b ? a : b),
                lineBarsData: [
                  LineChartBarData(
                    spots: sensorData.asMap().entries.map((entry) {
                      int idx = entry.key;
                      Map<String, dynamic> data = entry.value;
                      double yValue = data[sensorType] != null ? (data[sensorType] as num).toDouble() : 0.0;
                      return FlSpot(idx.toDouble(), yValue);
                    }).toList(),
                    isCurved: true,
                    colors: [
                      AppColors.primaryColor,
                    ],
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: AppColors.primaryColor,
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      colors: [AppColors.primaryColor.withOpacity(0.2)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
