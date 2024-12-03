import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectSlot extends ConsumerWidget{
  const SelectSlot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){

   return Scaffold(
      appBar: AppBar(
        title: const Text('Select the mode you need'),
        toolbarHeight: 35.0,
        backgroundColor: const Color.fromARGB(255, 64, 101, 132),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient:RadialGradient(
            
            colors: [
              Color.fromARGB(255, 28, 70, 104),
              Colors.black,
              
            ],
            center: Alignment.center,
            radius: 1.0,
          )
        ),
        child: const Center(
          child: Column(
            children: [              
              
              GradientText('ParkSense',
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 36, 36, 36),
                    Color.fromARGB(255, 163, 162, 162),
                  ]
                ),
              style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )
              ),
              Text('Select your parking slot',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )
              ),
              
            ],
          ),
        ),
      )
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(this.text, {
    super.key,
    required this.gradient,
    this.style = const TextStyle(),
  });
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: style.copyWith(color: Colors.white), // Colore di base richiesto
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class SelectSlotWindows extends StatefulWidget {
  const SelectSlotWindows({super.key});

  @override
  State<SelectSlotWindows> createState() => _SelectSlotWindowsState();
}

class _SelectSlotWindowsState extends State<SelectSlotWindows> {
  final List<BluetoothDevice> _devices = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _checkBluetoothState();
  }

  void _checkBluetoothState() async {
    final isAvailable = await FlutterBluePlus.isAvailable;
    final isOn = await FlutterBluePlus.isOn;

    if (!isAvailable) {
      _showErrorDialog('Bluetooth is not available on this device.');
    } else if (!isOn) {
      _showErrorDialog('Please enable Bluetooth to proceed.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
  }

  void _stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      _isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Slot on Windows'),
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _isScanning ? _stopScan : _startScan,
            icon: Icon(_isScanning ? Icons.stop : Icons.search),
            label: Text(_isScanning ? 'Stop Scanning' : 'Start Scanning'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(device.name.isNotEmpty ? device.name : 'Unknown Device'),
                  subtitle: Text(device.id.toString()),
                  onTap: () {
                    // Handle device tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

*/