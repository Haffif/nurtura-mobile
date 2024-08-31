import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/sensor_provider.dart';
import '../../provider/penanaman_provider.dart';
import '../../theme/colors.dart';

class AksiAlatPage extends StatefulWidget {
  final VoidCallback onBack;

  const AksiAlatPage({Key? key, required this.onBack}) : super(key: key);

  @override
  State<AksiAlatPage> createState() => _AksiAlatPageState();
}

class _AksiAlatPageState extends State<AksiAlatPage> {
  int? _selectedPenanamanId;

  @override
  void initState() {
    super.initState();
    _fetchPenanamanData();
  }

  Future<void> _fetchPenanamanData() async {
    final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);
    await penanamanProvider.fetchPenanamanData();
  }

  Future<void> _fetchDeviceActions() async {
    if (_selectedPenanamanId != null) {
      final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
      await sensorProvider.fetchDeviceActions(_selectedPenanamanId!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a penanaman first')),
      );
    }
  }

  void _onPenanamanChanged(int? newValue) {
    setState(() {
      _selectedPenanamanId = newValue;
    });
    _fetchDeviceActions();
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = Provider.of<SensorProvider>(context);
    final penanamanProvider = Provider.of<PenanamanProvider>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
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
                  'Riwayat Aksi Alat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: penanamanProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<int>(
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
                        fontSize: 14,
                      ),
                    ),
                    value: _selectedPenanamanId,
                    onChanged: _onPenanamanChanged,
                    items: penanamanProvider.plantingData.map((penanaman) {
                      return DropdownMenuItem<int>(
                        value: penanaman['id'],
                        child: Text(penanaman['nama_penanaman'], style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: sensorProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: sensorProvider.deviceActions.length,
                itemBuilder: (context, index) {
                  final action = sensorProvider.deviceActions[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text('Pengairan', style: TextStyle(color: AppColors.primaryColor)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height:4),
                          Text('Vol: ${action['volume']} L', style: TextStyle(color: Colors.black)),
                          Text('Durasi: ${action['durasi']}s', style: TextStyle(color: Colors.black)),
                          Text('Mode: ${action['mode']}', style: TextStyle(color: Colors.black)),
                          Text('Waktu: ${action['start']} - ${action['end']}', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      trailing: Text(
                        action['isActive'] == 1
                            ? 'Aktif'
                            : action['isPending'] == 1
                            ? 'Pending'
                            : 'Nonaktif',
                        style: TextStyle(
                          color: action['isActive'] == 1
                              ? Colors.green
                              : action['isPending'] == 1
                              ? Colors.orange
                              : Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
