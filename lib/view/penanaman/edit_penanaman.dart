import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nurtura/provider/penanaman_provider.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/text_styles.dart';

class EditPenanamanPage extends StatefulWidget {
  final Map<String, dynamic> penanamanData;
  final VoidCallback onBack;

  const EditPenanamanPage({super.key, required this.penanamanData, required this.onBack});

  @override
  _EditPenanamanPageState createState() => _EditPenanamanPageState();
}

class _EditPenanamanPageState extends State<EditPenanamanPage> {
  final TextEditingController _namaPenanamanController = TextEditingController();
  final TextEditingController _tanggalTanamController = TextEditingController();
  final TextEditingController _tanggalPanenController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  bool _isToggleOn = false;
  bool _isLoading = true;
  int? _userId;
  String? _token;
  String? _selectedJenisTanaman;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _populateFields();
  }

  void _populateFields() {
    _namaPenanamanController.text = widget.penanamanData['nama_penanaman'];
    _tanggalTanamController.text = widget.penanamanData['tanggal_tanam'];
    _tanggalPanenController.text = widget.penanamanData['tanggal_panen'] ?? '';
    _keteranganController.text = widget.penanamanData['keterangan'];
    _isToggleOn = _tanggalPanenController.text.isNotEmpty;
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

  Future<void> _submitPenanaman() async {
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

    final Map<String, dynamic> data = {
      "id_penanaman": widget.penanamanData['id'],
      "id_user": _userId,
      "nama_penanaman": _namaPenanamanController.text,
      "jenis_tanaman": _selectedJenisTanaman == 'Bawang Merah' ? 'bawang_merah' : '',
      "tanggal_tanam": _tanggalTanamController.text + " 00:00:00",
      "keterangan": _keteranganController.text,
    };

    if (_isToggleOn) {
      data["tanggal_panen"] = _tanggalPanenController.text + " 00:00:00";
    } else {
      data["tanggal_panen"] = null;
    }

    try {
      final message = await penanamanProvider.updatePenanaman(data);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Penanaman'),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
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
                        _tanggalTanamController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
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
                if (_isToggleOn)
                  TextField(
                    controller: _tanggalPanenController,
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
                          _tanggalPanenController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Tanggal Panen',
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
                Row(
                  children: [
                    Switch(
                      activeColor: AppColors.primaryColor,
                      value: _isToggleOn,
                      onChanged: (value) {
                        setState(() {
                          _isToggleOn = value;
                          if (!value) {
                            _tanggalPanenController.clear();
                          }
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 12),
                          children: [
                            TextSpan(text: 'Penanaman '),
                            TextSpan(
                              text: _isToggleOn ? 'sedang berlangsung' : 'sudah selesai',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                            TextSpan(
                              text: _isToggleOn
                                  ? ', tekan tombol di samping untuk menambahkan tanggal panen'
                                  : ', tekan tombol di kiri untuk menandakan penanaman sedang berlangsung',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                        child: const Text('Update'),
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
        ),
      ),
    );
  }
}
