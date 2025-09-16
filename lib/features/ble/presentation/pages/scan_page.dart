import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers.dart';
import '../../domain/entities.dart';
import 'device_page.dart';

class ScanPage extends ConsumerWidget {
  const ScanPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scan = ref.watch(scanNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('BLE Devices')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(children: [
            Expanded(child: Text(scan.isScanning ? 'Scanning…' : 'Idle')),
            FilledButton(
              onPressed: scan.isScanning
                  ? () => ref.read(scanNotifierProvider.notifier).stop()
                  : () => ref.read(scanNotifierProvider.notifier).start(),
              child: Text(scan.isScanning ? 'Stop' : 'Start'),
            ),
          ]),
        ),
        const Divider(height: 0),
        Expanded(
          child: ListView(
            children: scan.devices.values.map((d) => _DeviceTile(device: d)).toList(),
          ),
        ),
      ]),
    );
  }
}

class _DeviceTile extends ConsumerWidget {
  final BleDevice device; const _DeviceTile({required this.device});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.bluetooth),
      title: Text(device.name),
      subtitle: Text('${device.id}\nRSSI: ${device.rssi ?? '-'}'),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        await ref.read(scanNotifierProvider.notifier).stop();
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => DevicePage(deviceId: device.id, deviceName: device.name)));
      },
    );
  }
}