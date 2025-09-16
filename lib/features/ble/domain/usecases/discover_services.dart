import '../ble_repository.dart';
import '../entities.dart';
import '../../../../core/result.dart';

class DiscoverServicesUseCase {
  final BleRepository repo;
  const DiscoverServicesUseCase(this.repo);
  Future<Result<List<GattServiceInfo>>> call(String deviceId) => repo.discover(deviceId);
}