import 'package:eodigo/models/menu_model.dart';
import 'package:flutter/material.dart';

class MenuDialog extends StatelessWidget {
  final List<Menu> menuList;
  final double widthRate;
  const MenuDialog({this.menuList, this.widthRate});

  @override
  Widget build(BuildContext context) {
    double physicalWidth = MediaQuery.of(context).size.width;
    double screenWidth = (physicalWidth >= 800) ? 800 : physicalWidth;
    double dialogWidth = screenWidth * ((widthRate == null) ? 3 / 4 : widthRate);
    double horizontalMargin = (physicalWidth - dialogWidth) / 2;

    // print('screenWidth $screenWidth, dialogWidth $dialogWidth, horizontalMargin $horizontalMargin');

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: screenWidth,
            height: (58 * menuList.length).toDouble(),
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
              boxShadow: [
                BoxShadow(color: Color(0x50000000), offset: Offset(0, 3), blurRadius: 3),
              ],
            ),
            child: ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                return menuItem(
                    context: context,
                    icon: menuList[index].menuIcon,
                    menuTitle: menuList[index].menuTitle,
                    onPressed: menuList[index].onPressMenu,
                    imageData: menuList[index].imageData,
                    index: index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItem(
      {BuildContext context, IconData icon, String menuTitle, Function onPressed, Widget imageData, int index}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFDCDDDC).withOpacity(1),
            width: (index != 0) ? 1.0 : 0.0,
          ),
        ),
      ),
      child: InkWell(
        onTap: (onPressed != null)
            ? onPressed
            : () {
                Navigator.pop(context, menuTitle);
              },
        child: Row(
          children: [
            if (icon != null)
              Container(
                height: 58,
                width: 58,
                alignment: Alignment.center,
                color: Color(0xFF31B2D9),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            if (imageData != null)
              Container(
                height: 58,
                width: 58,
                alignment: Alignment.center,
                color: Color(0xFF31B2D9),
                child: imageData,
              ),
            Expanded(
              child: Text(
                menuTitle,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: 'ns-light',
                  fontSize: 18,
                  color: Color(0xFF002551),
                ),
              ),
            ),
            SizedBox(width: 25),
          ],
        ),
      ),
    );
  }
}
