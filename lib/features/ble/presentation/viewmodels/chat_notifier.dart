import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../ble/domain/entities.dart';
import '../../../ble/domain/usecases/observe_characteristic.dart';
import '../../../ble/domain/usecases/write_characteristic.dart';
import '../../../../core/result.dart';

class ChatState {
  final Uuid? serviceId; final Uuid? charId; final List<ChatMessage> log; final String? error;
  const ChatState({this.serviceId, this.charId, this.log = const [], this.error});
  ChatState copyWith({Uuid? serviceId, Uuid? charId, List<ChatMessage>? log, String? error}) => ChatState(serviceId: serviceId ?? this.serviceId, charId: charId ?? this.charId, log: log ?? this.log, error: error);
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ObserveCharacteristicUseCase _observe; final WriteCharacteristicUseCase _write;
  StreamSubscription<List<int>>? _sub; String? _deviceId;
  ChatNotifier(this._observe, this._write) : super(const ChatState());

  void bind(String deviceId, {Uuid? serviceId, Uuid? charId}) { _deviceId = deviceId; state = state.copyWith(serviceId: serviceId, charId: charId, log: []); }

  void subscribe(Uuid serviceId, Uuid charId) {
    final id = _deviceId; if (id == null) return;
    _sub?.cancel(); state = state.copyWith(serviceId: serviceId, charId: charId, error: null);
    _sub = _observe(id, serviceId, charId).listen((bytes) {
      final msg = ChatMessage(DateTime.now(), false, bytes);
      final log = List<ChatMessage>.from(state.log)..add(msg);
      state = state.copyWith(log: log);
    }, onError: (e) => state = state.copyWith(error: e.toString()));
  }

  Future<void> sendText(String text, {bool withoutResponse = true}) async {
    final id = _deviceId; if (id == null) return; final s = state.serviceId; final c = state.charId; if (s == null || c == null) return;
    final bytes = utf8.encode(text);
    final res = await _write(id, s, c, bytes, withoutResponse: withoutResponse);
    if (res is! Ok) {
      state = state.copyWith(error: (res as Err).error.toString());
    } else {
      final msg = ChatMessage(DateTime.now(), true, bytes);
      final log = List<ChatMessage>.from(state.log)..add(msg);
      state = state.copyWith(log: log);
    }
  }

  @override
  void dispose() { _sub?.cancel(); super.dispose(); }
}