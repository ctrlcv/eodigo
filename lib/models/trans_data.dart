import 'package:eodigo/services/data_set.dart';

class TransData {
  String invoiceNumber;
  String productNumber;
  String transCompany;
  String transCar;
  String driver;
  String driverNumber;
  String orderLine;
  String destAddress;
  String estimatedArrivalTime;
  TransData(
      {this.invoiceNumber,
      this.productNumber,
      this.transCompany,
      this.transCar,
      this.driver,
      this.driverNumber,
      this.orderLine,
      this.destAddress,
      this.estimatedArrivalTime});

  factory TransData.fromJson(Map<String, dynamic> json) => _$TransDataFromJson(json);
  Map<String, dynamic> toJson() => _$TransDataToJson(this);
  static Map<String, String> columns() => _$TransDataColumns();
  static DbTable listToTable(List<TransData> list) => _$TransDataListToTable(list);

  @override
  String toString() {
    return 'TransData{invoiceNumber: $invoiceNumber, productNumber: $productNumber, transCompany: $transCompany, transCar: $transCar, driver: $driver, driverNumber: $driverNumber, orderLine: $orderLine, destAddress: $destAddress, estimatedArrivalTime: $estimatedArrivalTime}';
  }
}

TransData _$TransDataFromJson(Map<String, dynamic> parsedJson) {
  return TransData(
      invoiceNumber: parsedJson['송장번호'] as String,
      productNumber: parsedJson['제품번호'] as String,
      transCompany: parsedJson['운송사'] as String,
      transCar: parsedJson['출고차량'] as String,
      driver: parsedJson['운전기사'] as String,
      driverNumber: parsedJson['기사전화번호'] as String,
      orderLine: parsedJson['ORDER_LINE'] as String,
      destAddress: parsedJson['도착지주소'] as String,
      estimatedArrivalTime: parsedJson['도착예정시간'] as String);
}

Map<String, dynamic> _$TransDataToJson(TransData instance) => <String, dynamic>{
      '송장번호': instance.invoiceNumber,
      '제품번호': instance.productNumber,
      '운송사': instance.transCompany,
      '출고차량': instance.transCar,
      '운전기사': instance.driver,
      '기사전화번호': instance.driverNumber,
      'ORDER_LINE': instance.orderLine,
      '도착지주소': instance.destAddress,
      '도착예정시간': instance.estimatedArrivalTime
    };

Map<String, String> _$TransDataColumns() => <String, String>{
      '송장번호': 'System.String',
      '제품번호': 'System.String',
      '운송사': 'System.String',
      '출고차량': 'System.String',
      '운전기사': 'System.String',
      '기사전화번호': 'System.String',
      'ORDER_LINE': 'System.String',
      '도착지주소': 'System.String',
      '도착예정시간': 'System.String',
    };

DbTable _$TransDataListToTable(List<TransData> list) {
  var cols = TransData.columns();
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
