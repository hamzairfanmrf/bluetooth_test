import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../ble/domain/usecases/connect_device.dart';
import '../../../ble/domain/usecases/disconnect_device.dart';

class ConnectionStateVM {
  final String? deviceId; final DeviceConnectionState state; final String? error;
  const ConnectionStateVM({this.deviceId, this.state = DeviceConnectionState.disconnected, this.error});
  ConnectionStateVM copyWith({String? deviceId, DeviceConnectionState? state, String? error}) => ConnectionStateVM(deviceId: deviceId ?? this.deviceId, state: state ?? this.state, error: error);
}

class ConnectionNotifier extends StateNotifier<ConnectionStateVM> {
  final ConnectDeviceUseCase _connect; final DisconnectDeviceUseCase _disconnect;
  StreamSubscription<ConnectionStateUpdate>? _sub;
  ConnectionNotifier(this._connect, this._disconnect) : super(const ConnectionStateVM());

  void connect(String deviceId) {
    state = state.copyWith(deviceId: deviceId, state: DeviceConnectionState.connecting, error: null);
    _sub?.cancel();
    _sub = _connect(deviceId).listen((u) {
      state = state.copyWith(state: u.connectionState);
    }, onError: (e) {
      state = state.copyWith(state: DeviceConnectionState.disconnected, error: e.toString());
    });
  }

  Future<void> disconnect() async {
    await _disconnect(); // ✅ no deviceId
    await _sub?.cancel(); _sub = null;
    state = state.copyWith(state: DeviceConnectionState.disconnected);
  }

  @override
  void dispose() { _sub?.cancel(); super.dispose(); }
}