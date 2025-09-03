import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CountdownController extends ValueNotifier<int> {
  CountdownController({
    int? durationMs,
    this.stepDuration = const Duration(seconds: 1),
    this.onEnd,
  })  : assert(durationMs != null && durationMs > 0),
        super(durationMs!);

  Timer? _timer;
  int? _lastTimestamp;

  final Duration stepDuration;
  final VoidCallback? onEnd;

  bool get isRunning => _timer != null;

  Duration get currentDuration => Duration(milliseconds: value);

  void start() {
    if (value <= 0) return;
    _dispose();

    // Show initial value immediately
    notifyListeners();

    _lastTimestamp = DateTime.now().millisecondsSinceEpoch;

    _timer = Timer.periodic(stepDuration, (timer) {
      _tick();
    });
  }

  void _tick() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsed = _lastTimestamp != null ? now - _lastTimestamp! : stepDuration.inMilliseconds;

    value = max(value - elapsed, 0);
    _lastTimestamp = now;

    notifyListeners();

    if (value <= 0) {
      stop();
      onEnd?.call();
    }
  }

  void stop() {
    _dispose();
  }

  void pause() {
    _dispose();
  }

  void _dispose() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
