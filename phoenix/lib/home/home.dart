import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent, //appbar 투명색
        centerTitle: true,
        elevation: 0.0, // 그림자 농도 0
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black54,
          ),
          onPressed: () {
            print("메뉴진입");
            Get.toNamed("/menu");
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.outbox_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainText("A.모르는 사람 없게 해주세요~\n 닷생살자 이벤트 🎁"),
            Adot(),
            SubMenu()
          ],
        ),
      ),
    );
  }

  Widget MainText(String text) {
    return Center(
        child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    ));
  }

  Widget Adot() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
      ),
    );
  }

  Widget SubMenu() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.18,
      ),
    );
  }
}
