import 'package:bluetooth_test/features/ble/presentation/viewmodels/chat_notifier.dart';
import 'package:bluetooth_test/features/ble/presentation/viewmodels/connection_notifier.dart';
import 'package:bluetooth_test/features/ble/presentation/viewmodels/scan_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../ble/data/ble_data_source.dart';
import '../../ble/data/ble_repository_impl.dart';
import '../../ble/domain/ble_repository.dart';
import '../../ble/domain/usecases/start_scan.dart';
import '../../ble/domain/usecases/stop_scan.dart';
import '../../ble/domain/usecases/connect_device.dart';
import '../../ble/domain/usecases/disconnect_device.dart';
import '../../ble/domain/usecases/discover_services.dart';
import '../../ble/domain/usecases/observe_characteristic.dart';
import '../../ble/domain/usecases/write_characteristic.dart';


final bleInstanceProvider = Provider<FlutterReactiveBle>((ref) => FlutterReactiveBle());
final dataSourceProvider = Provider<BleDataSource>((ref) => BleDataSource(ref.read(bleInstanceProvider)));
final repositoryProvider = Provider<BleRepository>((ref) => BleRepositoryImpl(ref.read(dataSourceProvider)));

// Use cases
final startScanProvider = Provider((ref) => StartScanUseCase(ref.read(repositoryProvider)));
final stopScanProvider = Provider((ref) => StopScanUseCase(ref.read(repositoryProvider)));
final connectProvider = Provider((ref) => ConnectDeviceUseCase(ref.read(repositoryProvider)));
final disconnectProvider = Provider((ref) => DisconnectDeviceUseCase(ref.read(repositoryProvider)));
final discoverProvider = Provider((ref) => DiscoverServicesUseCase(ref.read(repositoryProvider)));
final observeProvider = Provider((ref) => ObserveCharacteristicUseCase(ref.read(repositoryProvider)));
final writeProvider = Provider((ref) => WriteCharacteristicUseCase(ref.read(repositoryProvider)));

// Notifiers (MVVM)
final scanNotifierProvider = StateNotifierProvider<ScanNotifier, ScanState>((ref) => ScanNotifier(ref.read(startScanProvider), ref.read(stopScanProvider)));
final connectionNotifierProvider = StateNotifierProvider<ConnectionNotifier, ConnectionStateVM>((ref) => ConnectionNotifier(ref.read(connectProvider), ref.read(disconnectProvider)));
final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) => ChatNotifier(ref.read(observeProvider), ref.read(writeProvider)));