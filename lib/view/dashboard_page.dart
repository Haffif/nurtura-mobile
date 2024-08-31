import 'package:flutter/material.dart';
import 'package:nurtura/components/auth_button.dart';
import 'package:nurtura/components/circular_display.dart';
import 'package:nurtura/components/dashboard_menu.dart';
import 'package:nurtura/components/sensor_data_chart.dart';
import 'package:nurtura/provider/lahan_provider.dart';
import 'package:nurtura/provider/penanaman_provider.dart';
import 'package:nurtura/provider/sensor_provider.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:nurtura/theme/text_styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  final Function(int) onPageSelected;
  final Function(int) onLahanDetailSelected; // Add this callback

  const DashboardPage({
    Key? key,
    required this.onPageSelected,
    required this.onLahanDetailSelected, // Add this callback
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _selectedSensorType;
  int? _selectedPenanamanId;
  bool _isMapLoading = false;
  GoogleMapController? _mapController;

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

      final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);
      final penanaman = penanamanProvider.plantingData.firstWhere((element) => element['id'] == _selectedPenanamanId);
      final int idLahan = penanaman['id_lahan'];

      final lahanProvider = Provider.of<LahanProvider>(context, listen: false);
      setState(() {
        _isMapLoading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        print('Fetching lahan data for id: $idLahan'); // Debug
        await lahanProvider.fetchAndSelectLahanById(idLahan, token);
        print('Fetched lahan data: ${lahanProvider.fetchSelectedLahan}'); // Debug
      } else {
        print('Token is null'); // Debug
      }
      setState(() {
        _isMapLoading = false;
      });
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

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _moveToSelectedLahan(LatLng latLng) async {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 18.0),
        ),
      );
    }
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
    final lahanProvider = Provider.of<LahanProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Fitur Unggulan',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DashboardMenu(
                      onTap: () {
                        widget.onPageSelected(2); // Navigate to FeaturePage
                      },
                      text: 'Deteksi',
                      icon: const Icon(
                        Icons.monitor_heart_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    DashboardMenu(
                      onTap: () {
                        widget.onPageSelected(1); // Navigate to FeaturePage
                      },
                      text: 'Pengairan',
                      icon: const Icon(
                        Icons.water,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    DashboardMenu(
                      onTap: () {
                        widget.onPageSelected(1); // Navigate to FeaturePage
                      },
                      text: 'Pemupukan',
                      icon: const Icon(
                        Icons.landslide,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Data Sensor Terkini',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: sensorProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : sensorProvider.sensorData != null
                    ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CircularDisplay(
                            dataName: 'Suhu Udara',
                            progress: sensorProvider.sensorData!['suhu']?.toDouble() ?? 0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CircularDisplay(
                            dataName: 'Kelembapan Udara',
                            progress: sensorProvider.sensorData!['kelembapan_udara']?.toDouble() ?? 0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CircularDisplay(
                            dataName: 'Kelembapan Tanah',
                            progress: sensorProvider.sensorData!['kelembapan_tanah']?.toDouble() ?? 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CircularDisplay(
                            dataName: 'pH Tanah',
                            progress: sensorProvider.sensorData!['ph_tanah']?.toDouble() ?? 0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CircularDisplay(
                            dataName: 'Nitrogen',
                            progress: sensorProvider.sensorData!['nitrogen']?.toDouble() ?? 0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CircularDisplay(
                            dataName: 'Fosfor',
                            progress: sensorProvider.sensorData!['fosfor']?.toDouble() ?? 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CircularDisplay(
                            dataName: 'Kalium',
                            progress: sensorProvider.sensorData!['kalium']?.toDouble() ?? 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                    : const Center(child: Text('No data available')),
              ),
              const SizedBox(height: 16),
              if (sensorProvider.sensorData != null)
                Text('Data sensor terakhir: ${sensorProvider.sensorData!['timestamp_pengukuran']?.toString() ?? ''}'),
              const SizedBox(height: 16),
              Text(
                'Data Seluruh Sensor',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
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
                      padding: const EdgeInsets.symmetric(vertical:16.0, horizontal:8),
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Lokasi Lahan',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (lahanProvider.fetchSelectedLahan != null) {
                        widget.onLahanDetailSelected(lahanProvider.fetchSelectedLahan!['id']); // Call the navigation function
                        print('tap');
                      }
                    },
                    child: Text('Lihat selengkapnya', style: TextStyle(color: AppColors.primaryColor)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isMapLoading)
                Center(child: CircularProgressIndicator())
              else if (_selectedPenanamanId != null && lahanProvider.fetchSelectedLahan != null) ...[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        lahanProvider.fetchSelectedLahan!['latitude'],
                        lahanProvider.fetchSelectedLahan!['longitude'],
                      ),
                      zoom: 18.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('selected-lahan'),
                        position: LatLng(
                          lahanProvider.fetchSelectedLahan!['latitude'],
                          lahanProvider.fetchSelectedLahan!['longitude'],
                        ),
                      ),
                    },
                  ),
                ),
              ] else
                Center(child: Text('No lahan data available or penanaman not selected')),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
