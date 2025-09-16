import '../ble_repository.dart';
import '../../../../core/result.dart';

class StopScanUseCase {
  final BleRepository repo;
  const StopScanUseCase(this.repo);
  Future<Result<void>> call() => repo.stopScan();
}