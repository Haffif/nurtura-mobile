import 'package:flutter/material.dart';
import 'package:nurtura_grow/components/map_component.dart';
import 'package:nurtura_grow/theme/colors.dart';
import 'package:nurtura_grow/theme/text_styles.dart';

class MapLocationScreen extends StatefulWidget {
  const MapLocationScreen({super.key});

  @override
  State<MapLocationScreen> createState() => _MapLocationScreenState();
}

class _MapLocationScreenState extends State<MapLocationScreen> {
  String? dropdownValue;
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NurturaGrow'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Seluruh Sensor',
                style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    hint: const Text(
                        'Pilih data sensor',
                        selectionColor: Colors.grey,
                        style: TextStyle(fontSize: 12)),
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 16,
                    elevation: 0,
                    style: const TextStyle(color: AppColors.textColor),
                    borderRadius: BorderRadius.circular(4),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Suhu Udara', 'Kelembapan Udara', 'Kelembapan Tanah', 'pH Tanah', 'Nitrogen', 'Fosfor', 'Kalium']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                        .toList(),
                  ),
                  DropdownButton<String>(
                    hint: const Text(
                        'Pilih penanaman',
                        selectionColor: Colors.grey,
                        style: TextStyle(fontSize: 12)),
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 16,
                    elevation: 0,
                    style: const TextStyle(color: AppColors.textColor),
                    borderRadius: BorderRadius.circular(4),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Penanaman 1', 'Penanaman 2', 'Penanaman 3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                        .toList(),
                  ),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: () => _selectDate(context),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.date_range, size: 12),
                            SizedBox(width: 4),
                            Text('Pilih Tanggal', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 200,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Lokasi Lahan',
                style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 16),

              const SizedBox(
                height: 200,
                child: MapComponent(
                  endpointUrl: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  latitude: -7.282373,
                  longitude: 112.794899,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

