import 'package:flutter/material.dart';
import 'package:nurtura_grow/components/app_name.dart';
import 'package:nurtura_grow/components/auth_button.dart';
import 'package:nurtura_grow/components/map_component.dart';
import 'package:nurtura_grow/screens/profile_screens.dart';
import 'package:nurtura_grow/theme/colors.dart';
import 'package:nurtura_grow/theme/text_styles.dart';

class AddPenanamanScreen extends StatefulWidget {
  const AddPenanamanScreen({super.key});

  @override
  State<AddPenanamanScreen> createState() => _AddPenanamanScreenState();
}

class _AddPenanamanScreenState extends State<AddPenanamanScreen> {
  void _toProfile() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ProfileScreen()),
    // );
  }

  void _addPenanaman() {
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
                        'Tambah Penanaman',
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
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Nama Penanaman',
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
                              const SizedBox(height: 12),
                              const Text(
                                'Keterangan',
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Keterangan',
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
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
                                'Pilih Lahan',
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
                                'Pilih Tanaman',
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
                                  'Pilih Tanaman',
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
                                'Tanggal Tanam',
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

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Switch(
                                    value: _isPlanting,
                                    onChanged: (value) {
                                      setState(() {
                                        _isPlanting = value;
                                      });
                                    },
                                    activeColor: AppColors.primaryColor,
                                  ),
                                  Expanded(
                                    child: RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Penanaman ',
                                            style: TextStyle(color: Colors.black, fontSize: 12),
                                          ),
                                          TextSpan(
                                            text: _isPlanting ? 'sedang berlangsung' : 'telah selesai',
                                            style: const TextStyle(color: AppColors.primaryColor, fontSize: 12),
                                          ),
                                          const TextSpan(
                                            text: ', tekan tombol disamping apabila penanaman telah selesai',
                                            style: TextStyle(color: Colors.black, fontSize: 12),
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
                                  Expanded(child: AuthButton(text: 'Tambah', onPressed: _addPenanaman, color: AppColors.primaryColor)),
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
