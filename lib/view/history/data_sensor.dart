import 'package:flutter/material.dart';
import 'package:nurtura/components/auth_button.dart';
import 'package:nurtura/components/sensor_data_chart.dart';
import 'package:nurtura/provider/penanaman_provider.dart';
import 'package:nurtura/provider/sensor_provider.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:nurtura/theme/text_styles.dart';
import 'package:provider/provider.dart';

class DataSensorPage extends StatefulWidget {
  final VoidCallback onBack;

  const DataSensorPage({Key? key, required this.onBack}) : super(key: key);

  @override
  State<DataSensorPage> createState() => _DataSensorPageState();
}

class _DataSensorPageState extends State<DataSensorPage> {
  String? _selectedSensorType;
  int? _selectedPenanamanId;

  @override
  void initState() {
    super.initState();
    _fetchPenanamanData();
    _fetchLatestSensorData();
  }

  void _fetchPenanamanData() {
    final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);
    penanamanProvider.fetchPenanamanData();
  }

  void _fetchLatestSensorData() {
    final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
    sensorProvider.fetchLatestSensorData();
  }

  Future<void> _fetchSpecificSensorData() async {
    if (_selectedPenanamanId != null && _selectedSensorType != null) {
      final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
      await sensorProvider.fetchSpecificSensorData(_selectedPenanamanId!, _selectedSensorType!);
    }
  }

  void _onSensorTypeChanged(String? newValue) {
    setState(() {
      _selectedSensorType = newValue;
      _fetchSpecificSensorData();
    });
  }

  void _onPenanamanChanged(int? newValue) {
    setState(() {
      _selectedPenanamanId = newValue;
      _fetchSpecificSensorData();
    });
  }

  void _showDateFilterDialog(BuildContext context) {
    DateTimeRange? selectedDateRange;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Filter Tanggal',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedDateRange = DateTimeRange(
                                  start: DateTime.now().subtract(Duration(days: 1)),
                                  end: DateTime.now(),
                                );
                                Navigator.pop(context);
                              });
                              final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
                              sensorProvider.filterDataByDateRange(
                                selectedDateRange!.start,
                                selectedDateRange!.end,
                              );
                            },
                            child: Text('Hari ini', style: TextStyle(color: AppColors.primaryColor)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black12),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedDateRange = DateTimeRange(
                                  start: DateTime.now().subtract(Duration(days: 2)),
                                  end: DateTime.now(),
                                );
                                Navigator.pop(context);
                              });
                              final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
                              sensorProvider.filterDataByDateRange(
                                selectedDateRange!.start,
                                selectedDateRange!.end,
                              );
                            },
                            child: Text('Kemarin', style: TextStyle(color: AppColors.primaryColor)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black12),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedDateRange = DateTimeRange(
                                  start: DateTime.now().subtract(Duration(days: 8)),
                                  end: DateTime.now(),
                                );
                                Navigator.pop(context);
                              });
                              final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
                              sensorProvider.filterDataByDateRange(
                                selectedDateRange!.start,
                                selectedDateRange!.end,
                              );
                            },
                            child: Text('7 Hari', style: TextStyle(color: AppColors.primaryColor)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black12),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedDateRange = DateTimeRange(
                                  start: DateTime.now().subtract(Duration(days: 31)),
                                  end: DateTime.now(),
                                );
                                Navigator.pop(context);
                              });
                              final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
                              sensorProvider.filterDataByDateRange(
                                selectedDateRange!.start,
                                selectedDateRange!.end,
                              );
                            },
                            child: Text('30 Hari', style: TextStyle(color: AppColors.primaryColor)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black12),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              selectedDateRange = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: AppColors.primaryColor,
                                      accentColor: AppColors.primaryColor,
                                      colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
                                      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                      dialogTheme: DialogTheme(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (selectedDateRange != null) {
                                setState(() {});
                                final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
                                sensorProvider.filterDataByDateRange(
                                  selectedDateRange!.start,
                                  selectedDateRange!.end,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Input Tanggal', style: TextStyle(color: AppColors.primaryColor)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black12),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Tutup', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _calculateFilteredDays(List<Map<String, dynamic>> filteredData) {
    if (filteredData.isEmpty) return 0;

    DateTime firstDate = DateTime.parse(filteredData.first['timestamp_pengukuran']);
    DateTime lastDate = DateTime.parse(filteredData.last['timestamp_pengukuran']);

    return lastDate.difference(firstDate).inDays + 1;
  }

  String getDisplaySensorType(String? sensorType) {
    switch (sensorType) {
      case 'suhu':
        return 'Suhu';
      case 'kelembapan_udara':
        return 'Kelembapan Udara';
      case 'kelembapan_tanah':
        return 'Kelembapan Tanah';
      case 'ph_tanah':
        return 'PH Tanah';
      case 'nitrogen':
        return 'Nitrogen';
      case 'fosfor':
        return 'Fosfor';
      case 'kalium':
        return 'Kalium';
      default:
        return 'Unknown sensor type';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = Provider.of<SensorProvider>(context);
    final penanamanProvider = Provider.of<PenanamanProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: widget.onBack,
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Data Sensor',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (penanamanProvider.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.primaryColor),
                                ),
                              ),
                              hint: const Text(
                                'Pilih penanaman',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                ),
                              ),
                              value: penanamanProvider.plantingData.contains(_selectedPenanamanId)
                                  ? _selectedPenanamanId
                                  : null,
                              onChanged: _onPenanamanChanged,
                              items: penanamanProvider.plantingData.map((penanaman) {
                                return DropdownMenuItem<int>(
                                  value: penanaman['id'],
                                  child: Text(penanaman['nama_penanaman'], style: const TextStyle(fontSize: 10)),
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.primaryColor),
                              ),
                            ),
                            hint: const Text(
                              'Pilih data sensor',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                            value: _selectedSensorType,
                            onChanged: _onSensorTypeChanged,
                            items: const [
                              DropdownMenuItem(value: 'suhu', child: Text('Suhu', style: const TextStyle(fontSize: 10))),
                              DropdownMenuItem(
                                  value: 'kelembapan_udara',
                                  child: Text('Kelembapan Udara', style: const TextStyle(fontSize: 10))),
                              DropdownMenuItem(
                                  value: 'kelembapan_tanah',
                                  child: Text('Kelembapan Tanah', style: const TextStyle(fontSize: 10))),
                              DropdownMenuItem(value: 'ph_tanah', child: Text('pH Tanah', style: const TextStyle(fontSize: 10))),
                              DropdownMenuItem(value: 'nitrogen', child: Text('Nitrogen', style: const TextStyle(fontSize: 10))),
                              DropdownMenuItem(value: 'fosfor', child: Text('Fosfor', style: const TextStyle(fontSize: 10))),
                              DropdownMenuItem(value: 'kalium', child: Text('Kalium', style: const TextStyle(fontSize: 10))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                        child: AuthButton(
                          text: 'Filter Tanggal',
                          onPressed: () => _showDateFilterDialog(context),
                          color: AppColors.primaryColor,
                        ),
                      )
                    ]),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Data Sensor ${getDisplaySensorType(_selectedSensorType)} selama ${_calculateFilteredDays(sensorProvider.filteredSensorData)} Hari Terakhir',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          sensorProvider.isLoading
                              ? Center(child: CircularProgressIndicator())
                              : sensorProvider.filteredSensorData.isEmpty
                              ? Center(child: Text('No data available'))
                              : SensorDataChart(
                            sensorData: sensorProvider.filteredSensorData,
                            sensorType: _selectedSensorType ?? '',
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
    );
  }
}
