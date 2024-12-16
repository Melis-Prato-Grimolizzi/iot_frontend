import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_frontend/pages/mappage.dart';
import 'package:iot_frontend/pages/selectslot.dart';

class SelectMode extends ConsumerWidget {
  const SelectMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select the mode you need'),
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
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyMap()));
                    },
                    child: const Text('Find parking slot'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectSlot()));
                    },
                    child: const Text('Pay parking slot'),
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
