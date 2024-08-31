import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nurtura/provider/lahan_provider.dart';
import 'package:nurtura/theme/colors.dart';

class DaftarLahanPage extends StatefulWidget {
  final VoidCallback onBack;
  final Function(int) onDetailLahan; // Callback for navigating to detail lahan

  const DaftarLahanPage({super.key, required this.onBack, required this.onDetailLahan});

  @override
  _DaftarLahanPageState createState() => _DaftarLahanPageState();
}

class _DaftarLahanPageState extends State<DaftarLahanPage> {
  @override
  void initState() {
    super.initState();
    _fetchLahanData();
  }

  Future<void> _fetchLahanData() async {
    final lahanProvider = Provider.of<LahanProvider>(context, listen: false);
    try {
      await lahanProvider.fetchLahanData();
      if (lahanProvider.lahanData.isNotEmpty) {
        lahanProvider.selectLahan(lahanProvider.lahanData.first);
      } else {
        lahanProvider.selectLahan(null);
      }
    } catch (error) {
      print('Error fetching lahan data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Consumer<LahanProvider>(
          builder: (context, lahanProvider, child) {
            if (lahanProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (lahanProvider.lahanData.isEmpty) {
              return const Center(child: Text('No lahan data available'));
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
                        'Daftar Lahan',
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
                          itemCount: lahanProvider.lahanData.length,
                          itemBuilder: (context, index) {
                            final lahan = lahanProvider.lahanData[index];
                            return ListTile(
                              title: Text(lahan['nama_lahan']),
                              subtitle: Text('Deskripsi: ${lahan['deskripsi'] ?? 'No Description Available'}'),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward, color: AppColors.primaryColor),
                                onPressed: () {
                                  widget.onDetailLahan(lahan['id']); // Use the callback to navigate
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
