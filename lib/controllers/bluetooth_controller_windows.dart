import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  //scan devices
  Future scanDevices() async {
    final scannedDevices = <ScanResult>{};

    const timeout = Duration(seconds: 5);
    FlutterBluePlus.startScan(

        //timeout: timeout,
        // slots filter
        withNames: [
          "Slot 1",
          "Slot 2",
          "Slot 3",
        ]);

    FlutterBluePlus.scanResults.expand((e) => e).listen(scannedDevices.add);

    await Future.delayed(timeout);
  }

  //show all available devices
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}
