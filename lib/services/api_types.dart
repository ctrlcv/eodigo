import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

/// 서버(미들웨어)에 명령을 전달하기 위한 프로토콜 양식
@JsonSerializable()
class ApiCommand {
  /// 서비스 구분. 서버에 설정된 서비스에 따라 접근 Database 를 지정할 수 있다.
  final String namespc;

  /// 서버와 교신하는 보안 타입 구분 설정
  @JsonKey(name: 'sndtime')
  String xsecure;

  /// 호출하는 사용자 계정 고유정보 (예약됨)
  String snduser;

  /// 호출 명령 코드 (query, runproc, addon 중 하나)
  final String command;

  /// 명령 파라미터 정보
  final String objects;
  ApiCommand({
    this.namespc,
    xsecure,
    snduser,
    this.command,
    this.objects,
  })  : xsecure = xsecure ?? "9999-12-31",
        snduser = snduser ?? "-1";

  factory ApiCommand.fromJson(Map<String, dynamic> json) => _$ApiCommandFromJson(json);
  Map<String, dynamic> toJson() => _$ApiCommandToJson(this);
}

//-----------------------------------------------------------------------------
/// 서버 내장 프로세스나 Custom Addon (사용자정의 프로세스)를 호출한다.
@JsonSerializable()
class ApiProcObj {
  /// 호출할 프로세스 코드명
  @JsonKey(name: 'ContentCode')
  final String code;

  /// 전달할 파라미터 목록
  @JsonKey(name: 'Contents')
  final Map<String, dynamic> prms;
  ApiProcObj({this.code, this.prms});

  factory ApiProcObj.fromJson(Map<String, dynamic> json) => _$ApiProcObjFromJson(json);
  Map<String, dynamic> toJson() => _$ApiProcObjToJson(this);
}

//-----------------------------------------------------------------------------
/// 자동쿼리 요청 전문
@JsonSerializable()
class ApiQryObj {
  /// action code (i,j,u,d,e,r,q,s)
  @JsonKey(name: 'ActKind')
  final String acode;

  /// 요청 대상 테이블 이름
  @JsonKey(name: 'TableName')
  final String tname;

  /// 쿼리 Condition
  @JsonKey(name: 'Where')
  Map<String, dynamic> where;

  /// S: 조회 컬럼, I,U,J,R: 입력컬럼
  @JsonKey(name: 'Values')
  Map<String, dynamic> value;

  /// where 조건에 추가 쿼리 또는 where,value 없이 직접 쿼리를 실행
  @JsonKey(name: 'SQLText')
  String query;

  ApiQryObj({this.acode, this.tname, where, value, query})
      : where = where ?? null,
        value = value ?? null,
        query = query ?? null;

  factory ApiQryObj.fromJson(Map<String, dynamic> json) => _$ApiQryObjFromJson(json);
  Map<String, dynamic> toJson() => _$ApiQryObjToJson(this);
}

//-----------------------------------------------------------------------------
/// 응답 전문
@JsonSerializable()
class ApiResult {
  /// 응답코드 (정상:0000, 그외: 오류 또는 사용자 정의 코드)
  @JsonKey(name: 'ResultCode')
  final String code;

  /// 정상이면 응답 DATA. 오류이면 오류내용.
  @JsonKey(name: 'ResultData')
  final String data;

  ApiResult({this.code, this.data});

  factory ApiResult.fromJson(Map<String, dynamic> json) => _$ApiResultFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResultToJson(this);

  /// 정상처리 된 경우 true
  get ok => code == '0000';

  get errMsg {
    if (ok) return null;
    try {
      var erda = json.decode(this.data);
      var ier = erda['InnerException'];
      var erm = ((ier ?? erda)['Message'] ?? this.data);
      return '($code) $erm';
    } on FormatException catch (e) {
      print(e);
      return '($code) ${this.data}';
    }
  }
}

//-----------------------------------------------------------------------------
/// 응답의 테이블 형식 전문
@JsonSerializable()
class ApiResTable {
  /// 응답 컬럼(필드)
  final List<String> fields;

  /// 데이터 레코드
  final List<dynamic> rows;

  ApiResTable({this.fields, this.rows});

  factory ApiResTable.fromJson(Map<String, dynamic> json) => _$ApiResTableFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResTableToJson(this);
}

ApiCommand _$ApiCommandFromJson(Map<String, dynamic> json) {
  return ApiCommand(
    namespc: json['namespc'] as String,
    xsecure: json['sndtime'],
    snduser: json['snduser'],
    command: json['command'] as String,
    objects: json['objects'] as String,
  );
}

Map<String, dynamic> _$ApiCommandToJson(ApiCommand instance) => <String, dynamic>{
      'namespc': instance.namespc,
      'sndtime': instance.xsecure,
      'snduser': instance.snduser,
      'command': instance.command,
      'objects': instance.objects,
    };

ApiProcObj _$ApiProcObjFromJson(Map<String, dynamic> json) {
  return ApiProcObj(
    code: json['ContentCode'] as String,
    prms: json['Contents'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$ApiProcObjToJson(ApiProcObj instance) => <String, dynamic>{
      'ContentCode': instance.code,
      'Contents': instance.prms,
    };

ApiQryObj _$ApiQryObjFromJson(Map<String, dynamic> json) {
  return ApiQryObj(
    acode: json['ActKind'] as String,
    tname: json['TableName'] as String,
    where: json['Where'],
    value: json['Values'],
    query: json['SQLText'],
  );
}

Map<String, dynamic> _$ApiQryObjToJson(ApiQryObj instance) => <String, dynamic>{
      'ActKind': instance.acode,
      'TableName': instance.tname,
      'Where': instance.where,
      'Values': instance.value,
      'SQLText': instance.query,
    };

ApiResult _$ApiResultFromJson(Map<String, dynamic> json) {
  return ApiResult(
    code: json['ResultCode'] as String,
    data: json['ResultData'] as String,
  );
}

Map<String, dynamic> _$ApiResultToJson(ApiResult instance) => <String, dynamic>{
      'ResultCode': instance.code,
      'ResultData': instance.data,
    };

ApiResTable _$ApiResTableFromJson(Map<String, dynamic> json) {
  return ApiResTable(
    fields: (json['fields'] as List)?.map((e) => e as String)?.toList(),
    rows: json['rows'] as List,
  );
}

Map<String, dynamic> _$ApiResTableToJson(ApiResTable instance) => <String, dynamic>{
      'fields': instance.fields,
      'rows': instance.rows,
    };
