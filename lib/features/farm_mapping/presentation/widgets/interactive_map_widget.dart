import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';

class InteractiveMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String fieldName;
  final Function(LatLng)? onLocationSelected;
  final List<Marker>? additionalMarkers;

  const InteractiveMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.fieldName,
    this.onLocationSelected,
    this.additionalMarkers,
  });

  @override
  State<InteractiveMapWidget> createState() => _InteractiveMapWidgetState();
}

class _InteractiveMapWidgetState extends State<InteractiveMapWidget> {
  late MapController _mapController;
  late LatLng _currentCenter;
  bool _isSatellite = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentCenter = LatLng(widget.latitude, widget.longitude);
  }

  @override
  void didUpdateWidget(InteractiveMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude || oldWidget.longitude != widget.longitude) {
      _currentCenter = LatLng(widget.latitude, widget.longitude);
      _mapController.move(_currentCenter, _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentCenter,
            initialZoom: 15,
            onTap: (tapPosition, point) {
              if (widget.onLocationSelected != null) {
                widget.onLocationSelected!(point);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: _isSatellite 
                ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.agrisense.ai',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentCenter,
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                if (widget.additionalMarkers != null) ...widget.additionalMarkers!,
              ],
            ),
          ],
        ),

        // Map Controls
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              _buildMapControl(
                icon: _isSatellite ? Icons.map : Icons.satellite_alt,
                onPressed: () => setState(() => _isSatellite = !_isSatellite),
              ),
              const SizedBox(height: 8),
              _buildMapControl(
                icon: Icons.my_location,
                onPressed: () => _mapController.move(_currentCenter, 15),
              ),
            ],
          ),
        ),

        // Field info card
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.fieldName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapControl({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primaryGreen),
        onPressed: onPressed,
      ),
    );
  }
}