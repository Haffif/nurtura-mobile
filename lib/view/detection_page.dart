import 'package:flutter/material.dart';
import 'package:nurtura/provider/detect_provider.dart';
import 'package:nurtura/provider/penanaman_provider.dart';
import 'package:nurtura/theme/text_styles.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import 'package:intl/intl.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({Key? key}) : super(key: key);

  @override
  _DetectionPageState createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  Map<String, dynamic>? selectedJenisTanaman;
  Map<String, dynamic>? selectedPenanaman;
  int selectedPlantIndex = 0;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PenanamanProvider>(context, listen: false).fetchPenanamanData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final penanamanProvider = Provider.of<PenanamanProvider>(context);
    final detectProvider = Provider.of<DetectProvider>(context);

    List<Map<String, dynamic>> uniqueJenisTanaman = penanamanProvider.plantingData
        .fold<List<Map<String, dynamic>>>([], (list, item) {
      if (list.every((element) => element['jenis_tanaman'] != item['jenis_tanaman'])) {
        list.add(item);
      }
      return list;
    });

    final plantData = detectProvider.plantConditionData.isNotEmpty
        ? detectProvider.plantConditionData[selectedPlantIndex]
        : null;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deteksi Kondisi Tanaman',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih jenis tanaman untuk melakukan pengecekan kondisi pada tanaman',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              Text(
                'Jenis Tanaman',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.34,
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        fillColor: Colors.white,
                        filled: true,
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
                        'Pilih jenis tanaman',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                        ),
                      ),
                      value: selectedJenisTanaman,
                      items: uniqueJenisTanaman.map((jenis) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: jenis,
                          child: Text(
                            jenis['jenis_tanaman'] == 'bawang_merah'
                                ? 'Bawang Merah'
                                : jenis['jenis_tanaman'],
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedJenisTanaman = value;
                          selectedPenanaman = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (selectedJenisTanaman != null)
                    Expanded(
                      child: DropdownButtonFormField<Map<String, dynamic>>(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          fillColor: Colors.white,
                          filled: true,
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
                              fontSize: 10),
                        ),
                        value: selectedPenanaman,
                        items: penanamanProvider.plantingData
                            .where((data) => data['jenis_tanaman'] == selectedJenisTanaman!['jenis_tanaman'])
                            .map((data) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: data,
                            child: Text(data['nama_penanaman'], style: const TextStyle(fontSize: 10)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPenanaman = value;
                          });
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: selectedPenanaman != null ? _selectDate : null,
                        child: const Text('Pilih Tanggal'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (detectProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (!detectProvider.isSuccess)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Data tidak ditemukan'),
                        Text('Mohon pilih jenis tanaman yang lain'),
                      ],
                    ),
                  ),
                )
              else if (plantData != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            plantData['url'],
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButton<int>(
                          value: selectedPlantIndex,
                          items: List.generate(
                            detectProvider.plantConditionData.length,
                                (index) => DropdownMenuItem<int>(
                              value: index,
                              child: Text('Tanaman ${index + 1}'),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedPlantIndex = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Id', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                            Text(plantData['id'] ?? 'Unknown'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Terakhir update', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                            Text(
                                plantData['updated_at'] != null
                                    ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(plantData['updated_at']))
                                    : 'Unknown'
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hasil Deteksi', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                            Text(plantData['detection'] ?? 'Unknown'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Akurasi', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                            Text('${(plantData['accuration'] * 100)?.toStringAsFixed(2) ?? 'Unknown'} %'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Posisi', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                            Text(plantData['posisi'] ?? 'Unknown'),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/planting1.png'),
                          const Text('Belum ada data'),
                          const Text('Mohon pilih jenis tanaman'),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _fetchPlantData();
    }
  }

  Future<void> _fetchPlantData() async {
    final detectProvider = Provider.of<DetectProvider>(context, listen: false);
    final idPenanaman = selectedPenanaman!['id'];
    await detectProvider.fetchPlantConditionData(idPenanaman, selectedJenisTanaman!['jenis_tanaman'], DateFormat('yyyy-MM-dd').format(selectedDate));
    setState(() {
      selectedPlantIndex = 0;
    });
  }
}
