import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';

import '../../index.dart';

extension Format on DateTime {
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
}

extension ConvertBase64 on Uint8List {
  String toBase64() {
    return base64Encode(this);
  }
}

extension SharedMap on SharedPreferences {
  Future<bool> setMap(String key, Map<String, dynamic> map) async {
    return setString(key, map.toJSON());
  }

  Map<String, dynamic>? getMap(String key) {
    var str = getString(key);
    if (str == null) return null;
    return jsonDecode(str);
  }
}

extension Sizer on num {
  /// Calculates the height depending on the device's screen size
  ///
  /// Eg: 20.h -> will take 20% of the screen's height
  double get h => this * Get.height / 100;

  /// Calculates the width depending on the device's screen size
  ///
  /// Eg: 20.w -> will take 20% of the screen's width
  double get w => this * Get.width / 100;
}
