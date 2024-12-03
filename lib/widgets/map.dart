import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iot_frontend/models/slot.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class SlotsMap extends StatefulWidget {
  const SlotsMap(this.slots, {super.key});

  final List<Slot> slots;

  @override
  _SlotsMapState createState() => _SlotsMapState();
}

class _SlotsMapState extends State<SlotsMap> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  // function that search a destination
  Future<void> _searchLocation(String address) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        if (data.isNotEmpty) {
          final double lat = double.parse(data[0]['lat']);
          final double lon = double.parse(data[0]['lon']);

          // Set the map to the location searched
          _mapController.move(LatLng(lat, lon), 18.0);
        } else {
          _showSnackBar("Destination not found");
        }
      } else {
        _showSnackBar("Error in the request");
      }
    } catch (e) {
      _showSnackBar("Error in searching");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
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
                  for (var slot in widget.slots)
                    Marker(
                      point: LatLng(double.parse(slot.latitude),
                          double.parse(slot.longitude)),
                      child: Icon(
                        Icons.pin_drop,
                        color: slot.state
                            ? const Color.fromARGB(255, 147, 50, 43)
                            : const Color.fromARGB(255, 58, 224, 64),
                      ),
                    ),
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
          ),
          // Search Bar
          Positioned(
            top: 20,
            left: 30,
            right: 30,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Write your destination",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _searchLocation(value);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          _searchLocation(_searchController.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );    
  }
}