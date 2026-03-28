import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';

class DynamicIconService {
  DynamicIconService._();

  static const _channel = MethodChannel('dynamic_icon');

  /// Returns 'NightIcon' when the night icon is active, 'DayIcon' otherwise.
  static Future<String> getCurrentIcon() async {
    try {
      final name = await _channel.invokeMethod<String>('getIcon');
      return name ?? 'DayIcon';
    } on PlatformException catch (e) {
      log('Failed to get current icon: ${e.message}');
      return 'DayIcon';
    }
  }

  static Future<void> setNightIcon() async {
    try {
      await _channel.invokeMethod('setIcon', {'icon': 'NightIcon'});
    } on PlatformException catch (e) {
      log('Failed to set night icon: ${e.message}');
      rethrow;
    }
  }

  static Future<void> setDayIcon() async {
    try {
      await _channel.invokeMethod('setIcon', {'icon': 'DayIcon'});
    } on PlatformException catch (e) {
      log('Failed to set day icon: ${e.message}');
      rethrow;
    }
  }
}
