import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleDevice {
  final String id;
  final String name;
  final int? rssi;
  const BleDevice({required this.id, required this.name, this.rssi});
}

class GattServiceInfo {
  final Uuid serviceId;
  final List<GattCharacteristicInfo> characteristics;
  const GattServiceInfo(this.serviceId, this.characteristics);
}

class GattCharacteristicInfo {
  final Uuid charId;
  final bool canRead;
  final bool canWrite;
  final bool canNotify;
  const GattCharacteristicInfo({
    required this.charId,
    required this.canRead,
    required this.canWrite,
    required this.canNotify,
  });
}

class ChatMessage {
  final DateTime at;
  final bool isLocal; // true if sent by phone
  final List<int> payload; // raw bytes
  const ChatMessage(this.at, this.isLocal, this.payload);
}