import 'package:flutter/material.dart';
import 'package:nurtura/view/lahan/add_lahan.dart';
import 'package:nurtura/view/lahan/daftar_lahan.dart';
import 'package:nurtura/view/lahan/edit_lahan.dart';
import 'package:nurtura/view/pemupukan/manual_pemupukan.dart';
import 'package:nurtura/view/penanaman/daftar_penanaman.dart';
import 'package:nurtura/view/penanaman/manual_update_tinggi.dart';
import 'package:nurtura/view/penanaman/tambah_penanaman.dart';
import 'package:nurtura/view/pengairan/manual_pengairan.dart';
import 'package:nurtura/view/lahan/lahan_detail.dart';
import 'package:nurtura/view/penanaman/detail_penanaman.dart';
import 'package:nurtura/view/penanaman/edit_penanaman.dart';
import '../components/app_name.dart';
import 'dashboard_page.dart';
import 'feature_page.dart';
import 'detection_page.dart';
import 'history/aksi_alat.dart';
import 'history/data_sensor.dart';
import 'history/tinggi_tanaman.dart';
import 'history_page.dart';
import 'profile_page.dart';
import '../theme/colors.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  int _selectedIndex = 0;
  int _subPageIndex = 0;
  int? _selectedLahanId; // To store the selected Lahan ID
  int? _editingLahanId; // To store the Lahan ID being edited
  Map<String, dynamic>? _selectedPenanaman; // To store the selected Penanaman data
  bool _isEditingPenanaman = false; // To check if we are in editing mode

  void _onMainPageSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _subPageIndex = 0;
      _selectedLahanId = null; // Reset selected lahan ID
      _editingLahanId = null; // Reset editing lahan ID
      _selectedPenanaman = null; // Reset selected penanaman
      _isEditingPenanaman = false; // Reset editing penanaman mode
    });
  }

  void _onSubPageSelected(int index) {
    setState(() {
      _subPageIndex = index;
    });
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void _navigateToLahanDetail(int idLahan) {
    setState(() {
      _selectedLahanId = idLahan;
    });
  }

  void _navigateToEditLahan(int lahanId) {
    setState(() {
      _editingLahanId = lahanId;
    });
  }

  void _navigateBackToDashboard() {
    setState(() {
      _selectedIndex = 0;
      _selectedLahanId = null; // Reset selected lahan ID
      _editingLahanId = null; // Reset editing lahan ID
      _selectedPenanaman = null; // Reset selected penanaman
      _isEditingPenanaman = false; // Reset editing penanaman mode
    });
  }

  void _navigateBackToFeature() {
    setState(() {
      _selectedIndex = 1;
      _selectedLahanId = null; // Reset selected lahan ID
      _editingLahanId = null; // Reset editing lahan ID
      _selectedPenanaman = null; // Reset selected penanaman
      _isEditingPenanaman = false; // Reset editing penanaman mode
    });
  }

  void _onLahanDeleted() {
    setState(() {
      _selectedLahanId = null;
      _selectedIndex = 0; // Navigate back to the dashboard
    });
  }

  void _navigateToPenanamanDetail(Map<String, dynamic> penanamanData) {
    setState(() {
      _selectedPenanaman = penanamanData;
      _isEditingPenanaman = false; // Not in editing mode
    });
  }

  void _navigateToEditPenanaman(Map<String, dynamic> penanamanData) {
    setState(() {
      _selectedPenanaman = penanamanData;
      _isEditingPenanaman = true; // In editing mode
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
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
                onPressed: _navigateToProfile,
                icon: const Icon(
                  Icons.person,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: AppColors.primaryColor,
    );
  }

  Widget _buildFeatureStack() {
    return IndexedStack(
      index: _subPageIndex,
      children: [
        FeaturePage(onPageSelected: _onSubPageSelected),
        ManualTinggiTanamanPage(
          onBack: () => _onSubPageSelected(0),
        ),
        InputManualPengairanPage(
          onBack: () => _onSubPageSelected(0),
        ),
        InputManualPemupukanPage(onBack: () => _onSubPageSelected(0)),
        DaftarPenanamanPage(
          onBack: () => _onSubPageSelected(0),
          onDetailPenanaman: _navigateToPenanamanDetail,
        ),
        AddPenanamanPage(onBack: () => _onSubPageSelected(0)),
        DaftarLahanPage(
          onBack: () => _onSubPageSelected(0),
          onDetailLahan: (lahanId) {
            setState(() {
              _selectedLahanId = lahanId;
              _subPageIndex = 6; // Set to the index of the DetailLahanPage
            });
          },
        ),
        AddLahanPage(onBack: () => _onSubPageSelected(0)),
      ],
    );
  }

  Widget _buildHistoryStack() {
    return IndexedStack(
      index: _subPageIndex,
      children: [
        HistoryPage(onPageSelected: _onSubPageSelected),
        TinggiTanamanPage(onBack: () => _onSubPageSelected(0)),
        DataSensorPage(onBack: () => _onSubPageSelected(0)),
        AksiAlatPage(onBack: () => _onSubPageSelected(0)),
      ],
    );
  }

  Widget _buildMainStack() {
    return IndexedStack(
      index: _isEditingPenanaman
          ? 7
          : (_editingLahanId != null
          ? 5
          : (_selectedLahanId != null
          ? 4
          : (_selectedPenanaman != null ? 6 : _selectedIndex))),
      children: [
        DashboardPage(
          onPageSelected: _onMainPageSelected,
          onLahanDetailSelected: _navigateToLahanDetail,
        ),
        _buildFeatureStack(),
        DetectionPage(),
        _buildHistoryStack(),
        if (_selectedLahanId != null)
          LahanDetailPage(
            idLahan: _selectedLahanId!,
            onBackToDashboard: _navigateBackToDashboard,
            onBack: _navigateBackToFeature,
            onLahanDeleted: _onLahanDeleted, // Pass the deletion callback
          )
        else
          Container(), // Provide a placeholder when _selectedLahanId is null
        if (_editingLahanId != null)
          EditLahanPage(
            lahanId: _editingLahanId!,
            onBack: _navigateBackToFeature,
          )
        else
          Container(), // Provide a placeholder when _editingLahanId is null
        if (_selectedPenanaman != null && !_isEditingPenanaman)
          DetailPenanamanPage(
            penanamanData: _selectedPenanaman!,
            onBack: _navigateBackToFeature,
            onEdit: _navigateToEditPenanaman,
          )
        else if (_isEditingPenanaman)
          EditPenanamanPage(
            penanamanData: _selectedPenanaman!,
            onBack: _navigateBackToFeature,
          )
        else
          Container(), // Provide a placeholder when _selectedPenanaman is null
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildMainStack(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.white,
        iconSize: 24,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.find_in_page), label: 'Feature'),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart_outlined), label: 'Detection'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onMainPageSelected,
      ),
    );
  }
}
