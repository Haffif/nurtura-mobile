import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nurtura/provider/lahan_provider.dart';
import 'package:nurtura/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/auth_button.dart';
import '../../theme/text_styles.dart';
import 'edit_lahan.dart';

class LahanDetailPage extends StatefulWidget {
  final int idLahan;
  final Function onBackToDashboard; // Callback to navigate back to Dashboard page
  final VoidCallback onBack;
  final Function onLahanDeleted; // Add this callback

  const LahanDetailPage({super.key, required this.idLahan, required this.onBackToDashboard, required this.onBack, required this.onLahanDeleted});

  @override
  _LahanDetailPageState createState() => _LahanDetailPageState();
}

class _LahanDetailPageState extends State<LahanDetailPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadLahanData();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadLahanData() async {
    final lahanProvider = Provider.of<LahanProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // Handle error
      return;
    }

    try {
      await lahanProvider.fetchAndSelectLahanById(widget.idLahan, token);
      final selectedLahan = lahanProvider.fetchSelectedLahan;

      if (selectedLahan != null) {
        _updateMarker(LatLng(selectedLahan['latitude'], selectedLahan['longitude']));
      }
      print(selectedLahan);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
      print(error);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateMarker(LatLng location) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
        ),
      );
    });
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 16.0),
      ),
    );
  }

  Future<void> _deleteLahan() async {
    final lahanProvider = Provider.of<LahanProvider>(context, listen: false);
    try {
      final message = await lahanProvider.deleteLahan(widget.idLahan);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      widget.onLahanDeleted(); // Notify that the lahan was deleted
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
          content: const Text('Apakah anda yakin ingin menghapus lahan ini?'),
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
                await _deleteLahan();
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Consumer<LahanProvider>(
            builder: (context, lahanProvider, child) {
              final selectedLahan = lahanProvider.fetchSelectedLahan;
              if (selectedLahan == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
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
                      Text(
                        'Detail Lahan',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.primaryColor,
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
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(label: 'Nama Lahan', value: selectedLahan['nama_lahan']),
                        _buildDetailRow(label: 'Deskripsi', value: selectedLahan['deskripsi'] ?? '-'),
                        _buildDetailRow(label: 'Latitude', value: selectedLahan['latitude'].toString() ?? '-'),
                        _buildDetailRow(label: 'Longitude', value: selectedLahan['longitude'].toString() ?? '-'),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                            key: ValueKey(widget.idLahan), // Use a unique key for each instance
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                selectedLahan['latitude'],
                                selectedLahan['longitude'],
                              ),
                              zoom: 16.0,
                            ),
                            markers: _markers,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: AuthButton(
                                text: 'Edit Lahan',
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditLahanPage(
                                        lahanId: widget.idLahan,
                                        onBack: widget.onBack,
                                      ),
                                    ),
                                  );

                                  if (result == true) {
                                    // Refetch the data if the edit was successful
                                    _loadLahanData();
                                  }
                                },
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AuthButton(
                                text: 'Hapus Lahan',
                                onPressed: _showDeleteConfirmationDialog,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
