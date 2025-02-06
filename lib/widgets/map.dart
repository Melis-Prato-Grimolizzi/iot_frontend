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
  // ignore: library_private_types_in_public_api
  _SlotsMapState createState() => _SlotsMapState();
}

class _SlotsMapState extends State<SlotsMap> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  bool searchBool = false;
  bool showFreeSlots = true;
  bool showOccupiedSlots = true;

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
                              (showOccupiedSlots && slot.state))
                            Marker(
                              point: LatLng(double.parse(slot.latitude),
                                  double.parse(slot.longitude)),
                              child: Icon(
                                Icons.pin_drop,
                                color: !slot.state
                                    ? const Color.fromARGB(255, 58, 224, 64)
                                    : const Color.fromARGB(255, 147, 50, 43),
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
                  bottom: 20,
                  left: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ToggleButtons(
                      borderRadius: BorderRadius.circular(8.0),
                      borderColor: Colors.grey,
                      selectedBorderColor: Colors.blue,
                      fillColor: Colors.blue.withOpacity(0.2),
                      isSelected: [showFreeSlots, showOccupiedSlots],
                      onPressed: (int index) {
                        setState(() {
                          if (index == 0) {
                            showFreeSlots = !showFreeSlots;
                          } else if (index == 1) {
                            showOccupiedSlots = !showOccupiedSlots;
                          }
                        });
                      },
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text('Free Slots'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text('Occupied Slots'),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                    top: 100,
                    left: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        //predizione su tutti i parcheggi
                      },
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          'images/aiAll.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
