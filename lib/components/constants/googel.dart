import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  final double lat;
  final double lng;

  const MapScreen({required this.lat, required this.lng});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  String locationName = 'กำลังโหลดชื่อสถานที่...';

  @override
  void initState() {
    super.initState();
    _getPlaceName();
  }

  Future<void> _getPlaceName() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(widget.lat, widget.lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          locationName = '${place.name}, ${place.locality}, ${place.country}';
        });
      }
    } catch (e) {
      setState(() {
        locationName = 'ไม่พบชื่อสถานที่';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng position = LatLng(widget.lat, widget.lng);

    return Scaffold(
      appBar: AppBar(title: Text('ตำแหน่ง')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: MarkerId('selected-location'),
                position: position,
                infoWindow: InfoWindow(title: locationName),
              ),
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(locationName, style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
