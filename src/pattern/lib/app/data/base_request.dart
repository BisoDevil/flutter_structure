import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../core/utils/constants.dart';

import '../../core/utils/utils_function.dart';
import '../../core/widgets/loading_widget.dart';
import '../../index.dart';

class BaseRequest {
  static final GetHttpClient _req = GetHttpClient(
    baseUrl: "${Constants.domainUrl}/api",
    allowAutoSignedCert: true,
  );
  static final SharedPreferences localStorage = Get.find<SharedPreferences>();
  static Future<dynamic> dynamicRequest(
    String path, {
    RequestType requestType = RequestType.get,
    dynamic body,
    bool showDialog = false,
  }) async {
    String token = localStorage.getString("token") ?? "";

    WidgetsBinding.instance.addPostFrameCallback((s) async {
      // var connectivityResult = await Connectivity().checkConnectivity();
      // if (connectivityResult == ConnectivityResult.none) {
      //   Get.to(() => NoNetworkWidget());
      //   return;
      // }

      if (showDialog) {
        showToastWidget(
          const LoadingWidget(),
          duration: const Duration(
            seconds: 8,
          ),
          dismissOtherToast: true,
        );
      }
    });

    var res = await _req.request(
      path,
      describeEnum(requestType),
      body: body,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).catchError((onError) {
      debugPrint(onError.toString());
      showErrorToast(onError.toString());
    });

    debugPrint("${res.request!.url},$token");
    if (res.isOk) {
      dismissAllToast();
      debugPrint((res.body as Map).toJSON());

      return res.body['data'];
    } else {
      debugPrint("${res.body}");
      String error = 'something went wrong';
      if (res.body is Map && res.body['message'] != null) {
        error = res.body['message'];
      } else if (jsonDecode(res.bodyString!)['errors'] != null) {
        error = '';
        Map<String, dynamic> errors = jsonDecode(res.bodyString!)['errors'];
        errors.forEach((key, value) {
          error += "$key : ${value.join(',')}\n";
        });
      }

      showErrorToast(error);
      return null;
    }
  }
}

enum RequestType { get, post, put, delete }
