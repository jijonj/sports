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

  String totalTimeForRow(List<String> row) {
    int totalHours = 0;
    int totalMinutes = 0;

    for (int i = 1; i < row.length; i++) {
      List<String> timeParts = row[i].split(':');
      totalHours += int.parse(timeParts[0]);
      totalMinutes += int.parse(timeParts[1]);
    }

    totalHours += totalMinutes ~/ 60;
    totalMinutes %= 60;

    return '${totalHours.toString().padLeft(2, '0')}:${totalMinutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> content = List<List<String>>.generate(
      8,
      (i) => List<String>.generate(
        8,
        (j) {
          if (j == 0) {
            return 'Total'; // Placeholder, will be replaced later
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

    // Calculate total times
    for (int i = 1; i < content.length; i++) {
      content[i][0] = totalTimeForRow(content[i]);
    }

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
