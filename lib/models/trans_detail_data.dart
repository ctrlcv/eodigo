import 'package:eodigo/services/data_set.dart';

class TransDetailData {
  String invoiceNumber;
  String productNumber;
  int transOrder;
  String transDate;
  String transTime;
  String dayOfTheWeek;
  String transTitle;
  String transBody;

  TransDetailData(
      {this.invoiceNumber,
      this.productNumber,
      this.transOrder,
      this.transDate,
      this.transTime,
      this.dayOfTheWeek,
      this.transTitle,
      this.transBody});

  factory TransDetailData.fromJson(Map<String, dynamic> json) => _$TransDetailDataFromJson(json);
  Map<String, dynamic> toJson() => _$TransDetailDataToJson(this);
  static Map<String, String> columns() => _$TransDetailDataColumns();
  static DbTable listToTable(List<TransDetailData> list) => _$TransDetailDataListToTable(list);

  @override
  String toString() {
    return 'TransDetailData{invoiceNumber: $invoiceNumber, productNumber: $productNumber, transOrder: $transOrder, transDate: $transDate, transTime: $transTime, dayOfTheWeek: $dayOfTheWeek, transTitle: $transTitle, transBody: $transBody}';
  }
}

TransDetailData _$TransDetailDataFromJson(Map<String, dynamic> parsedJson) {
  return TransDetailData(
      invoiceNumber: parsedJson['송장번호'] as String,
      productNumber: parsedJson['제품번호'] as String,
      transOrder: parsedJson['순번'] as int,
      transDate: parsedJson['일자'] as String,
      transTime: parsedJson['시간'] as String,
      dayOfTheWeek: parsedJson['요일'] as String,
      transTitle: parsedJson['로그정보'] as String,
      transBody: parsedJson['로그내용'] as String);
}

Map<String, dynamic> _$TransDetailDataToJson(TransDetailData instance) => <String, dynamic>{
      '송장번호': instance.invoiceNumber,
      '제품번호': instance.productNumber,
      '순번': instance.transOrder,
      '일자': instance.transDate,
      '시간': instance.transTime,
      '요일': instance.dayOfTheWeek,
      '로그정보': instance.transTitle,
      '로그내용': instance.transBody
    };

Map<String, String> _$TransDetailDataColumns() => <String, String>{
      '송장번호': 'System.String',
      '제품번호': 'System.String',
      '순번': 'System.int32',
      '일자': 'System.String',
      '시간': 'System.String',
      '요일': 'System.String',
      '로그정보': 'System.String',
      '로그내용': 'System.String',
    };

DbTable _$TransDetailDataListToTable(List<TransDetailData> list) {
  var cols = TransDetailData.columns();
  var rows = list.map((e) {
    var mx = e.toJson();
    var lx = mx.keys.map((e) => mx[e]).toList();
    return lx;
  }).toList();
  return DbTable()
    ..tableName = 'ADATA'
    ..columns = cols
    ..rows = rows;
}
