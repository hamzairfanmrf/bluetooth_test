import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide Result;
import '../ble_repository.dart';
import '../../../../core/result.dart';

class WriteCharacteristicUseCase {
  final BleRepository repo;
  const WriteCharacteristicUseCase(this.repo);
  Future<Result<void>> call(String deviceId, Uuid serviceId, Uuid charId, List<int> data, {bool withoutResponse = true})
  => repo.write(deviceId, serviceId, charId, data, withoutResponse: withoutResponse);
}