import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_types.dart';

class WebApi {
  static String _url = 'https://app.xn--299ao9m1oo.com/api/hysf/wio'; //getApiUrl();
  final http.Client _api = http.Client();

  /// 서버 미들웨어 접속 공용
  Future<ApiResult> postData(String nameSpc, String command, dynamic data) async {
    try {
      var objs = json.encode(data);
      var body = ApiCommand(
        namespc: nameSpc,
        command: command,
        objects: objs,
      ).toJson();

      var resp = await _api.post(
        Uri.parse(_url),
        body: body,
      );

      var responseBody = json.decode(resp.body);
      return ApiResult.fromJson(responseBody);
    } catch (err) {
      throw err;
    }
  }

  /// 서버 미들웨어 내장 프로세스 호출 (ex> S001)
  Future<ApiResult> reqProcess(String nameSpc, ApiProcObj body) async {
    return await postData(nameSpc, "runproc", body);
  }

  /// 서버 미들웨어 사용자정의 확장 모듈 호출
  Future<ApiResult> reqAddon(String nameSpc, ApiProcObj body) async {
    return await postData(nameSpc, "addon", body);
  }

  /// 서버 미들웨어 자동쿼리 호출
  Future<ApiResult> reqQuery(String nameSpc, List<ApiQryObj> body) async {
    return await postData(nameSpc, "query", body);
  }
}
