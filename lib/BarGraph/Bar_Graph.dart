// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class myBarGraph extends StatefulWidget {
  final List<List<double>> weeklySummary;
  const myBarGraph({required this.weeklySummary, super.key});

  @override
  State<myBarGraph> createState() => _myBarGraphState();
}

class _myBarGraphState extends State<myBarGraph> {
  @override
  Widget build(BuildContext context) {
    // Initialize bar data with additional bars for Sunday
   List<BarChartGroupData> barGroups = List.generate(7, (index) {
      double ongoingCount = widget.weeklySummary[0][index];
      double doneCount = widget.weeklySummary[1][index];
      double canceledCount = widget.weeklySummary[2][index];

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: ongoingCount,
            color: Colors.green,
          ),
          BarChartRodData(
            toY: doneCount,
            color: Colors.blue,
          ),
          BarChartRodData(
            toY: canceledCount,
            color: Colors.red,
          ),
        ],
      );
    });
    

    return BarChart(
      BarChartData(
        maxY: 20,
        minY: 0,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

        ),
        barGroups: barGroups, // Use the updated barGroups list
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text("Sun", style: style);
      break;
    case 1:
      text = Text("Mon", style: style);
      break;
    case 2:
      text = Text("Tue", style: style);
      break;
    case 3:
      text = Text("Wed", style: style);
      break;
    case 4:
      text = Text("Thu", style: style);
      break;
    case 5:
      text = Text("Fri", style: style);
      break;
    case 6:
      text = Text("Sat", style: style);
      break;
    default:
      text = Text("", style: style);
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
