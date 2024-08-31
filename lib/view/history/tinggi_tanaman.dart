import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../provider/penanaman_provider.dart';

class TinggiTanamanPage extends StatefulWidget {
  final VoidCallback onBack;

  const TinggiTanamanPage({Key? key, required this.onBack}) : super(key: key);

  @override
  _TinggiTanamanPageState createState() => _TinggiTanamanPageState();
}

class _TinggiTanamanPageState extends State<TinggiTanamanPage> {
  String? _selectedPenanaman;
  bool _isDropdownLoading = false;
  Map<String, dynamic>? _penanamanData;

  @override
  void initState() {
    super.initState();
    _fetchPenanamanData();
  }

  Future<void> _fetchPenanamanData() async {
    setState(() {
      _isDropdownLoading = true;
    });
    await Provider.of<PenanamanProvider>(context, listen: false).fetchPenanamanData();
    setState(() {
      _isDropdownLoading = false;
    });
  }

  Future<void> _fetchLogTinggiTanamanData(int idPenanaman) async {
    setState(() {
      _isDropdownLoading = true;
    });
    try {
      await Provider.of<PenanamanProvider>(context, listen: false).fetchLogTinggiTanamanData(idPenanaman);
      final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);
      setState(() {
        _penanamanData = penanamanProvider.plantingData.firstWhere((data) => data['id'] == idPenanaman);
      });
    } catch (error) {
      print('Error fetching log tinggi tanaman data: $error');
    } finally {
      setState(() {
        _isDropdownLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final penanamanProvider = Provider.of<PenanamanProvider>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: SingleChildScrollView(
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
                    'Detail Tinggi Tanaman',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_isDropdownLoading || penanamanProvider.isLoading)
                CircularProgressIndicator()
              else
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      hint: Text('Pilih Penanaman'),
                      value: _selectedPenanaman,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.green),
                        ),
                      ),
                      items: penanamanProvider.plantingData.map((data) {
                        return DropdownMenuItem<String>(
                          value: data['id'].toString(),
                          child: Text(data['nama_penanaman'] ?? 'Unknown'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPenanaman = newValue;
                          _fetchLogTinggiTanamanData(int.parse(newValue!));
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    if (_penanamanData != null && penanamanProvider.logTinggiTanaman.isNotEmpty)
                      ...?penanamanProvider.logTinggiTanaman[int.parse(_selectedPenanaman!)]?.map((log) => _buildDetailCard(log)).toList().reversed,
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(Map<String, dynamic> log) {
    final tanggalTanam = DateTime.parse(_penanamanData!['tanggal_tanam']);
    final tanggalPencatatan = DateTime.parse(log['tanggal_pencatatan']);
    final hariSetelahTanam = tanggalPencatatan.difference(tanggalTanam).inDays;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _penanamanData!['nama_penanaman'],
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tanggal Tanam', style: AppTextStyles.bodyMedium),
              Text(DateFormat('dd MMMM yyyy').format(tanggalTanam), style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hari Setelah Tanam', style: AppTextStyles.bodyMedium),
              Text('$hariSetelahTanam hari', style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tinggi Tanaman', style: AppTextStyles.bodyMedium),
              Text('${log['tinggi_tanaman']} mm', style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pengukuran Terakhir', style: AppTextStyles.bodyMedium),
              Text(DateFormat('dd MMMM yyyy').format(tanggalPencatatan), style: AppTextStyles.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
