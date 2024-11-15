import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iot_frontend/models/slot.dart';
import 'package:latlong2/latlong.dart';

class SlotsMap extends StatelessWidget {
  const SlotsMap(this.slots, {super.key});

  final List<Slot> slots;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(44.6366949, 10.929104),
        initialZoom: 9.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            for (var slot in slots)
              Marker(
                point: LatLng(
                    double.parse(slot.latitude), double.parse(slot.longitude)),
                child: const Icon(Icons.pin_drop),
              )
          ],
        ),
        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
            ),
          ],
        ),
      ],
    );
  }
}
