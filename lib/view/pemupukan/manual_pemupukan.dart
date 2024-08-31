import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/auth_button.dart';
import '../../provider/penanaman_provider.dart';
import '../../provider/pemupukan_provider.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

class InputManualPemupukanPage extends StatefulWidget {
  final VoidCallback onBack;

  const InputManualPemupukanPage({Key? key, required this.onBack}) : super(key: key);

  @override
  _InputManualPemupukanPageState createState() => _InputManualPemupukanPageState();
}

class _InputManualPemupukanPageState extends State<InputManualPemupukanPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPenanaman;
  bool _isDropdownLoading = false;
  bool _isEditing = false;
  String? _selectedPenanamanAksi;
  List<Map<String, dynamic>> _logData = [];
  double _minTinggi = 0.0;
  double _maxTinggi = 0.0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchInitialData();
  }

  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  // Method to update controllers with the fetched data
  void _updateControllers(PemupukanProvider pemupukanProvider) {
    _minController.text = '${pemupukanProvider.sopData['tinggi_tanaman_minimal_mm'] ?? ''}';
    _maxController.text = '${pemupukanProvider.sopData['tinggi_tanaman_maksimal_mm'] ?? ''}';
  }

  Future<void> _fetchSOPPemupukanData(int idPenanaman) async {
    final pemupukanProvider = Provider.of<PemupukanProvider>(context, listen: false);
    await pemupukanProvider.fetchSOPPemupukanData(idPenanaman);
    setState(() {
      _minTinggi = pemupukanProvider.sopData['tinggi_tanaman_minimal_mm']?.toDouble() ?? 0.0;
      _maxTinggi = pemupukanProvider.sopData['tinggi_tanaman_maksimal_mm']?.toDouble() ?? 0.0;
    });
  }

  Future<void> _fetchInitialData() async {
    await _fetchPenanamanData();
    await _fetchLatestPemupukanData();
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

  Future<void> _fetchLatestPemupukanData() async {
    final pemupukanProvider = Provider.of<PemupukanProvider>(context, listen: false);
    await pemupukanProvider.fetchLatestPemupukanData();
  }

  Future<void> _fetchLogTinggiTanamanData(int idPenanaman) async {
    final penanamanProvider = Provider.of<PenanamanProvider>(context, listen: false);
    await penanamanProvider.fetchLogTinggiTanamanData(idPenanaman);
    setState(() {
      _logData = penanamanProvider.logTinggiTanaman[idPenanaman] ?? [];
    });
  }

  Future<void> _updateSOPPemupukanData() async {
    final pemupukanProvider = Provider.of<PemupukanProvider>(context, listen: false);

    if (_formKey.currentState == null) {
      print('Form state is null');
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        final min = pemupukanProvider.sopData['tinggi_tanaman_minimal_mm'];
        final max = pemupukanProvider.sopData['tinggi_tanaman_maksimal_mm'];

        if (min != null && max != null && _selectedPenanaman != null) {
          await pemupukanProvider.updateSOPPemupukanData(
            int.parse(_selectedPenanaman!),
            min,
            max,
          );
          setState(() {
            _isEditing = false;
          });
        } else {
          print('Min or max values or selectedPenanaman are null');
        }
      } catch (error) {
        print('Error updating SOP Pemupukan data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final penanamanProvider = Provider.of<PenanamanProvider>(context);
    final pemupukanProvider = Provider.of<PemupukanProvider>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
        child: penanamanProvider.isLoading || _isDropdownLoading
            ? Center(child: CircularProgressIndicator())
            : penanamanProvider.plantingData.isEmpty
            ? Center(child: Text('Tidak ada data'))
            : Column(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
            Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primaryColor,
                    tabs: [
                      Tab(text: 'Ideal Pemupukan'),
                      Tab(text: 'Aksi Pemupukan'),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Kondisi Ideal Pemupukan',
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Penanaman',
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
                                    if (_selectedPenanaman != null) {
                                      _fetchSOPPemupukanData(int.parse(_selectedPenanaman!));
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a penanaman';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                if (_selectedPenanaman != null)
                                  ..._buildSOPFields(pemupukanProvider),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AuthButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_isEditing) {
                                              _updateSOPPemupukanData();
                                            } else {
                                              _isEditing = true;
                                            }
                                          });
                                        },
                                        text: _isEditing ? 'Simpan Data' : 'Ubah Data',
                                        color: AppColors.primaryColor,
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
                  AksiPemupukanView(
                    selectedPenanamanAksi: _selectedPenanamanAksi,
                    onPenanamanChanged: (String? newValue) {
                      setState(() {
                        _selectedPenanamanAksi = newValue;
                        if (_selectedPenanamanAksi != null) {
                          _fetchSOPPemupukanData(int.parse(_selectedPenanamanAksi!)).then((_) {
                            _fetchLogTinggiTanamanData(int.parse(_selectedPenanamanAksi!));
                          });
                        }
                      });
                      // Move to the "Aksi Pemupukan" tab when a new penanaman is selected
                      _tabController.animateTo(1);
                    },
                    logData: _logData,
                    minTinggi: _minTinggi,
                    maxTinggi: _maxTinggi,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSOPFields(PemupukanProvider pemupukanProvider) {
    // Update controllers with the latest SOP data
    _updateControllers(pemupukanProvider);

    return [
      Text(
        'Tinggi Min Tanaman',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      TextFormField(
        controller: _minController,
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
        readOnly: !_isEditing,
        onChanged: (value) {
          pemupukanProvider.sopData['tinggi_tanaman_minimal_mm'] = int.tryParse(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
      ),
      SizedBox(height: 16),
      Text(
        'Tinggi Max Tanaman',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      TextFormField(
        controller: _maxController,
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
        readOnly: !_isEditing,
        onChanged: (value) {
          pemupukanProvider.sopData['tinggi_tanaman_maksimal_mm'] = int.tryParse(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
      ),
    ];
  }
}

class AksiPemupukanView extends StatelessWidget {
  final String? selectedPenanamanAksi;
  final ValueChanged<String?> onPenanamanChanged;
  final List<Map<String, dynamic>> logData;
  final double minTinggi;
  final double maxTinggi;

  const AksiPemupukanView({
    Key? key,
    this.selectedPenanamanAksi,
    required this.onPenanamanChanged,
    required this.logData,
    required this.minTinggi,
    required this.maxTinggi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pemupukanProvider = Provider.of<PemupukanProvider>(context);

    if (pemupukanProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (pemupukanProvider.latestData.isEmpty) {
      return Center(child: Text('No data available'));
    } else {
      final data = pemupukanProvider.latestData;
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(data['updated_at']));
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aksi Pemupukan',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tinggi tanaman anda saat ini:',
                      style: AppTextStyles.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: data['isOptimal'] == 1 ? AppColors.primaryColor : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          data['isOptimal'] == 1 ? 'Optimal' : 'Tidak Optimal',
                          style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Monitoring terakhir',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      formattedDate,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  data['message'],
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Grafik Perbandingan',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                hint: Text('Pilih Penanaman Aksi'),
                value: selectedPenanamanAksi,
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
                items: Provider.of<PenanamanProvider>(context).plantingData.map((data) {
                  return DropdownMenuItem<String>(
                    value: data['id'].toString(),
                    child: Text(data['nama_penanaman'] ?? 'Unknown'),
                  );
                }).toList(),
                onChanged: onPenanamanChanged,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a penanaman';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (selectedPenanamanAksi != null)
                DualSensorDataChart(
                  idPenanaman: int.parse(selectedPenanamanAksi!),
                  logData: logData,
                  minTinggi: minTinggi,
                  maxTinggi: maxTinggi,
                ),
            ],
          ),
        ),
      );
    }
  }
}

class DualSensorDataChart extends StatelessWidget {
  final int idPenanaman;
  final List<Map<String, dynamic>> logData;
  final double minTinggi;
  final double maxTinggi;

  const DualSensorDataChart({
    Key? key,
    required this.idPenanaman,
    required this.logData,
    required this.minTinggi,
    required this.maxTinggi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (logData.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                showTitles: true,
                getTitles: (value) {
                  if (value.toInt() >= 0 && value.toInt() < logData.length) {
                    return logData[value.toInt()]['tanggal_pencatatan'].toString();
                  }
                  return '';
                },
                getTextStyles: (context, value) => const TextStyle(
                  color: Color(0xff68737d),
                  fontSize: 6,
                ),
                rotateAngle: -20,
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (context, value) => const TextStyle(
                  color: Color(0xff67727d),
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d), width: 1),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: const Color(0xff37434d),
                  strokeWidth: 0.5,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: const Color(0xff37434d),
                  strokeWidth: 0.5,
                );
              },
            ),
            minX: 0,
            maxX: logData.length.toDouble() - 1,
            minY: 0,
            maxY: logData.map((data) => (data['tinggi_tanaman'] as num).toDouble()).reduce((a, b) => a > b ? a : b),
            lineBarsData: [
              LineChartBarData(
                spots: logData.asMap().entries.map((entry) {
                  int idx = entry.key;
                  Map<String, dynamic> data = entry.value;
                  double yValue = (data['tinggi_tanaman'] as num).toDouble();
                  return FlSpot(idx.toDouble(), yValue);
                }).toList(),
                isCurved: true,
                colors: [Colors.blue],
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 3,
                      color: Colors.blue,
                      strokeWidth: 1,
                      strokeColor: Colors.white,
                    );
                  },
                ),
              ),
              LineChartBarData(
                spots: List.generate(logData.length, (index) => FlSpot(index.toDouble(), minTinggi)),
                isCurved: false,
                colors: [Colors.green],
                barWidth: 1,
                dotData: FlDotData(show: false),
              ),
              LineChartBarData(
                spots: List.generate(logData.length, (index) => FlSpot(index.toDouble(), maxTinggi)),
                isCurved: false,
                colors: [Colors.green],
                barWidth: 1,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  colors: [Colors.green.withOpacity(0.1)],
                  cutOffY: minTinggi,
                  applyCutOffY: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
