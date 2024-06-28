import 'package:flutter/material.dart';
import 'package:nurtura_grow/components/app_name.dart';
import 'package:nurtura_grow/components/auth_button.dart';
import 'package:nurtura_grow/components/map_component.dart';
import 'package:nurtura_grow/screens/profile_screens.dart';
import 'package:nurtura_grow/theme/colors.dart';
import 'package:nurtura_grow/theme/text_styles.dart';

class TinggiTanamanScreen extends StatefulWidget {
  const TinggiTanamanScreen({super.key});

  @override
  State<TinggiTanamanScreen> createState() => _TinggiTanamanScreenState();
}

class _TinggiTanamanScreenState extends State<TinggiTanamanScreen> {
  void _toProfile() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ProfileScreen()),
    // );
  }

  void _addManualTinggi() {
    // Add lahan logic here
  }

  String? _selectedLahan;
  final List<String> _lahanOptions = <String>['Lahan 1', 'Lahan 2', 'Lahan 3'];

  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  bool _isPlanting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      width: 36,
                    ),
                    const SizedBox(width: 8),
                    const AppName(
                      textSize: 18,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: _toProfile,
                    icon: const Icon(
                        Icons.person,
                        color: Colors.black87
                    )
                )
              ],
            ),

          ],
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Manual Tinggi Tanaman',
                        style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nama Penanaman',
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),

                              DropdownButtonFormField<String>(
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
                                  'Pilih Lahan',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                                value: _selectedLahan,
                                items: _lahanOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedLahan = newValue;
                                  });
                                },
                              ),

                              const SizedBox(height: 12),

                              const Text(
                                'Tanggal Pencatatan',
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _dateController,
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  hintText: 'DD/MM/YYYY',
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
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
                              ),

                              const SizedBox(height: 12),

                              const Text(
                                'Tinggi Tanaman',
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: '10',
                                        hintStyle: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 12),
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
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        hintText: 'mm',
                                        hintStyle: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 12),
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
                                  const SizedBox(width: 160,)
                                ],
                              ),

                              const SizedBox(height: 16),


                              Row(
                                children: [
                                  Expanded(child: AuthButton(text: 'Masukkan', onPressed: _addManualTinggi, color: AppColors.primaryColor)),
                                ],
                              ),
                            ]
                        )
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
