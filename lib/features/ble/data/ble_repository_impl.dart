import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide Result;
import '../../../core/result.dart';
import '../domain/ble_repository.dart';
import '../domain/entities.dart';
import 'ble_data_source.dart';

class BleRepositoryImpl implements BleRepository {
  final BleDataSource ds;
  BleRepositoryImpl(this.ds);

  @override
  Stream<BleDevice> scan() => ds.scan();

  @override
  Future<Result<void>> stopScan() async {
    try { await ds.stopScan(); return const Ok(null); } catch (e, s) { return Err(e, s); }
  }

  @override
  Stream<ConnectionStateUpdate> connect(String deviceId) => ds.connect(deviceId);

  @override
  Future<Result<void>> disconnect() async {
    try {
      await ds.disconnect();
      return const Ok(null);
    } catch (e, s) {
      return Err(e, s);
    }
  }
  @override
  Future<Result<List<GattServiceInfo>>> discover(String deviceId) async {
    try { final out = await ds.discover(deviceId); return Ok(out); } catch (e, s) { return Err(e, s); }
  }

  @override
  Stream<List<int>> observe(String deviceId, Uuid serviceId, Uuid charId) => ds.observe(deviceId, serviceId, charId);

  @override
  Future<Result<void>> write(String deviceId, Uuid serviceId, Uuid charId, List<int> data, {bool withoutResponse = true}) async {
    try { await ds.write(deviceId, serviceId, charId, data, withoutResponse: withoutResponse); return const Ok(null); } catch (e, s) { return Err(e, s); }
  }
}