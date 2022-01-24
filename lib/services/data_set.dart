class DataSet {
  String dataSetName;
  List<DbTable> tables = <DbTable>[];

  //--------------------------------------------------------------------------------
  DataSet();

  factory DataSet.fromJson(Map<String, dynamic> json) => _$DataSetFromJson(json);
  Map<String, dynamic> toJson() => _$DataSetToJson(this);
}

class DbTable {
  String tableName;
  Map columns;
  List<List<dynamic>> rows;

  DbTable();

  List<Map<String, dynamic>> toDataJson() => _$DbTableToDataJson(this);

  factory DbTable.fromJson(Map<String, dynamic> json) => _$DbTableFromJson(json);
  Map<String, dynamic> toJson() => _$DbTableToJson(this);
}

//-----------------------------------------------------------------------------
// Custom Json Map Functions
//-----------------------------------------------------------------------------
DbTable _$DbTableFromJson(Map<String, dynamic> json) => DbTable()
  ..tableName = json['t'] as String
  ..columns = json['c'] == null ? null : (json['c'] as Map)
  ..rows = (json['r'] as List)?.map((e) => e == null ? null : e as List)?.toList();

Map<String, dynamic> _$DbTableToJson(DbTable instance) => <String, dynamic>{
      't': instance.tableName,
      'c': instance.columns,
      'r': instance.rows,
    };

List<Map<String, dynamic>> _$DbTableToDataJson(DbTable instance) {
  var cols = instance.columns;
  var retn = instance.rows.map((e) {
    var mx = new Map<String, dynamic>();
    e.asMap().forEach((idx, value) {
      var cnx = cols.keys.elementAt(idx);
      mx[cnx] = value;
    });
    return mx;
  }).toList();
  return retn;
}

DataSet _$DataSetFromJson(Map<String, dynamic> json) {
  var dsn = json.keys.first;
  return DataSet()
    ..dataSetName = dsn
    ..tables = (json[dsn] as List)?.map((e) => e == null ? null : DbTable.fromJson(e as Map))?.toList();
}

Map<String, dynamic> _$DataSetToJson(DataSet instance) => <String, dynamic>{instance.dataSetName: instance.tables};
