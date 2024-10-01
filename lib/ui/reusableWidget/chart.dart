import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sales_tracker/configs/palette.dart';

import '../../configs/dimension.dart';

class CustomBarChart extends StatelessWidget {
  const CustomBarChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(padding),
      width: MediaQuery.of(context).size.width,
      height: 350,
      color: Palette.primaryContainer,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 20,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 5),
                FlSpot(1, 7),
                FlSpot(2, 10),
                FlSpot(3, 12),
                FlSpot(4, 8),
                FlSpot(5, 15),
                FlSpot(6, 17),
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text("Income (Rs)"),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 5, // Label interval on the Y-axis
                getTitlesWidget: (value, meta) {
                  return Text(value.toString());
                },
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text("Days of the Week"),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Mon');
                    case 1:
                      return const Text('Tue');
                    case 2:
                      return const Text('Wed');
                    case 3:
                      return const Text('Thu');
                    case 4:
                      return const Text('Fri');
                    case 5:
                      return const Text('Sat');
                    case 6:
                      return const Text('Sun');
                    default:
                      return const Text('');
                    }
                  },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.black12, strokeWidth: 1),
            getDrawingVerticalLine: (value) => FlLine(color: Colors.black12, strokeWidth: 1),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
