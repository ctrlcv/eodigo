class TransInfo {
  String invoiceNumber;
  String productNumber;
  String transCompany;
  String transCar;
  String driver;
  String driverNumber;
  String orderLine;
  String destAddress;
  String estimatedArrivalTime;

  TransInfo(
      {this.invoiceNumber,
      this.productNumber,
      this.transCompany,
      this.transCar,
      this.driver,
      this.driverNumber,
      this.orderLine,
      this.destAddress,
      this.estimatedArrivalTime});

  factory TransInfo.fromJson(Map<String, dynamic> parsedJson) {
    return TransInfo(
        invoiceNumber: parsedJson['송장번호'],
        productNumber: parsedJson['제품번호'],
        transCompany: parsedJson['운송사'],
        transCar: parsedJson['출고차량'],
        driver: parsedJson['운전기사'],
        driverNumber: parsedJson['기사전화번호'],
        orderLine: parsedJson['ORDER_LINE'],
        destAddress: parsedJson['도착지주소'],
        estimatedArrivalTime: parsedJson['도착예정시간']);
  }
}

class TransDetail {
  String invoiceNumber;
  String productNumber;
  int transOrder;
  String transDate;
  String transTime;
  String dayOfTheWeek;
  String transTitle;
  String transBody;

  TransDetail(
      {this.invoiceNumber,
      this.productNumber,
      this.transOrder,
      this.transDate,
      this.transTime,
      this.dayOfTheWeek,
      this.transTitle,
      this.transBody});

  factory TransDetail.fromJson(Map<String, dynamic> parsedJson) {
    return TransDetail(
        invoiceNumber: parsedJson['송장번호'],
        productNumber: parsedJson['제품번호'],
        transOrder: parsedJson['순번'],
        transDate: parsedJson['일자'],
        transTime: parsedJson['시간'],
        dayOfTheWeek: parsedJson['요일'],
        transTitle: parsedJson['로그정보'],
        transBody: parsedJson['로그내용']);
  }
}

class TransDetailsList {
  final List<TransDetail> transDetails;

  TransDetailsList({this.transDetails});

  factory TransDetailsList.fromJson(List<dynamic> parsedJson) {
    var list = parsedJson;
    List<TransDetail> resultList = list.map((i) => TransDetail.fromJson(i)).toList();

    return TransDetailsList(transDetails: resultList);
  }
}
