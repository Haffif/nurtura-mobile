import 'package:flutter/material.dart';
import 'package:nurtura/components/detail_button.dart';
import 'package:nurtura/provider/penanaman_provider.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:provider/provider.dart';

class DaftarPenanamanPage extends StatefulWidget {
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onDetailPenanaman;

  const DaftarPenanamanPage({super.key, required this.onBack, required this.onDetailPenanaman});

  @override
  State<DaftarPenanamanPage> createState() => _DaftarPenanamanPageState();
}

class _DaftarPenanamanPageState extends State<DaftarPenanamanPage> {
  @override
  void initState() {
    super.initState();
    _fetchPenanamanData();
  }

  Future<void> _fetchPenanamanData() async {
    final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);
    try {
      await penanamanProvider.fetchPenanamanData();
    } catch (error) {
      print('Error fetching penanaman data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Consumer<PenanamanProvider>(
          builder: (context, penanamanProvider, child) {
            if (penanamanProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (penanamanProvider.plantingData.isEmpty) {
              return const Center(child: Text('No planting data available'));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
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
                        'Daftar Penanaman',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: penanamanProvider.plantingData.length,
                          itemBuilder: (context, index) {
                            final planting = penanamanProvider.plantingData[index];
                            return ListTile(
                              title: Text(planting['nama_penanaman'] ?? 'Unknown'),
                              subtitle: Text('Ditanam pada ${planting['tanggal_tanam'] ?? 'No Date Available'}'),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward, color: AppColors.primaryColor),
                                onPressed: () {
                                  widget.onDetailPenanaman(planting);
                                },
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
