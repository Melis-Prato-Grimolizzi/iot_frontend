import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iot_frontend/models/slot.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;

class SlotsMap extends StatefulWidget {
  const SlotsMap(this.slots, this.forecasts, {super.key});

  final List<Slot> slots;
  final Map<String, dynamic>? forecasts;

  @override
  // ignore: library_private_types_in_public_api
  _SlotsMapState createState() => _SlotsMapState();
}

class _SlotsMapState extends State<SlotsMap> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  bool searchBool = false;
  bool showFreeSlots = true;
  bool showOccupiedSlots = true;
  bool showForecastedSlots = false;
  bool showLegend = false;

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

          // After 1st research the parcking slots will appear
          setState(() {
            searchBool = true;
          });
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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(44.646801, 10.925922),
                    initialZoom: 16.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                      userAgentPackageName: 'dev.grimos.iot',
                    ),
                    MarkerLayer(
                      markers: [
                        for (var slot in widget.slots)
                          if ((showFreeSlots && !slot.state) ||
                              ((showOccupiedSlots && slot.state)) ||
                              ((!showOccupiedSlots &&
                                      widget.forecasts![
                                              slot.parkingId.toString()] ==
                                          false) &&
                                  showForecastedSlots &&
                                  slot.state == true))
                            Marker(
                              point: LatLng(double.parse(slot.latitude),
                                  double.parse(slot.longitude)),
                              child: Icon(
                                // Icons.pin_drop,
                                _getMarkeStyle(slot),
                                color: _getMarkerColor(slot),
                              ),
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
                                hintText: "Search your destination",
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
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showFreeSlots = !showFreeSlots;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                  width: 0.5, color: Colors.black),
                            ),
                            backgroundColor: showFreeSlots
                                ? const Color.fromARGB(255, 178, 242, 179)
                                : Colors.white, // Green color when active
                          ),
                          child: const Text(
                            'Free Slots',
                            textScaler: TextScaler.linear(0.9),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showOccupiedSlots = !showOccupiedSlots;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                  width: 0.5, color: Colors.black),
                            ),
                            backgroundColor: showOccupiedSlots
                                ? const Color.fromARGB(255, 239, 177, 177)
                                : Colors.white, // Red color when active
                          ),
                          child: const Center(
                            child: Text(
                              'Occupied Slots',
                              textScaler: TextScaler.linear(0.9),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showForecastedSlots = !showForecastedSlots;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                  width: 0.5, color: Colors.black),
                            ),
                            backgroundColor: showForecastedSlots
                                ? const Color.fromARGB(255, 247, 198, 145)
                                : Colors.white, // Orange color when active
                          ),
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(
                              'images/aiAll.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 30,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showLegend = !showLegend;
                      });
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Legend'),
                            if (showLegend) ...[
                              const SizedBox(height: 4),
                              const LegendItem(
                                color: Color.fromARGB(255, 58, 224, 64),
                                text: 'Free Slots',
                              ),
                              const SizedBox(height: 4),
                              const LegendItem(
                                color: Color.fromARGB(255, 147, 50, 43),
                                text: 'Occupied Slots',
                              ),
                              const SizedBox(height: 4),
                              const LegendItem(
                                color: Colors.orange,
                                text: 'Predicted Free Slots',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMarkerColor(Slot slot) {
    if (showForecastedSlots &&
        widget.forecasts != null &&
        widget.forecasts![slot.parkingId.toString()] == false &&
        slot.state == true) {
      return Colors.orange;
    }
    return !slot.state
        ? const Color.fromARGB(255, 58, 224, 64)
        : const Color.fromARGB(255, 147, 50, 43);
  }

  IconData _getMarkeStyle(Slot slot) {
    if (showForecastedSlots &&
        widget.forecasts != null &&
        widget.forecasts![slot.parkingId.toString()] == false &&
        slot.state == true) {
      return MaterialCommunityIcons.map_marker_star;
    }
    return MaterialCommunityIcons.map_marker;
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({required this.color, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
