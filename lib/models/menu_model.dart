import 'package:flutter/material.dart';

class Menu {
  String menuTitle;
  IconData menuIcon;
  Function onPressMenu;
  Widget imageData;

  Menu(this.menuTitle, this.menuIcon, this.onPressMenu, {this.imageData});
}
