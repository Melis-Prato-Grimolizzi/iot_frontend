import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_frontend/state/slots.dart';
import 'package:iot_frontend/state/forecaster.dart';
import 'package:iot_frontend/widgets/map.dart';

class MyMap extends ConsumerWidget {
  const MyMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var slots = ref.watch(getSlotsProvider);
    var forecasts = ref.watch(getForecastsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: slots.when(
        data: (slots) => forecasts.when(
          data: (forecasts) => SlotsMap(slots, forecasts),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
