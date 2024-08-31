// add_lahan_page.dart

import 'package:flutter/material.dart';
import 'package:nurtura/components/auth_button.dart';
import 'package:nurtura/components/map_component.dart';
import 'package:nurtura/provider/lahan_provider.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/text_styles.dart';

class AddLahanPage extends StatefulWidget {
  final VoidCallback onBack;

  const AddLahanPage({Key? key, required this.onBack}) : super(key: key);
  @override
  _AddLahanPageState createState() => _AddLahanPageState();
}

class _AddLahanPageState extends State<AddLahanPage> {
  final TextEditingController _namaLahanController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController(text: 'NaN');
  final TextEditingController _longitudeController = TextEditingController(text: 'NaN');

  void _onLocationSelected(double latitude, double longitude) {
    setState(() {
      _latitudeController.text = latitude.toString();
      _longitudeController.text = longitude.toString();
    });
  }

  Future<void> _addLahan() async {
    final lahanProvider = Provider.of<LahanProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || _latitudeController.text == 'NaN' || _longitudeController.text == 'NaN') {
      // Handle error
      return;
    }

    try {
      final response = await lahanProvider.addLahan(
        _namaLahanController.text,
        _deskripsiController.text,
        double.parse(_latitudeController.text),
        double.parse(_longitudeController.text),
        token,
      );
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        _namaLahanController.clear();
        _deskripsiController.clear();
        _latitudeController.text = 'NaN';
        _longitudeController.text = 'NaN';
        widget.onBack();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add lahan')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text('Tambah Lahan',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Nama Lahan',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _namaLahanController,
                decoration: InputDecoration(
                  hintText: 'Nama Lahan',
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
              SizedBox(height: 12),
              Text(
                'Deskripsi',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _deskripsiController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Deskripsi',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              SizedBox(height: 12),
              Text(
                'Koordinat',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _latitudeController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Latitude',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _longitudeController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Longitude',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
//-7.772139, 111.714134
//
// 
              SizedBox(
                height: 220,
                child: MapComponent(
                  initialLatitude: -7.772139,
                  initialLongitude: 111.714134,
                  onLocationSelected: _onLocationSelected,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Pindahkan tanda pada peta untuk memasukkan data koordinat secara otomatis',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AuthButton(
                      text: 'Tambah',
                      onPressed: _addLahan,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
