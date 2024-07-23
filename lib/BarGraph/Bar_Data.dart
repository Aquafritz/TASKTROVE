import 'package:tasktroveprojects/BarGraph/Individual_Bar.dart';

class BarData{
  final double sunStatus;
  final double monStatus;
  final double tueStatus;
  final double wedStatus;
  final double thuStatus;
  final double friStatus;
  final double satStatus;

  BarData({
    required this.sunStatus,
    required this.monStatus,
    required this.tueStatus,
    required this.wedStatus,
    required this.thuStatus,
    required this.friStatus,
    required this.satStatus,
  });

    List<IndividualBar> barData =[];

    void initializeBarData(){
      barData = [
        IndividualBar(x: 0, y: sunStatus),

        IndividualBar(x: 1, y: monStatus),

        IndividualBar(x: 2, y: tueStatus),

        IndividualBar(x: 3, y: wedStatus),

        IndividualBar(x: 4, y: thuStatus),

        IndividualBar(x: 5, y: friStatus),

        IndividualBar(x: 6, y: satStatus),
      ];
    }
}