import 'package:flutter/material.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide FlutterBluePlus;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iot_frontend/controllers/bluetooth_controller.dart';
import 'package:iot_frontend/io/http.dart';
import 'package:iot_frontend/pages/selectmode.dart';
import 'package:shared_preferences/shared_preferences.dart';

final viewedProvider = StateProvider<bool>((ref) => false);

class SelectSlot extends ConsumerWidget {
  const SelectSlot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewed = ref.watch(viewedProvider);

    void startSession(String idSlot) async {
      final prefs = await SharedPreferences.getInstance();
      final jwt = prefs.getString('jwt');
      if (jwt == null) return null;
      final response = await httpApi.startSession(idSlot, jwt);
      if (response != null) {
        // ignore: use_build_context_synchronously
        if (response.statusCode == 200) {
          showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Session Started!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.lightGreen)),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Image.asset('images/success.png'),
                      Text(
                        'The parking session starts successfully in Slot $idSlot!',
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectMode()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Something wrong!',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Image.asset('images/unsuccess.png'),
                      Text(
                        'The parking session is not started. Check that you have selected the right slot. Remember to select Parking slot only you\'ve parked!',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Scan and select!'),
          toolbarHeight: 35.0,
          backgroundColor: const Color.fromARGB(255, 64, 101, 132),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: RadialGradient(
            colors: [
              Color.fromARGB(255, 28, 70, 104),
              Colors.black,
            ],
            center: Alignment.center,
            radius: 1.0,
          )),
          child: Center(
            child: Column(
              children: [
                const GradientText('ParkSense',
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 36, 36, 36),
                      Color.fromARGB(255, 163, 162, 162),
                    ]),
                    style: TextStyle(
                      fontSize: 65.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                const Text('Scan and Select',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                const Text('your parking slot',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: GetBuilder<BluetoothController>(
                    init: BluetoothController(),
                    builder: (controller) {
                      return SingleChildScrollView(
                          child: Column(
                        children: [
                          Center(
                            // Scan button

                            child: ElevatedButton(
                                onPressed: () async {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Scanning..."),
                                    duration: Duration(seconds: 5),
                                  ));
                                  await controller.scanDevices();
                                  ref.read(viewedProvider.notifier).state =
                                      false;
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    minimumSize: const Size(350, 55),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    )),
                                child: const Text(
                                  "Scan",
                                  style: TextStyle(fontSize: 18),
                                )),
                          ),
                          StreamBuilder<List<ScanResult>>(
                              stream: controller.scanResults,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (!viewed) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "${snapshot.data!.length} slots found")));
                                      ref.read(viewedProvider.notifier).state =
                                          true;
                                    });
                                  }
                                  return SizedBox(
                                    width: 150,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemExtent: 150.0,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final data = snapshot.data![index];

                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    fixedSize:
                                                        const Size(130, 130)),
                                                onPressed: () {
                                                  startSession(data
                                                      .device.platformName
                                                      .replaceAll(
                                                          RegExp(r'[^0-9]'),
                                                          ''));
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'images/slotImage.png',
                                                      fit: BoxFit.contain,
                                                    ),
                                                    //const SizedBox(height: 5.0,),
                                                    Text(data
                                                        .device.platformName),
                                                  ],
                                                )),
                                          ],
                                        );

                                        // return Card(
                                        //   elevation: 2,
                                        //   child: ListTile(
                                        //     title: Text(data.device.platformName),

                                        //     //MAC Address
                                        //     //subtitle: Text(
                                        //     //   data.device.remoteId.toString()),

                                        //     //potenza segnale
                                        //     //trailing: Text(data.rssi.toString()),
                                        //   ),
                                        // );
                                      },
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: SizedBox(),
                                  );
                                }
                              })
                        ],
                      ));
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(
    this.text, {
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
