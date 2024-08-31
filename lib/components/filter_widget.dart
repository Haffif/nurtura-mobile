import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/sensor_provider.dart';

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  DateTime? _startDate;
  DateTime? _endDate;

  void _onDateRangeSelected(DateTimeRange? dateRange) {
    if (dateRange != null) {
      setState(() {
        _startDate = dateRange.start;
        _endDate = dateRange.end;
      });
      final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
      sensorProvider.filterDataByDateRange(_startDate!, _endDate!);
    }
  }

  void _onFilterButtonPressed() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then(_onDateRangeSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Filter Tanggal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: () => _onDateRangeSelected(DateTimeRange(start: DateTime.now(), end: DateTime.now())), child: Text('Hari ini')),
            ElevatedButton(onPressed: () => _onDateRangeSelected(DateTimeRange(start: DateTime.now().subtract(Duration(days: 1)), end: DateTime.now().subtract(Duration(days: 1)))), child: Text('Kemarin')),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: () => _onDateRangeSelected(DateTimeRange(start: DateTime.now().subtract(Duration(days: 7)), end: DateTime.now())), child: Text('7 hari')),
            ElevatedButton(onPressed: () => _onDateRangeSelected(DateTimeRange(start: DateTime.now().subtract(Duration(days: 30)), end: DateTime.now())), child: Text('30 hari')),
          ],
        ),
        SizedBox(height: 16),
        Text('Input tanggal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text('Input tanggal'),
                onPressed: _onFilterButtonPressed,
              ),
            ),
          ],
        ),
        if (_startDate != null && _endDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Mulai: ${DateFormat('dd MMM yyyy').format(_startDate!)}\nSelesai: ${DateFormat('dd MMM yyyy').format(_endDate!)}'),
          ),
      ],
    );
  }
}
