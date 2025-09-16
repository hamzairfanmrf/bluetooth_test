import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../ble/domain/entities.dart';

class BleDataSource {
  final FlutterReactiveBle _ble;
  StreamSubscription<DiscoveredDevice>? _scanSub;
  StreamSubscription<ConnectionStateUpdate>? _connSub;

  BleDataSource(this._ble);

  Stream<BleDevice> scan() {
    _scanSub?.cancel();
    final controller = StreamController<BleDevice>.broadcast();
    _scanSub = _ble.scanForDevices(withServices: []).listen((d) {
      controller.add(BleDevice(id: d.id, name: d.name.isEmpty ? 'Unknown' : d.name, rssi: d.rssi));
    }, onError: controller.addError, onDone: controller.close);
    return controller.stream;
  }

  Future<void> stopScan() async {
    await _scanSub?.cancel();
    _scanSub = null;
  }

  Stream<ConnectionStateUpdate> connect(String deviceId) {
    // Cancel old connection if any
    _connSub?.cancel();
    _connSub = _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    ).listen((update) {
      // You can push updates to a controller if you want to expose them.
    });

    // Also return the stream directly if you want to observe externally
    return _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    );
  }


  Future<void> disconnect() async {
    await _connSub?.cancel();
    _connSub = null;
  }
  Future<List<GattServiceInfo>> discover(String deviceId) async {
    final services = await _ble.discoverServices(deviceId);
    return services.map((s) => GattServiceInfo(s.serviceId, s.characteristics.map((c) {
      final props = c.isReadable || c.isWritableWithResponse || c.isWritableWithoutResponse || c.isNotifiable;
      return GattCharacteristicInfo(
        charId: c.characteristicId,
        canRead: c.isReadable,
        canWrite: c.isWritableWithResponse || c.isWritableWithoutResponse,
        canNotify: c.isNotifiable,
      );
    }).toList())).toList();
  }

  Stream<List<int>> observe(String deviceId, Uuid serviceId, Uuid charId) {
    final characteristic = QualifiedCharacteristic(deviceId: deviceId, serviceId: serviceId, characteristicId: charId);
    return _ble.subscribeToCharacteristic(characteristic);
  }

  Future<void> write(String deviceId, Uuid serviceId, Uuid charId, List<int> data, {bool withoutResponse = true}) async {
    final qc = QualifiedCharacteristic(deviceId: deviceId, serviceId: serviceId, characteristicId: charId);
    if (withoutResponse) {
      await _ble.writeCharacteristicWithoutResponse(qc, value: data);
    } else {
      await _ble.writeCharacteristicWithResponse(qc, value: data);
    }
  }
}