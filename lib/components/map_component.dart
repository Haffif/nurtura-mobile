import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final Function(double, double) onLocationSelected;

  const MapComponent({
    Key? key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  _MapComponentState createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _markers.add(
      Marker(
        markerId: MarkerId('initial-marker'),
        position: LatLng(widget.initialLatitude, widget.initialLongitude),
      ),
    );
  }

  void _onTap(LatLng location) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
        ),
      );
    });
    widget.onLocationSelected(location.latitude, location.longitude);
    _moveCamera(location);
  }

  void _moveCamera(LatLng location) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 16.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLatitude, widget.initialLongitude),
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
            Factory<PanGestureRecognizer>(
                  () => PanGestureRecognizer(),
            ),
          )
          ..add(
            Factory<ScaleGestureRecognizer>(
                  () => ScaleGestureRecognizer(),
            ),
          )
          ..add(
            Factory<TapGestureRecognizer>(
                  () => TapGestureRecognizer(),
            ),
          )
          ..add(
            Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer(),
            ),
          ),
      ),
    );
  }
}
