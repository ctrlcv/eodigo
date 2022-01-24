import 'package:eodigo/screen/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  //runApp(MyApp());
  runApp(ModularApp(module: AppModule(), child: MyApp()));
}

Map<int, Color> color = {
  50: Color.fromRGBO(141, 192, 37, .1),
  100: Color.fromRGBO(141, 192, 37, .2),
  200: Color.fromRGBO(141, 192, 37, .3),
  300: Color.fromRGBO(141, 192, 37, .4),
  400: Color.fromRGBO(141, 192, 37, .5),
  500: Color.fromRGBO(141, 192, 37, .6),
  600: Color.fromRGBO(141, 192, 37, .7),
  700: Color.fromRGBO(141, 192, 37, .8),
  800: Color.fromRGBO(141, 192, 37, .9),
  900: Color.fromRGBO(141, 192, 37, 1),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '어디고',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF8DC025, color),
      ),
      debugShowCheckedModeBanner: false,
      //home: HomeScreen(),
    ).modular();
  }
}

class AppModule extends Module {
  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (context, args) => HomeScreen()),
    ChildRoute('/', child: (context, args) => HomeScreen()),
    ChildRoute('/product', child: (context, args) => HomeScreen()),
  ];
}
