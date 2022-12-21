import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../index.dart';
import 'constants.dart';

void printLog(dynamic data) {
  if (kDebugMode) {
    log(
      "$data",
      name: Constants.appName,
    );
  }
}

void showErrorToast(dynamic message) {
  showToastWidget(
    Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(6),
          boxShadow: kElevationToShadow[3]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            "$message",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
    position: const ToastPosition(
      align: Alignment.topRight,
      offset: 12,
    ),
    dismissOtherToast: true,
    animationCurve: Curves.easeIn,
    duration: const Duration(seconds: 6),
  );
}

void showSuccessToast(dynamic message) {
  showToast(
    "$message",
    position: const ToastPosition(
      align: Alignment.topRight,
      offset: 12,
    ),
    dismissOtherToast: true,
    margin: const EdgeInsets.all(8),
    animationCurve: Curves.easeIn,
    duration: const Duration(seconds: 6),
    textPadding: const EdgeInsets.all(10),
    radius: 4,
    backgroundColor: Colors.green[300],
  );
}
