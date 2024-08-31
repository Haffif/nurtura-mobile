import 'package:flutter/material.dart';
import 'package:nurtura/provider/lahan_provider.dart';
import 'package:nurtura/provider/penanaman_provider.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DetailPenanamanPage extends StatefulWidget {
  final Map<String, dynamic> penanamanData;
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onEdit;

  const DetailPenanamanPage({
    Key? key,
    required this.penanamanData,
    required this.onBack,
    required this.onEdit,
  }) : super(key: key);

  @override
  _DetailPenanamanPageState createState() => _DetailPenanamanPageState();
}

class _DetailPenanamanPageState extends State<DetailPenanamanPage> {
  late TextEditingController _namaPenanamanController;
  late TextEditingController _keteranganController;
  late TextEditingController _tanggalTanamController;
  late TextEditingController _tanggalPanenController;
  late TextEditingController _namaLahanController;
  String token = "";
  double progress = 0.0;
  int daysElapsed = 0;

  @override
  void initState() {
    super.initState();
    _namaPenanamanController = TextEditingController(text: widget.penanamanData['nama_penanaman']);
    _keteranganController = TextEditingController(text: widget.penanamanData['keterangan']);
    _namaLahanController = TextEditingController();
    _tanggalTanamController = TextEditingController(text: widget.penanamanData['tanggal_tanam']);
    _tanggalPanenController = TextEditingController(text: widget.penanamanData['tanggal_panen']);
    _fetchLahanData();
    _calculateProgress();
  }

  @override
  void dispose() {
    _namaPenanamanController.dispose();
    _keteranganController.dispose();
    _namaLahanController.dispose();
    _tanggalTanamController.dispose();
    _tanggalPanenController.dispose();
    super.dispose();
  }

  Future<void> _fetchLahanData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      throw Exception('Token not found');
    }

    final lahanProvider = Provider.of<LahanProvider>(context, listen: false);
    try {
      final lahanData = await lahanProvider.fetchLahanById(widget.penanamanData['id_lahan'], token);
      setState(() {
        _namaLahanController.text = lahanData['nama_lahan'] ?? 'Unknown';
      });
    } catch (error) {
      print('Error fetching lahan data: $error');
    }
  }

  void _calculateProgress() {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateTime tanggalTanam = dateFormat.parse(widget.penanamanData['tanggal_tanam']);
    final DateTime today = DateTime.now();
    final int daysElapsed = today.difference(tanggalTanam).inDays;
    setState(() {
      progress = (daysElapsed / 60).clamp(0.0, 1.0);
      this.daysElapsed = daysElapsed;
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toIso8601String().split('T')[0]; // Format date as yyyy-MM-dd
      });
    }
  }

  Future<void> _deletePenanaman() async {
    final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);
    final int idPenanaman = widget.penanamanData['id'];

    try {
      final message = await penanamanProvider.deletePenanaman(idPenanaman);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      widget.onBack(); // Call onBack to navigate back
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Apakah anda yakin ingin menghapus penanaman ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deletePenanaman();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
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
                    'Detail Penanaman',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _namaPenanamanController,
                      decoration: InputDecoration(
                        hintText: 'Nama Penanaman',
                        labelText: 'Nama Penanaman',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFFE8ECF4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _keteranganController,
                      decoration: InputDecoration(
                        hintText: 'Keterangan',
                        labelText: 'Keterangan',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFFE8ECF4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _namaLahanController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Nama Lahan',
                        labelText: 'Nama Lahan',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFFE8ECF4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _tanggalTanamController,
                      readOnly: true,
                      onTap: () => _selectDate(context, _tanggalTanamController),
                      decoration: InputDecoration(
                        hintText: 'YYYY-MM-DD',
                        labelText: 'Tanggal Tanam',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFFE8ECF4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.penanamanData['tanggal_panen'] != null && widget.penanamanData['tanggal_panen'].isNotEmpty)
                      TextField(
                        controller: _tanggalPanenController,
                        readOnly: true,
                        onTap: () => _selectDate(context, _tanggalPanenController),
                        decoration: InputDecoration(
                          hintText: 'YYYY-MM-DD',
                          labelText: 'Tanggal Panen',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color(0xFFE8ECF4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                          minHeight: 16,
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('$daysElapsed dari 60 hari'),
                    const SizedBox(height: 16),
                    Text(
                      'Status Penanaman: ${widget.penanamanData['tanggal_panen'] != null && widget.penanamanData['tanggal_panen'].isNotEmpty ? 'Non Aktif' : 'Aktif'}',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onEdit(widget.penanamanData);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            ),
                            child: const Text('Edit'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showDeleteConfirmationDialog,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            ),
                            child: const Text('Hapus'),
                          ),
                        ),
                      ],
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
