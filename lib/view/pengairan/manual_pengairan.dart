import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurtura/components/auth_button.dart';
import 'package:provider/provider.dart';
import '../../provider/irrigation_provider.dart';
import '../../provider/penanaman_provider.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

class InputManualPengairanPage extends StatefulWidget {
  final VoidCallback onBack;

  const InputManualPengairanPage({Key? key, required this.onBack}) : super(key: key);

  @override
  _InputManualPengairanPageState createState() => _InputManualPengairanPageState();
}

class _InputManualPengairanPageState extends State<InputManualPengairanPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPenanaman;
  bool _isDropdownLoading = false;
  List<Map<String, dynamic>> _sopData = [];
  bool _isEditMode = false;
  bool _isSOPNotFound = false;
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPenanamanData();
    _fetchLatestIrrigationData();
  }

  Future<void> _fetchPenanamanData() async {
    setState(() {
      _isDropdownLoading = true;
    });
    await Provider.of<PenanamanProvider>(context, listen: false).fetchPenanamanData();
    setState(() {
      _isDropdownLoading = false;
    });
  }

  Future<void> _fetchLatestIrrigationData() async {
    await Provider.of<PenanamanProvider>(context, listen: false).fetchLatestIrrigationData();
  }

  Future<void> _fetchSOPPengairanData(int idPenanaman) async {
    setState(() {
      _isDropdownLoading = true;
    });
    try {
      await Provider.of<PenanamanProvider>(context, listen: false).fetchSOPPengairanData(idPenanaman);
      final sopData = Provider.of<PenanamanProvider>(context, listen: false).sopData;
      setState(() {
        _sopData = sopData;
        _isSOPNotFound = false;
      });
    } catch (error) {
      setState(() {
        _isSOPNotFound = true;
      });
      print('Error fetching SOP Pengairan data: $error');
    } finally {
      setState(() {
        _isDropdownLoading = false;
      });
    }
  }

  Future<void> _saveSOPPengairanData() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);
      try {
        await penanamanProvider.updateSOPPengairanData(_sopData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data SOP pengairan berhasil diperbarui!')),
        );
        setState(() {
          _isSOPNotFound = false;
          _isEditMode = false;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data: $error')),
        );
      }
    }
  }

  String _formatDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(parsedDate);
  }

  void _calculateEndAndDuration() {
    if (_startTimeController.text.isNotEmpty && _volumeController.text.isNotEmpty) {
      DateTime startTime = DateFormat.jm().parse(_startTimeController.text);
      int volume = int.parse(_volumeController.text);
      int durationMinutes = (volume / 7).round();
      DateTime endTime = startTime.add(Duration(minutes: durationMinutes));
      _durationController.text = '$durationMinutes menit';
      _endTimeController.text = DateFormat.jm().format(endTime);
    }
  }

  void _submitIrrigation() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final irrigationProvider = Provider.of<IrrigationProvider>(context, listen: false);

      try {
        DateTime tanggalPengairan = DateFormat('dd-MM-yyyy').parse(_tanggalController.text);
        DateTime startDateTime = DateFormat.jm().parse(_startTimeController.text);
        DateTime endDateTime = DateFormat.jm().parse(_endTimeController.text);

        int duration = endDateTime.difference(startDateTime).inMinutes;
        if (duration <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Waktu selesai harus setelah waktu mulai')),
          );
          return;
        }

        final data = {
          "id_penanaman": int.parse(_selectedPenanaman!),
          "tanggal_pengairan": tanggalPengairan.toIso8601String(),
          "volume": int.parse(_volumeController.text),
          "start": startDateTime.toIso8601String(),
          "end": endDateTime.toIso8601String(),
          "durasi": duration
        };

        await irrigationProvider.postManualIrrigation(data);
        print(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data pengairan manual berhasil dikirim!')),
        );

        setState(() {
          _isEditMode = false;
          _volumeController.clear();
          _startTimeController.clear();
          _endTimeController.clear();
          _durationController.clear();
          _tanggalController.clear();
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim data: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final penanamanProvider = Provider.of<PenanamanProvider>(context);
    final latestIrrigationData = penanamanProvider.latestIrrigationData;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24),
        child: penanamanProvider.isLoading || _isDropdownLoading
            ? Center(child: CircularProgressIndicator())
            : penanamanProvider.plantingData.isEmpty
            ? Center(child: Text('Tidak ada data'))
            : DefaultTabController(
          length: 2,
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
                    'Input Manual Pengairan',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                      indicatorColor: AppColors.primaryColor,
                      tabs: [
                        Tab(text: 'Ideal Pengairan'),
                        Tab(text: 'Aksi Pengairan'),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Kondisi Ideal Pengairan',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nama Penanaman',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
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
                                    items: penanamanProvider.plantingData.map((data) {
                                      return DropdownMenuItem<String>(
                                        value: data['id'].toString(),
                                        child: Text(data['nama_penanaman'] ?? 'Unknown'),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedPenanaman = newValue;
                                        _fetchSOPPengairanData(int.parse(newValue!));
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select a penanaman';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  if (_isSOPNotFound)
                                    Column(
                                      children: [
                                        Text(
                                          'Error occurred: Exception: Tidak ada data SOP yang ditemukan untuk penanaman ini.',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        SizedBox(height: 16),
                                        AuthButton(
                                          text: 'Tambah Data',
                                          onPressed: _saveSOPPengairanData,
                                          color: AppColors.primaryColor,
                                        ),
                                      ],
                                    )
                                  else if (_sopData.isNotEmpty)
                                    Column(
                                      children: _buildSOPFields(_sopData),
                                    ),
                                  SizedBox(height: 20),
                                  if (!_isSOPNotFound)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AuthButton(
                                            text: _isEditMode ? 'Simpan Pembaruan' : 'Ubah Data',
                                            onPressed: () {
                                              if (_isEditMode) {
                                                _saveSOPPengairanData();
                                              } else {
                                                setState(() {
                                                  _isEditMode = true;
                                                });
                                              }
                                            },
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Aksi Pengairan',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          if (!_isEditMode)
                            Consumer<PenanamanProvider>(
                              builder: (context, irrigationProvider, child) {
                                if (irrigationProvider.isLoading) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (irrigationProvider.latestIrrigationData == null) {
                                  return Center(child: Text('Tidak ada data'));
                                } else {
                                  final data = irrigationProvider.latestIrrigationData!;
                                  return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Kondisi tanaman Anda saat ini:',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          data['kondisi'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: data['kondisi'] == 'Ideal' ? Colors.green : Colors.red,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Penyiraman terakhir',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          _formatDateTime(latestIrrigationData!['updated_at']),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Volume: ${data['rekomendasi_volume']} L',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Saran',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          data['saran'],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AuthButton(
                                                text: 'Ya, siram sekarang',
                                                onPressed: () {
                                                  setState(() {
                                                    _isEditMode = true;
                                                  });
                                                },
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          if (_isEditMode)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nama Penanaman',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
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
                                          items: penanamanProvider.plantingData.map((data) {
                                            return DropdownMenuItem<String>(
                                              value: data['id'].toString(),
                                              child: Text(data['nama_penanaman'] ?? 'Unknown'),
                                            );
                                          }).toList(),
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
                                        SizedBox(height: 16),
                                        Text(
                                          'Tanggal Pengairan',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        TextFormField(
                                          controller: _tanggalController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText: 'Pilih Tanggal',
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Colors.green),
                                            ),
                                          ),
                                          onTap: () async {
                                            final DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );
                                            if (pickedDate != null) {
                                              setState(() {
                                                _tanggalController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please select a date';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Volume Air',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        TextFormField(
                                          controller: _volumeController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Colors.green),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            _calculateEndAndDuration();
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter volume';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Waktu Pengairan',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 8),
                                                  
                                                  TextFormField(
                                                    controller: _startTimeController,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'Mulai',
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: const BorderSide(color: Colors.green),
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      final TimeOfDay? pickedTime = await showTimePicker(
                                                        context: context,
                                                        initialTime: TimeOfDay.now(),
                                                      );
                                                      if (pickedTime != null) {
                                                        setState(() {
                                                          _startTimeController.text = pickedTime.format(context).toString();
                                                          _calculateEndAndDuration();
                                                        });
                                                      }
                                                    },
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please select start time';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width:8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Selesai',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 8),
                                                  TextFormField(
                                                    controller: _endTimeController,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'Selesai',
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: const BorderSide(color: Colors.green),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Durasi',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        TextFormField(
                                          controller: _durationController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText: 'Durasi',
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Colors.green),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AuthButton(
                                                text: 'Jalankan',
                                                onPressed: _submitIrrigation,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: AuthButton(
                                                text: 'Batal',
                                                onPressed: () {
                                                  setState(() {
                                                    _isEditMode = false;
                                                  });
                                                },
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        
                                        RichText(text: TextSpan(text: 'Volume akan menyesuaikan debit pengairan \(kelipatan 7 sebelumnya', style: TextStyle(color:Colors.black, fontSize: 12))),
                                        SizedBox(height: 8),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Waktu pengairan maksimal ',
                                            style: TextStyle(color:Colors.black, fontSize: 12), // Default text color
                                            children: <TextSpan>[
                                              TextSpan(text: '180 menit', style: TextStyle(color: AppColors.primaryColor, fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Debit splinkler: ',
                                            style: TextStyle(color:Colors.black, fontSize: 12), // Default text color
                                            children: <TextSpan>[
                                              TextSpan(text: '7 L/menit', style: TextStyle(color: AppColors.primaryColor, fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        RichText(text: TextSpan(text: 'Jika penyiraman dilaksanakan sekarang \(dengan waktu yang sama\), maka waktu mulai dan selesai akan ditambahkan satu menit agar dapat masuk ke database', style: TextStyle(color:Colors.black, fontSize: 12))),

                                      ],
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
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSOPFields(List<Map<String, dynamic>> sopData) {
    List<Widget> fields = [];
    for (var data in sopData) {
      fields.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['id_penanaman'] == 1 ? 'Kondisi Ideal' : '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildSOPRow('Temperature', data['temp_min'], data['temp_max'], data, 'temp_min', 'temp_max'),
            SizedBox(height: 16),
            _buildSOPRow('Humidity', data['humidity_min'], data['humidity_max'], data, 'humidity_min', 'humidity_max'),
            SizedBox(height: 16),
            _buildSOPRow('Soil Moisture', data['soil_min'], data['soil_max'], data, 'soil_min', 'soil_max'),
            SizedBox(height: 16),
          ],
        ),
      );
    }
    return fields;
  }

  Widget _buildSOPRow(String label, dynamic min, dynamic max, Map<String, dynamic> data, String minKey, String maxKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            initialValue: '$min',
            decoration: InputDecoration(
              labelText: label,
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
            readOnly: !_isEditMode,
            onSaved: (value) {
              data[minKey] = value != null ? int.parse(value) : min;
            },
          ),
        ),
        SizedBox(width: 10),
        Text('Min'),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            initialValue: '$max',
            decoration: InputDecoration(
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
            readOnly: !_isEditMode,
            onSaved: (value) {
              data[maxKey] = value != null ? int.parse(value) : max;
            },
          ),
        ),
        SizedBox(width: 10),
        Text('Max'),
      ],
    );
  }
}
