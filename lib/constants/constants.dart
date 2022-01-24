import 'dart:io';

import 'package:flutter/foundation.dart';

const String API_URL_DEV = "app.xn--299ao9m1oo.com";
const String API_URL_PRO = "app.xn--299ao9m1oo.com";

const String API_PATH_DEV = "/api/run/WHERE/";
const String API_PATH_PRO = "/api/run/WHERE/";

String getApiUrl() => isRelease() ? API_URL_PRO : API_URL_DEV;
String getApiPath() => isRelease() ? API_PATH_PRO : API_PATH_DEV;

bool isRelease() {
  if (kIsWeb) {
    return true;
  }

  return bool.fromEnvironment('dart.vm.product');
}

Map<String, String> postHeaders = {
  HttpHeaders.contentTypeHeader: "application/json",
  HttpHeaders.authorizationHeader: "Basic dXNlcjpwYSQk",
};
