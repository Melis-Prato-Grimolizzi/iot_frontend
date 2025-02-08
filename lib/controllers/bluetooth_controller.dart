import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.locationWhenInUse,
  ].request();
}

class BluetoothController extends GetxController {
  //scan devices
  Future scanDevices() async {
    // listen to scan results
// Note: `onScanResults` clears the results between scans. You should use
//  `scanResults` if you want the current scan results *or* the results from the previous scan.
    var subscription = FlutterBluePlus.onScanResults.listen(
      (results) {},
      // ignore: avoid_print
      onError: (e) => print(e),
    );

// cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(subscription);

// Wait for Bluetooth enabled & permission granted
// In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

// permission request
    await requestPermissions();

// Start scanning w/ timeout
// Optional: use `stopScan()` as an alternative to timeout
    await FlutterBluePlus.startScan(
        // match any of the specified services
        withNames: [
          "Slot 1",
          "Slot 2",
          "Slot 3"
        ], // *or* any of the specified names
        timeout: const Duration(seconds: 5));

// wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }

  //show all available devices
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}
