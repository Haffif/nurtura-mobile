import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nurtura/provider/lahan_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../components/auth_button.dart';

class EditLahanPage extends StatefulWidget {
  final int lahanId;
  final VoidCallback onBack;

  const EditLahanPage({Key? key, required this.lahanId, required this.onBack}) : super(key: key);

  @override
  _EditLahanPageState createState() => _EditLahanPageState();
}

class _EditLahanPageState extends State<EditLahanPage> {
  final TextEditingController _namaLahanController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadLahanData();
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
      await lahanProvider.fetchAndSelectLahanById(widget.lahanId, token);
      final selectedLahan = lahanProvider.selectedLahan;

      if (selectedLahan != null) {
        setState(() {
          _namaLahanController.text = selectedLahan['nama_lahan'] ?? '';
          _deskripsiController.text = selectedLahan['deskripsi'] ?? '';
          String latitude = selectedLahan['latitude']?.toString() ?? '0.0';
          String longitude = selectedLahan['longitude']?.toString() ?? '0.0';

          // Log the values
          print('Latitude: $latitude, Longitude: $longitude');

          _latitudeController.text = latitude;
          _longitudeController.text = longitude;
          _updateMarker(LatLng(double.parse(latitude), double.parse(longitude)));
        });
      }
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

  void _onTap(LatLng location) {
    setState(() {
      _latitudeController.text = location.latitude.toString();
      _longitudeController.text = location.longitude.toString();
      _updateMarker(location);
    });
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

  Future<void> _updateLahan() async {
    final lahanProvider = Provider.of<LahanProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || _latitudeController.text == 'NaN' || _longitudeController.text == 'NaN') {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid token or coordinates')),
      );
      return;
    }

    try {
      final response = await lahanProvider.updateLahan(
        widget.lahanId,
        _namaLahanController.text,
        _deskripsiController.text,
        double.parse(_latitudeController.text),
        double.parse(_longitudeController.text),
      );
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        Navigator.pop(context, true); // Pop with a success result
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update lahan')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Lahan'),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Lahan',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 12),
                Text(
                  'Deskripsi',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 12),
                Text(
                  'Koordinat',
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
                    const SizedBox(width: 16),
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
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _markers.isNotEmpty
                          ? _markers.first.position
                          : LatLng(0.0, 0.0), // default position if markers are empty
                      zoom: 16.0,
                    ),
                    markers: _markers,
                    onTap: _onTap,
                    zoomControlsEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    gestureRecognizers: Set()
                      ..add(
                        Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                      )
                      ..add(
                        Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                      )
                      ..add(
                        Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                      )
                      ..add(
                        Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
                      ),
                  ),

                ),
                const SizedBox(height: 12),
                Text(
                  'Pindahkan tanda pada peta untuk memperbarui data koordinat secara otomatis',
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AuthButton(
                        text: 'Perbarui Data Lahan',
                        onPressed: _updateLahan,
                        color: AppColors.primaryColor,
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
