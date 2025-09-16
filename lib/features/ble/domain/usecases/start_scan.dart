import '../ble_repository.dart';

class StartScanUseCase {
  final BleRepository repo;
  const StartScanUseCase(this.repo);
  Stream call() => repo.scan();
}