import 'dart:convert';

import 'package:eodigo/constants/constants.dart';
import 'package:eodigo/models/trans_data.dart';
import 'package:eodigo/models/trans_detail_data.dart';
import 'package:eodigo/models/trans_model.dart';
import 'package:eodigo/services/web_api.dart';
import 'package:http/http.dart' as http;

import 'api_types.dart';
import 'data_set.dart';

class Network {
  Future reqProductLocation(Map<String, dynamic> params) async {
    try {
      var url = Uri.https(getApiUrl(), getApiPath() + '제품_조회', {'q': '{http}'});
      var jsonBody = jsonEncode(params);

      var response = await http.post(url, headers: postHeaders, body: jsonBody);
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        if (jsonResponse == null || jsonResponse['Q1'].length == 0) {
          print('[Error] reqProductLocation() jsonResponse is Empty, return');
          return null;
        }

        TransInfo transInfo = TransInfo.fromJson(jsonResponse['Q1'][0]);
        TransDetailsList transDetailsList = TransDetailsList.fromJson(jsonResponse['Q2']);

        Map<String, dynamic> productResult = Map();
        productResult["transInfo"] = transInfo;
        productResult["transDetails"] = transDetailsList;

        return productResult;
      } else {
        print('[Error] reqProductLocation() response Error $jsonResponse');
        return null;
      }
    } catch (e) {
      print('Exception reqProductLocation()');
      print(e);
    }
  }

  Future reqProductLocationEx(Map<String, dynamic> params) async {
    var errorMessage;

    var resp = await runStoredProcedure('제품_조회', params, null);
    print('resp.code ${resp.code}');

    if (resp.ok) {
      var sv = json.decode(resp.data);
      var rds = DataSet.fromJson(sv);

      var dbSet = rds.tables[0].toDataJson();
      List<Map> ax = dbSet;
      var transInfo = ax.map((e) => TransData.fromJson(e)).toList();
      // print('transInfo $transInfo');
      if (transInfo == null || transInfo.length == 0) {
        return null;
      }

      var transDetailsDbSet = rds.tables[1].toDataJson();
      List<Map> tdSetList = transDetailsDbSet;
      var transDetailsList = tdSetList.map((e) => TransDetailData.fromJson(e)).toList();
      // print('transDetailsList $transDetailsList');

      Map<String, dynamic> productResult = Map();
      productResult["transInfo"] = transInfo[0];
      productResult["transDetails"] = transDetailsList;

      return productResult;
    }

    errorMessage = resp.data.toString();
    print('[ERROR] reqProductLocationEx() $errorMessage');
    return null;
  }

  Future reqProductLocationFromURL(Map<String, dynamic> params) async {
    try {
      var url = Uri.https(getApiUrl(), getApiPath() + 'Product_Get', {'q': '{http}'});
      var jsonBody = jsonEncode(params);

      var response = await http.post(url, headers: postHeaders, body: jsonBody);
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        if (jsonResponse == null || jsonResponse['Q1'].length == 0) {
          print('[Error] reqProductLocationFromURL() jsonResponse is Empty, return');
          return null;
        }

        TransInfo transInfo = TransInfo.fromJson(jsonResponse['Q1'][0]);
        TransDetailsList transDetailsList = TransDetailsList.fromJson(jsonResponse['Q2']);

        Map<String, dynamic> productResult = Map();
        productResult["transInfo"] = transInfo;
        productResult["transDetails"] = transDetailsList;

        return productResult;
      } else {
        print('[Error] reqProductLocationFromURL() response Error $jsonResponse');
        return null;
      }
    } catch (e) {
      print('Exception reqProductLocation()');
      print(e);
    }
  }

  Future reqProductLocationFromURLEx(Map<String, dynamic> params) async {
    var errorMessage;

    var resp = await runStoredProcedure('Product_Get', params, null);
    print('resp.code ${resp.code}');

    if (resp.ok) {
      var sv = json.decode(resp.data);
      var rds = DataSet.fromJson(sv);

      var dbSet = rds.tables[0].toDataJson();
      List<Map> ax = dbSet;
      var transInfo = ax.map((e) => TransData.fromJson(e)).toList();
      // print('transInfo $transInfo');

      var transDetailsDbSet = rds.tables[1].toDataJson();
      List<Map> tdSetList = transDetailsDbSet;
      var transDetailsList = tdSetList.map((e) => TransDetailData.fromJson(e)).toList();
      // print('transDetailsList $transDetailsList');

      Map<String, dynamic> productResult = Map();
      productResult["transInfo"] = transInfo[0];
      productResult["transDetails"] = transDetailsList;

      return productResult;
    }

    errorMessage = resp.data.toString();
    print('[ERROR] reqProductLocationFromURLEx() $errorMessage');
    return null;
  }

  Future<ApiResult> runStoredProcedure(String spName, Map fieldValue, DataSet dataSet) async {
    var body = ApiProcObj(
      code: "SP01",
      prms: {
        "SP": spName,
        "FV": fieldValue == null ? null : json.encode(fieldValue),
        "DS": dataSet?.toJson(),
      },
    );

    var resp = await WebApi().reqProcess("SAMICK", body);
    return resp;
  }
}
