void logd(String msg) {
  // ignore: avoid_print
  print('[D] $msg');
}
void loge(Object e, [StackTrace? s]) {
  // ignore: avoid_print
  print('[E] $e\n${s ?? ''}');
}