import 'dart:async';

import 'package:flutter/services.dart';

class SamuraiScan {
  static const MethodChannel _channel = const MethodChannel('samurai_scan');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> scan() async {
    final String code = await _channel.invokeMethod("scan");
    return code;
  }
}
