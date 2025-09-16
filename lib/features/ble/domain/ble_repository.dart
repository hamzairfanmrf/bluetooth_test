import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide Result;
import 'entities.dart';
import '../../../core/result.dart';

abstract class BleRepository {
  Stream<BleDevice> scan();
  Future<Result<void>> stopScan();

  Stream<ConnectionStateUpdate> connect(String deviceId);
  Future<Result<void>> disconnect(); // removed deviceId

  Future<Result<List<GattServiceInfo>>> discover(String deviceId);

  Stream<List<int>> observe(String deviceId, Uuid serviceId, Uuid charId);
  Future<Result<void>> write(String deviceId, Uuid serviceId, Uuid charId, List<int> data, {bool withoutResponse = true});
}