import '../ble_repository.dart';
import '../../../../core/result.dart';

class DisconnectDeviceUseCase {
  final BleRepository repo;
  const DisconnectDeviceUseCase(this.repo);
  Future<Result<void>> call() => repo.disconnect();
}