import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurtura/components/auth_button.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:provider/provider.dart';
import '../../provider/penanaman_provider.dart';
import '../../theme/text_styles.dart';

class ManualTinggiTanamanPage extends StatefulWidget {
  final VoidCallback onBack;

  const ManualTinggiTanamanPage({Key? key, required this.onBack}) : super(key: key);

  @override
  _ManualTinggiTanamanPageState createState() => _ManualTinggiTanamanPageState();
}

class _ManualTinggiTanamanPageState extends State<ManualTinggiTanamanPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPenanaman;
  DateTime _selectedDate = DateTime.now();
  double? _tinggiTanaman;
  bool _isDropdownLoading = false;

  final TextEditingController _tanggalTanamController = TextEditingController();

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
      final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);
      if (penanamanProvider.plantingData.isNotEmpty) {
        _selectedPenanaman = penanamanProvider.plantingData[0]['id'].toString();
      }
    });
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (_selectedPenanaman == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a penanaman')),
      );
      return;
    }

    final data = {
      'id_penanaman': int.parse(_selectedPenanaman!),
      'tanggal_pencatatan': _selectedDate.toIso8601String(),
      'tinggi_tanaman': _tinggiTanaman,
    };

    final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);
    try {
      final message = await penanamanProvider.updateTinggiTanaman(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      widget.onBack();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating tinggi tanaman: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final penanamanProvider = Provider.of<PenanamanProvider>(context);

    return SafeArea(
      child: penanamanProvider.isLoading || _isDropdownLoading
          ? Center(child: CircularProgressIndicator())
          : penanamanProvider.plantingData.isEmpty
          ? Center(child: Text('Tidak ada Penanaman'))
          : Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: widget.onBack,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 16),
                  Text('Manual Tinggi Tanaman',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
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
                      items: penanamanProvider.plantingData
                          .map((data) {
                        return DropdownMenuItem<String>(
                          value: data['id'].toString(),
                          child: Text(data['nama_penanaman'] ?? 'Unknown'),
                        );
                      })
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPenanaman = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a penanaman';
                        }
                        return null;
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
                            _selectedDate = pickedDate;
                            _tanggalTanamController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Tanggal Pencatatan',
                        labelText: 'Tanggal Pencatatan',
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

                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Tinggi Tanaman (mm)',
                        labelText: 'Tinggi Tanaman (mm)',
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
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _tinggiTanaman = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: AuthButton(
                          text: 'Masukkan',
                          onPressed: _submitData,
                          color: AppColors.primaryColor,
                        ))
                      ],
                    )
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
