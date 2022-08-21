import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'home/home.dart';
import 'menu/menu.dart';

void main() {
  runApp(const Phoenix());
}

class Phoenix extends StatelessWidget {
  const Phoenix({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '에이닷',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: Home(),
      initialRoute: "/home",
      getPages: [
        getPage("/home", Home()),
        getPage("/menu", Menu()),
      ],
    );
  }

  GetPage getPage(String name, Widget pageName) {
    return GetPage(
        name: name,
        page: () => pageName,
        transition: Transition.cupertinoDialog);
  }
}
