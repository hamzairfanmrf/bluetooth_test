import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../ble_repository.dart';

class ObserveCharacteristicUseCase {
  final BleRepository repo;
  const ObserveCharacteristicUseCase(this.repo);
  Stream<List<int>> call(String deviceId, Uuid serviceId, Uuid charId) => repo.observe(deviceId, serviceId, charId);
}