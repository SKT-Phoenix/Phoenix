import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phoenix/menu/quest.dart';
import 'package:phoenix/menu/webview.dart';
import 'baner.dart';
import 'home/home.dart';
import 'menu/issue.dart';
import 'menu/leaderboard.dart';
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
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      initialRoute: "/baner",
      home: Home(),
      getPages: [
        getBaner("/baner", Baner()),
        getHome("/home", Home()),
        getMenu("/menu", Menu()),
        getQuest("/quest", Quest()),
        getIssue("/issue", Issue()),
        getIssue("/rank", LeaderBoard()),
        getWebview("/webview", IssueWebView()),
      ],
    );
  }

  GetPage getBaner(String name, Widget pageName) {
    return GetPage(name: name, page: () => pageName);
  }

  GetPage getHome(String name, Widget pageName) {
    return GetPage(
        name: name,
        page: () => pageName,
        transition: Transition.noTransition,
        transitionDuration: Duration(milliseconds: 300));
  }

  GetPage getMenu(String name, Widget pageName) {
    return GetPage(
        name: name,
        page: () => pageName,
        curve: Curves.decelerate,
        transition: Transition.leftToRight,
        popGesture: false);
  }

  GetPage getQuest(String name, Widget pageName) {
    return GetPage(
        name: name,
        page: () => pageName,
        transition: Transition.downToUp,
        popGesture: false);
  }

  GetPage getIssue(String name, Widget pageName) {
    return GetPage(
        name: name,
        page: () => pageName,
        transition: Transition.cupertino,
        popGesture: false);
  }

  GetPage getWebview(String name, Widget pageName) {
    return GetPage(
        name: name, page: () => pageName, transition: Transition.fadeIn);
  }
}
