import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_frontend/state/slots.dart';
import 'package:iot_frontend/widgets/map.dart';

class MyMap extends ConsumerWidget {
  const MyMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var slots = ref.watch(getSlotsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: slots.when(
        data: (slots) => SlotsMap(slots),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
