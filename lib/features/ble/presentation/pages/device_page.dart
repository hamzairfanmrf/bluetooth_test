import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../presentation/providers.dart';

class DevicePage extends ConsumerStatefulWidget {
  final String deviceId; final String deviceName;
  const DevicePage({super.key, required this.deviceId, required this.deviceName});
  @override
  ConsumerState<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends ConsumerState<DevicePage> {
  Uuid? _service; Uuid? _char; final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(connectionNotifierProvider.notifier).connect(widget.deviceId);
    ref.read(chatNotifierProvider.notifier).bind(widget.deviceId);
  }

  @override
  void dispose() {
    ref.read(connectionNotifierProvider.notifier).disconnect();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conn = ref.watch(connectionNotifierProvider);
    final chat = ref.watch(chatNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.deviceName)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('Connection:'), const SizedBox(width: 8),
            Chip(label: Text(conn.state.name)),
            if (conn.error != null) ...[const SizedBox(width: 8), Flexible(child: Text(conn.error!, style: const TextStyle(color: Colors.red)))]
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(
              decoration: const InputDecoration(labelText: 'Service UUID (e.g., 0000180D-0000-1000-8000-00805F9B34FB)'),
              onSubmitted: (v) => setState(() => _service = Uuid.parse(v)),
            )),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(
              decoration: const InputDecoration(labelText: 'Characteristic UUID'),
              onSubmitted: (v) => setState(() => _char = Uuid.parse(v)),
            )),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: (_service != null && _char != null)
                  ? () => ref.read(chatNotifierProvider.notifier).subscribe(_service!, _char!)
                  : null,
              child: const Text('Subscribe'),
            )
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(8)),
              child: ListView.builder(
                itemCount: chat.log.length,
                itemBuilder: (context, idx) {
                  final m = chat.log[idx];
                  final text = _tryDecodeUtf8(m.payload);
                  return ListTile(
                    leading: Icon(m.isLocal ? Icons.north_east : Icons.south_west),
                    title: Text(text),
                    subtitle: Text(m.payload.toString()),
                    trailing: Text(TimeOfDay.fromDateTime(m.at).format(context)),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: _ctrl, decoration: const InputDecoration(labelText: 'Type a message…'))),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: (chat.charId != null && chat.serviceId != null)
                  ? () async { final text = _ctrl.text.trim(); if (text.isEmpty) return; await ref.read(chatNotifierProvider.notifier).sendText(text); _ctrl.clear(); }
                  : null,
              child: const Text('Send'),
            ),
          ]),
        ]),
      ),
    );
  }

  String _tryDecodeUtf8(List<int> bytes) { try { return utf8.decode(bytes); } catch (_) { return bytes.toString(); } }
}