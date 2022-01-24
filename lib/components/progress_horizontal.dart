import 'package:flutter/material.dart';

class ProgressHorizontal extends StatelessWidget {
  final String currentState;
  final bool isEndQuery;
  final bool isPoscoData;

  const ProgressHorizontal({Key key, this.currentState, this.isEndQuery = false, this.isPoscoData = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double physicalWidth = MediaQuery.of(context).size.width;
    double screenWidth = (physicalWidth >= 800) ? 800 : physicalWidth;

    if (isPoscoData) {
      if (!isEndQuery) {
        return Container(
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              transProgress(context, isStart: true, transStr: "포스코\n출고"),
              transProgress(context, isLast: true, transStr: "고객사\n도착"),
            ],
          ),
        );
      } else if (currentState == null || currentState.isEmpty || currentState == '하차장미입고' || currentState == '포스코출고') {
        return Container(
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              transProgress(context, isStart: true, isCurrent: true, transStr: "포스코\n출고"),
              transProgress(context, isLast: true, transStr: "고객사\n도착"),
            ],
          ),
        );
      } else {
        return Container(
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              transProgress(context, isStart: true, transStr: "포스코\n출고"),
              transProgress(context, isLast: true, isCurrent: true, transStr: "고객사\n도착"),
            ],
          ),
        );
      }
    }

    if (!isEndQuery) {
      return Container(
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            transProgress(context, isStart: true, transStr: "하차장\n미입고"),
            transProgress(context, transStr: "하차장\n입고"),
            transProgress(context, transStr: "출고\n"),
            transProgress(context, isLast: true, transStr: "고객사\n도착")
          ],
        ),
      );
    } else if (currentState == null || currentState.isEmpty) {
      return Container(
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            transProgress(context, isStart: true, isCurrent: true, transStr: "하차장\n미입고"),
            transProgress(context, transStr: "하차장\n입고"),
            transProgress(context, transStr: "출고\n"),
            transProgress(context, isLast: true, transStr: "고객사\n도착")
          ],
        ),
      );
    } else if (currentState == '하차장미입고') {
      return Container(
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            transProgress(context, isStart: true, isCurrent: true, transStr: "하차장\n미입고"),
            transProgress(context, transStr: "하차장\n입고"),
            transProgress(context, transStr: "출고\n"),
            transProgress(context, isLast: true, transStr: "고객사\n도착")
          ],
        ),
      );
    } else if (currentState == '하차장입고') {
      return Container(
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            transProgress(context, isStart: true, isDone: true, transStr: "하차장\n미입고"),
            transProgress(context, isCurrent: true, transStr: "하차장\n입고"),
            transProgress(context, transStr: "출고\n"),
            transProgress(context, isLast: true, transStr: "고객사\n도착")
          ],
        ),
      );
    } else if (currentState == '출고') {
      return Container(
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            transProgress(context, isStart: true, isDone: true, transStr: "하차장\n미입고"),
            transProgress(context, isDone: true, transStr: "하차장\n입고"),
            transProgress(context, isCurrent: true, transStr: "출고\n"),
            transProgress(context, isLast: true, transStr: "고객사\n도착")
          ],
        ),
      );
    } else {
      return Container(
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            transProgress(context, isStart: true, isDone: true, transStr: "하차장\n미입고"),
            transProgress(context, isDone: true, transStr: "하차장\n입고"),
            transProgress(context, isDone: true, transStr: "출고\n"),
            transProgress(context, isCurrent: true, isLast: true, transStr: "고객사\n도착")
          ],
        ),
      );
    }
  }

  Widget transProgress(
    BuildContext context, {
    bool isStart = false,
    bool isLast = false,
    bool isCurrent = false,
    bool isDone = false,
    String transStr,
  }) {
    double physicalWidth = MediaQuery.of(context).size.width;
    double screenWidth = (physicalWidth >= 800) ? 800 : physicalWidth;

    double itemWidth = (screenWidth - 30) / 4;

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Stack(
              children: [
                Container(
                  height: 30,
                  width: itemWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          height: isStart
                              ? 0
                              : (isDone || isCurrent)
                                  ? 3
                                  : 1,
                          color: isStart
                              ? Colors.transparent
                              : (isDone || isCurrent)
                                  ? Color(0xFF8DC025)
                                  : Color(0xFFCCCCCC),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          height: isLast
                              ? 0
                              : isDone
                                  ? 3
                                  : 1,
                          color: isLast
                              ? Colors.transparent
                              : isDone
                                  ? Color(0xFF8DC025)
                                  : Color(0xFFCCCCCC),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 30,
                  width: itemWidth,
                  alignment: Alignment.center,
                  child: isCurrent
                      ? currentCircle()
                      : isDone
                          ? prevCircle()
                          : nextCircle(),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            width: 60,
            alignment: Alignment.center,
            child: Text(
              transStr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'ns-bold',
                fontSize: 17,
                color: isDone
                    ? Color(0xFF464A3A)
                    : isCurrent
                        ? Color(0xFF8DC025)
                        : Color(0xFFB5B4B4),
              ),
            ),
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
