import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final daysOfWeek = [
    'Total (Sun-Sat)',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];
  final headers = [
    'Date',
    'Running Time',
    'Jogging Time',
    'Exercise Time',
    'Total Time',
    'Running Time Engagement %',
    'Jogging Time Engagement %',
    'Exercise Time Engagement %'
  ];
  final Random random = new Random();

  int timeToMinutes(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  String minutesToTime(int minutes) {
    int hours = minutes ~/ 60;
    minutes %= 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  List<String> calculateColumnTimesAndEngagements(List<String> column) {
    int runningTime = timeToMinutes(column[1]);
    int joggingTime = timeToMinutes(column[2]);
    int exerciseTime = timeToMinutes(column[3]);

    int totalTime = runningTime + joggingTime + exerciseTime;

    double runningEngagement = (runningTime / totalTime) * 100;
    double joggingEngagement = (joggingTime / totalTime) * 100;
    double exerciseEngagement = (exerciseTime / totalTime) * 100;

    return [
      minutesToTime(totalTime),
      runningEngagement.toStringAsFixed(2) + '%',
      joggingEngagement.toStringAsFixed(2) + '%',
      exerciseEngagement.toStringAsFixed(2) + '%',
    ];
  }

  String calculateTotalTimeForWeek(List<String> column) {
    int totalTimeForWeek = 0;
    for (int i = 1; i < column.length - 4; i++) {
      totalTimeForWeek += timeToMinutes(column[i]);
    }
    return minutesToTime(totalTimeForWeek);
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> content = List<List<String>>.generate(
      8,
      (i) => List<String>.generate(
        8,
        (j) {
          if (j == 0) {
            return '-'; // Placeholder, will be replaced later
          } else if (i == 0) {
            // Generate Dates
            DateTime date = DateTime.now().subtract(Duration(days: 8 - j));
            return DateFormat('dd/MMM/yyyy').format(date);
          } else {
            // Generate Random Time
            int hour = random.nextInt(24);
            int minute = random.nextInt(60);
            return '$hour:$minute';
          }
        },
      ),
    );

    // Transpose content for easier column-wise operations
    List<List<String>> transposedContent = List.generate(content[0].length,
        (i) => List.generate(content.length, (j) => content[j][i]));

    // Calculate total times and engagements
    for (int i = 1; i < transposedContent.length; i++) {
      List<String> results =
          calculateColumnTimesAndEngagements(transposedContent[i]);
      transposedContent[i][4] = results[0]; // Total Time
      transposedContent[i][5] = results[1]; // Running Engagement
      transposedContent[i][6] = results[2]; // Jogging Engagement
      transposedContent[i][7] = results[3]; // Exercise Engagement
    }

    // Calculate total times for the week
    for (int i = 1; i < 5; i++) {
      List<String> column = List.generate(
          transposedContent.length, (j) => transposedContent[j][i]);
      String totalTimeForWeek = calculateTotalTimeForWeek(column);
      transposedContent[0][i] = totalTimeForWeek;
    }

    // Transpose content back
    content = List.generate(
        transposedContent[0].length,
        (i) => List.generate(
            transposedContent.length, (j) => transposedContent[j][i]));

    return Scaffold(
      appBar: AppBar(
        title: Text('Sportsperson Timings'),
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Center(
                child: Text('Please switch to landscape mode'),
              );
            } else {
              return StickyHeadersTable(
                columnsLength: daysOfWeek.length,
                rowsLength: headers.length,
                columnsTitleBuilder: (i) => Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Text(daysOfWeek[i]),
                ),
                rowsTitleBuilder: (i) => Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Text(headers[i]),
                ),
                contentCellBuilder: (i, j) => Text(content[j][i]),
                legendCell: Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Text('Total Info for the WEEK'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
