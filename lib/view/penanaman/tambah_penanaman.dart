import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nurtura/provider/lahan_provider.dart';
import 'package:nurtura/provider/penanaman_provider.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/text_styles.dart';

class AddPenanamanPage extends StatefulWidget {
  final VoidCallback onBack;

  const AddPenanamanPage({super.key, required this.onBack});

  @override
  _AddPenanamanPageState createState() => _AddPenanamanPageState();
}

class _AddPenanamanPageState extends State<AddPenanamanPage> {
  final TextEditingController _namaPenanamanController = TextEditingController();
  final TextEditingController _tanggalTanamController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  DateTime? _selectedDateTanam;
  bool _isLoading = true;
  int? _userId;
  String? _token;
  String? _selectedJenisTanaman;

  @override
  void initState() {
    super.initState();
    _loadLahanData();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    final token = prefs.getString('token');

    if (userString != null) {
      final user = jsonDecode(userString) as Map<String, dynamic>;
      setState(() {
        _userId = user['id'];
        _token = token;
      });

      // Print retrieved values for debugging
      print('Loaded User ID: $_userId');
      print('Loaded Token: $_token');
    } else {
      print('No user data found');
    }
  }

  Future<void> _loadLahanData() async {
    try {
      final lahanProvider = Provider.of<LahanProvider>(context, listen: false);
      await lahanProvider.fetchLahanData();
    } catch (error) {
      print('Error loading lahan data: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitPenanaman() async {
    final lahanProvider = Provider.of<LahanProvider>(context, listen: false);
    final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);

    // Ensure user ID and token are loaded
    print(_userId);
    print(_token);
    if (_userId == null || _token == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User not logged in or token missing'),
      ));
      return;
    }

    if (lahanProvider.selectedLahan == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a lahan'),
      ));
      return;
    }

    final Map<String, dynamic> data = {
      "id_user": _userId,
      "id_lahan": lahanProvider.selectedLahan!['id'],
      "nama_penanaman": _namaPenanamanController.text,
      "jenis_tanaman": _selectedJenisTanaman == 'Bawang Merah' ? 'bawang_merah' : '',
      "tanggal_tanam": _tanggalTanamController.text + " 00:00:00",
      "keterangan": _keteranganController.text,
    };

    try {
      final message = await penanamanProvider.addPenanaman(data, _token!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
      widget.onBack();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lahanProvider = Provider.of<LahanProvider>(context);

    return SafeArea(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
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
                    'Tambah Penanaman',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    DropdownButtonFormField<Map<String, dynamic>>(
                      decoration: InputDecoration(
                        hintText: 'Pilih Lahan',
                        labelText: 'Pilih Lahan',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.primaryColor),
                        ),
                      ),
                      hint: const Text(
                        'Pilih Lahan',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      value: lahanProvider.lahanDataUnassigned.contains(
                          lahanProvider.selectedLahan)
                          ? lahanProvider.selectedLahan
                          : null,
                      items: lahanProvider.lahanDataUnassigned.map((lahan) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: lahan,
                          child: Text(lahan['nama_lahan']),
                        );
                      }).toList(),
                      onChanged: (lahan) {
                        lahanProvider.selectLahan(lahan!);
                      },
                    ),
                    const SizedBox(height: 16),
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
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Jenis Tanaman',
                        labelText: 'Jenis Tanaman',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.primaryColor),
                        ),
                      ),
                      hint: const Text(
                        'Pilih Jenis Tanaman',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      value: _selectedJenisTanaman,
                      items: ['Bawang Merah'].map((jenis) {
                        return DropdownMenuItem<String>(
                          value: jenis,
                          child: Text(jenis),
                        );
                      }).toList(),
                      onChanged: (jenis) {
                        setState(() {
                          _selectedJenisTanaman = jenis;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _tanggalTanamController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDateTanam = pickedDate;
                            _tanggalTanamController.text = DateFormat('yyyy-MM-dd')
                                .format(pickedDate);
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Tanggal Tanam',
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
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitPenanaman,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            ),
                            child: const Text('Tambah'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.onBack,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: AppColors.primaryColor),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
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
