import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  static const LatLng _center = LatLng(-7.282373, 112.78);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng location) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: InfoWindow(
            title: 'Selected Location',
            snippet: '${location.latitude}, ${location.longitude}',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child:
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: _markers,
                onTap: _onTap,
              ),
          //   Display the selected location
          ),
          SizedBox(height: 16),
          Text(
            'Selected Location',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Latitude: ${_markers.isNotEmpty ? _markers.first.position.latitude : 'NaN'}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            'Longitude: ${_markers.isNotEmpty ? _markers.first.position.longitude : 'NaN'}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
