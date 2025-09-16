import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../ble_repository.dart';

class ConnectDeviceUseCase {
  final BleRepository repo;
  const ConnectDeviceUseCase(this.repo);
  Stream<ConnectionStateUpdate> call(String deviceId) => repo.connect(deviceId);
}