import 'dart:async';

import 'package:eodigo/components/menu_dialog.dart';
import 'package:eodigo/components/progress_horizontal.dart';
import 'package:eodigo/models/menu_model.dart';
import 'package:eodigo/models/trans_data.dart';
import 'package:eodigo/models/trans_detail_data.dart';
import 'package:eodigo/services/network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOpenDetail = false;
  bool _isAllUpdate = false;
  bool _isLoading = false;
  bool _isEndQuery = false;
  bool _isPoscoData = false;
  TextEditingController _searchEditingController;

  TransData _transInfo;
  List<TransDetailData> _transDetails;
  String _lastTransState;
  String _searchNumber = '송장번호';

  Uri _initialUri;
  Uri _latestUri;
  Object _err;

  StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _searchEditingController = TextEditingController();
    _handleIncomingLinks();
    _handleInitialUri();

    print(Modular.args?.queryParams['invoice']);
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    _sub.cancel();
    super.dispose();
  }

  Future<Null> loadTransInfoItems() async {
    if (_searchEditingController.text.isEmpty) {
      print('loadTransInfoItems() _searchEditingController.text is Empty');
      return;
    }

    _isLoading = true;
    _isEndQuery = false;
    _isPoscoData = false;

    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> params = Map();
    if (_searchNumber == '송장번호') {
      params['조건'] = 0;
    } else {
      params['조건'] = 1;
    }

    params['검색'] = _searchEditingController.text.toUpperCase();
    Map<String, dynamic> result = await Network().reqProductLocationEx(params);

    _transInfo = null;
    if (_transDetails != null) {
      _transDetails.clear();
    }
    _lastTransState = '';

    if (result != null) {
      _transInfo = result['transInfo'];
      _transDetails = result['transDetails'];

      print(_transDetails);

      if (_transDetails != null && _transDetails.length > 0) {
        _transDetails.sort((itemA, itemB) {
          if (itemA.transOrder > itemB.transOrder) {
            return 1;
          } else if (itemA.transOrder < itemB.transOrder) {
            return -1;
          } else {
            return 0;
          }
        });

        _isPoscoData = _transDetails[0].transTitle.contains('포스코') && (_transDetails.length == 2);
        _lastTransState = _transDetails[_transDetails.length - 1].transTitle;
      }

      print(_lastTransState);

      _isOpenDetail = (_transInfo != null);
      _isAllUpdate = true; //(_transDetails != null && _transDetails.length > 0);
    }

    _isLoading = false;
    _isEndQuery = true;

    if (mounted) {
      setState(() {});
    }
  }

  Future<Null> loadTransInfoItemsFromURI() async {
    if (_searchEditingController.text.isEmpty) {
      print('loadTransInfoItems() _searchEditingController.text is Empty');
      return;
    }

    _isLoading = true;
    _isEndQuery = false;
    _isPoscoData = false;

    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> params = Map();
    _searchNumber = '송장번호';
    params['조건'] = 0;
    params['검색'] = _searchEditingController.text.toUpperCase();
    Map<String, dynamic> result = await Network().reqProductLocationEx(params);

    _transInfo = null;
    if (_transDetails != null) {
      _transDetails.clear();
    }
    _lastTransState = '';

    if (result != null) {
      _transInfo = result['transInfo'];
      _transDetails = result['transDetails'];

      if (_transDetails != null && _transDetails.length > 0) {
        _transDetails.sort((itemA, itemB) {
          if (itemA.transOrder > itemB.transOrder) {
            return 1;
          } else if (itemA.transOrder < itemB.transOrder) {
            return -1;
          } else {
            return 0;
          }
        });

        _isPoscoData = _transDetails[0].transTitle.contains('포스코') && (_transDetails.length == 2);
        _lastTransState = _transDetails[_transDetails.length - 1].transTitle;
      }

      _isOpenDetail = (_transInfo != null);
      _isAllUpdate = true; //(_transDetails != null && _transDetails.length > 0);
    }

    _isLoading = false;
    _isEndQuery = true;

    if (mounted) {
      setState(() {});
    }
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri uri) {
        if (!mounted) {
          return;
        }

        print('got uri: $uri');

        if (uri != null) {
          if (uri.toString().contains("invoice=")) {
            String orderNo = uri.toString().split("invoice=").last;
            if (orderNo != null && orderNo.isNotEmpty) {
              _searchEditingController.text = orderNo;
              loadTransInfoItemsFromURI();
            } else {
              _searchEditingController.clear();
            }
          } else {
            _searchEditingController.clear();
          }
        }

        setState(() {
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      // _showSnackBar('_handleInitialUri called');
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
          if (uri != null) {
            if (uri.toString().contains("invoice=")) {
              String orderNo = uri.toString().split("invoice=").last;
              if (orderNo != null && orderNo.isNotEmpty) {
                _searchEditingController.text = orderNo;
                loadTransInfoItemsFromURI();
              } else {
                _searchEditingController.clear();
              }
            } else {
              _searchEditingController.clear();
            }
          }
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() => _err = err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFF8DC025));
    }

    double imageSize = 110;

    double physicalWidth = MediaQuery.of(context).size.width;
    double screenWidth = (physicalWidth >= 800) ? 800 : physicalWidth;

    if (screenWidth < 346) {
      imageSize = (screenWidth - 26) / 3;
      print("screenWidth: $screenWidth, imageSize : $imageSize");
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  height: 76,
                  width: screenWidth,
                  color: Color(0xFF8DC025),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 32,
                            ),
                            Expanded(
                              child: Container(
                                height: 76,
                                alignment: Alignment.center,
                                child: Image(
                                  width: 126,
                                  height: 33,
                                  image: AssetImage('assets/images/img_logo.png'),
                                ),
                              ),
                            ),
                            Container(
                              width: 32,
                              alignment: Alignment.center,
                              child: Image(
                                width: 32,
                                height: 32,
                                image: AssetImage('assets/images/bell.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 33,
                  color: Color(0xFF374C0E),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 35,
                            alignment: Alignment.center,
                            child: Text(
                              '조회',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'ns-regular',
                              ),
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 36,
                            alignment: Alignment.bottomCenter,
                            child: Image(
                              width: 8,
                              image: AssetImage('assets/images/indicator.png'),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 35,
                        alignment: Alignment.center,
                        child: Text(
                          '도착 예정 시간',
                          style: TextStyle(
                            color: Color(0xFFA8A8A8),
                            fontSize: 15,
                            fontFamily: 'ns-regular',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              width: screenWidth,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '운송조회',
                                    style: TextStyle(
                                      color: Color(0xFF464A3A),
                                      fontSize: 26,
                                      fontFamily: 'ns-bold',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Express',
                                    style: TextStyle(
                                      color: Color(0xFF464A3A),
                                      fontSize: 26,
                                      fontFamily: 'ns-light',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              width: screenWidth,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    width: imageSize,
                                    height: imageSize,
                                    image: AssetImage('assets/images/img_item_0.png'),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Image(
                                    width: imageSize,
                                    height: imageSize,
                                    image: AssetImage('assets/images/img_item_1.png'),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Image(
                                    width: imageSize,
                                    height: imageSize,
                                    image: AssetImage('assets/images/img_item_2.png'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              width: screenWidth,
                              height: 25,
                              color: Color(0xFFF6F6F6),
                              margin: EdgeInsets.symmetric(horizontal: 16),
                            ),
                            ProgressHorizontal(
                              currentState: _lastTransState,
                              isEndQuery: _isEndQuery,
                              isPoscoData: _isPoscoData,
                            ),
                            Container(
                              width: screenWidth,
                              height: 15,
                              color: Color(0xFFF6F6F6),
                              margin: EdgeInsets.symmetric(horizontal: 16),
                            ),
                            Container(
                              width: screenWidth,
                              height: 80,
                              color: Color(0xFF8DC025),
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        '송장번호ㆍ제품번호를\n입력하시고 운송 정보를 확인하세요.',
                                        style: TextStyle(
                                          fontFamily: 'ns-medium',
                                          fontSize: (screenWidth < 415) ? 14 : 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Image(
                                    image: AssetImage('assets/images/search_bg.png'),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              height: 64,
                              color: Color(0xFFEDF3D7),
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 40,
                                    padding: EdgeInsets.only(
                                      left: 8,
                                      right: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xFFD8D8D8),
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () async {
                                        List<Menu> menuItems = List();
                                        menuItems.add(Menu("송장번호", Icons.request_quote_outlined, null));
                                        menuItems.add(Menu("제품번호", Icons.description_outlined, null));

                                        final resultStr = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MenuDialog(menuList: menuItems);
                                          },
                                          barrierDismissible: false,
                                        );

                                        if (resultStr != null || resultStr.isNotEmpty) {
                                          setState(() {
                                            if (resultStr != _searchNumber) {
                                              _searchEditingController.clear();
                                            }
                                            _searchNumber = resultStr;
                                          });
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(bottom: 2),
                                              child: Text(
                                                _searchNumber,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'ns-bold',
                                                  color: Color(0xFF464A3A),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Color(0xFFD8D8D8),
                                            size: 22,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      color: Colors.white,
                                      alignment: Alignment.centerLeft,
                                      child: TextField(
                                        controller: _searchEditingController,
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 8, right: 4.0),
                                          suffixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 32),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              _searchEditingController.clear();
                                            },
                                            child: Container(
                                              width: 20,
                                              child: Icon(
                                                Icons.highlight_off_sharp,
                                                color: Color(0xFFD8D8D8),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          isCollapsed: false,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(0),
                                            borderSide: BorderSide(
                                              color: Color(0xFFD8D8D8),
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(0),
                                            borderSide: BorderSide(
                                              color: Color(0xFFD8D8D8),
                                              width: 1.0,
                                            ),
                                          ),
                                          hintText: "검색...",
                                          hintStyle: TextStyle(
                                            fontFamily: 'ns-light',
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'ns-medium',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      currentFocus.unfocus();
                                      loadTransInfoItems();
                                    },
                                    child: Container(
                                      child: Image(
                                        height: 35,
                                        image: AssetImage('assets/images/next.png'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              width: screenWidth,
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              padding: EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color(0xFFD8D8D8),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '운송 상세 정보',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'ns-bold',
                                            color: Color(0xFF464A3A),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isOpenDetail = !_isOpenDetail;
                                          });
                                        },
                                        child: Icon(
                                          !_isOpenDetail
                                              ? Icons.keyboard_arrow_down_outlined
                                              : Icons.keyboard_arrow_up_outlined,
                                          color: Color(0xFF8DC025),
                                          size: 26,
                                        ),
                                      )
                                    ],
                                  ),
                                  if (_isOpenDetail)
                                    ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 8),
                                      physics: ClampingScrollPhysics(),
                                      children: <Widget>[
                                        detailInfoItem(
                                            '송장번호',
                                            (_transInfo == null || _transInfo.invoiceNumber == null)
                                                ? '-'
                                                : _transInfo.invoiceNumber,
                                            0),
                                        detailInfoItem(
                                            '제품번호',
                                            (_transInfo == null || _transInfo.productNumber == null)
                                                ? '-'
                                                : _transInfo.productNumber,
                                            1),
                                        detailInfoItem(
                                            '운송사',
                                            (_transInfo == null || _transInfo.transCompany == null)
                                                ? '-'
                                                : _transInfo.transCompany,
                                            0),
                                        detailInfoItem(
                                            '출고차량',
                                            (_transInfo == null || _transInfo.transCar == null)
                                                ? '-'
                                                : _transInfo.transCar,
                                            1),
                                        detailInfoItem(
                                            '운전기사',
                                            (_transInfo == null || _transInfo.driver == null) ? '-' : _transInfo.driver,
                                            0),
                                        detailInfoItem(
                                            '전화번호',
                                            (_transInfo == null || _transInfo.driverNumber == null)
                                                ? '-'
                                                : _transInfo.driverNumber,
                                            1),
                                        detailInfoItem(
                                            'ORDER LINE',
                                            (_transInfo == null || _transInfo.orderLine == null)
                                                ? '-'
                                                : _transInfo.orderLine,
                                            0),
                                        detailInfoItem(
                                            '상세착지',
                                            (_transInfo == null || _transInfo.destAddress == null)
                                                ? '-'
                                                : _transInfo.destAddress,
                                            1),
                                        detailInfoItem(
                                            '도착예정시간',
                                            (_transInfo == null || _transInfo.estimatedArrivalTime == null)
                                                ? '-'
                                                : _transInfo.estimatedArrivalTime.substring(0, 16),
                                            0),
                                      ],
                                    ),
                                  if (_isOpenDetail)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isOpenDetail = false;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF739D20),
                                          borderRadius: BorderRadius.circular(3.0),
                                        ),
                                        child: Text(
                                          "닫기",
                                          style: TextStyle(
                                            fontFamily: 'ns-bold',
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_isOpenDetail)
                                    SizedBox(
                                      height: 10,
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              width: screenWidth,
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              padding: EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color(0xFFD8D8D8),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          '전체 화물 운송건 업데이트',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'ns-bold',
                                            color: Color(0xFF464A3A),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isAllUpdate = !_isAllUpdate;
                                          });
                                        },
                                        child: Icon(
                                          !_isAllUpdate
                                              ? Icons.keyboard_arrow_down_outlined
                                              : Icons.keyboard_arrow_up_outlined,
                                          color: Color(0xFF8DC025),
                                          size: 26,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_isAllUpdate)
                                    if (_transDetails == null || _transDetails.length == 0)
                                      _isEndQuery
                                          ? emptyTransDetailContainer()
                                          : Container(
                                              height: 60,
                                              alignment: Alignment.center,
                                              child: Text('운송 정보가 없습니다.',
                                                  style: TextStyle(
                                                    fontFamily: 'ns-light',
                                                    fontSize: 15,
                                                    color: Color(0xFF464A3A),
                                                  )),
                                            )
                                    else
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 25,
                                          ),
                                          ListView.builder(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: _transDetails.length,
                                            reverse: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return transDetailContainer(_transDetails[index], index);
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      if (_isLoading)
                        Container(
                          color: Color(0x44000000),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF002551)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container detailInfoItem(String title, String body, int index) {
    return Container(
      color: (index % 2 == 0) ? Color(0xFFEDF3D7) : Colors.white,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 105,
            height: 32,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'ns-light',
                fontSize: 14,
                color: Color(0xFF464A3A),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: Text(
                body,
                softWrap: true,
                style: TextStyle(
                  fontFamily: 'ns-light',
                  fontSize: 13,
                  color: Color(0xFF464A3A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container emptyTransDetailContainer() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 32,
                alignment: Alignment.center,
                child: Center(
                  child: prevCircle(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  '하차장 미입고',
                  style: TextStyle(
                    fontFamily: 'ns-bold',
                    fontSize: 15,
                    color: Color(0xFFB1B1B1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Container transDetailContainer(TransDetailData transDetail, int index) {
    bool isFirst = (index == _transDetails.length - 1);
    bool isLast = (index == 0);
    List<String> dates = transDetail.transDate.split('-');
    String dateStr = dates[0] + '년 ' + dates[1] + '월 ' + dates[2] + '일';

    double physicalWidth = MediaQuery.of(context).size.width;
    double screenWidth = (physicalWidth >= 800) ? 800 : physicalWidth;

    return Container(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 15,
                child: Center(
                  child: Container(
                    width: isFirst ? 0 : 2,
                    color: Color(0xFFD8D8D8),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 19,
                child: Center(
                  child: Container(
                    width: isFirst ? 0 : 2,
                    color: Color(0xFFD8D8D8),
                  ),
                ),
              ),
              Container(
                child: Text(
                  transDetail.dayOfTheWeek,
                  style: TextStyle(
                    fontFamily: 'ns-bold',
                    fontSize: 12,
                    color: Color(0xFFB5B4B4),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 32,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Container(
                              width: isFirst ? 0 : 2,
                              color: Color(0xFFD8D8D8),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              width: isLast ? 0 : 2,
                              color: Color(0xFFD8D8D8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isLast && !isFirst)
                      Center(
                        child: Image(
                          width: 24,
                          height: 24,
                          image: AssetImage('assets/images/location.png'),
                        ),
                      )
                    else
                      Center(
                        child: isFirst ? prevCircle() : nextCircle(),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  dateStr,
                  style: TextStyle(
                    fontFamily: 'ns-bold',
                    fontSize: 15,
                    color: Color(0xFF464A3A),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 65,
                child: Center(
                  child: Container(
                    width: isLast ? 0 : 2,
                    color: Color(0xFFD8D8D8),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          transDetail.transTime,
                          style: TextStyle(
                            fontFamily: 'ns-bold',
                            fontSize: 13,
                            color: isFirst ? Color(0xFF8DC025) : Color(0xFF464A3A),
                          ),
                        ),
                        Text(
                          '  ' + transDetail.transTitle,
                          style: TextStyle(
                            fontFamily: 'ns-bold',
                            fontSize: 13,
                            color: isFirst ? Color(0xFF8DC025) : Color(0xFFB5B4B4),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      transDetail.transBody,
                      style: TextStyle(
                        fontFamily: 'ns-bold',
                        fontSize: 13,
                        color: isFirst ? Color(0xFF8DC025) : Color(0xFFB5B4B4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isLast)
            Container(
              height: 1,
              width: screenWidth,
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Color(0xFFE3EBD4),
            ),
        ],
      ),
    );
  }

  Container currentCircle() {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Color(0xFF8DC025),
        border: Border.all(
          color: Color(0xFFE1E1E1),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 17,
        height: 17,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xFF739D20),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Container prevCircle() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFE1E1E1),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Color(0xFF739D20),
          border: Border.all(
            color: Color(0xFF739D20),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Container nextCircle() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFE1E1E1),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
