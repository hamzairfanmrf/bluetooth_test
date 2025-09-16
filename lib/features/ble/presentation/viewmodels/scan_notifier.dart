import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../ble/domain/usecases/start_scan.dart';
import '../../../ble/domain/usecases/stop_scan.dart';
import '../../../ble/domain/entities.dart';

class ScanState {
  final bool isScanning; final Map<String, BleDevice> devices;
  const ScanState({this.isScanning = false, this.devices = const {}});
  ScanState copyWith({bool? isScanning, Map<String, BleDevice>? devices}) => ScanState(isScanning: isScanning ?? this.isScanning, devices: devices ?? this.devices);
}

class ScanNotifier extends StateNotifier<ScanState> {
  final StartScanUseCase _start; final StopScanUseCase _stop; StreamSubscription? _sub;
  ScanNotifier(this._start, this._stop) : super(const ScanState());

  void start() {
    if (state.isScanning) return;
    state = state.copyWith(isScanning: true, devices: const {});
    _sub = _start().listen((d) {
      final map = Map<String, BleDevice>.from(state.devices); map[d.id] = d; state = state.copyWith(devices: map);
    }, onError: (_) => state = state.copyWith(isScanning: false));
  }

  Future<void> stop() async { await _sub?.cancel(); _sub = null; await _stop(); state = state.copyWith(isScanning: false); }
  @override
  void dispose() { _sub?.cancel(); super.dispose(); }
}