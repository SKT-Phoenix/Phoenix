import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white, //appbar 투명색
        centerTitle: true,
        elevation: 0.0, // 그림자 농도 0
        leading: SizedBox.shrink(),
        actions: [
          IconButton(
            icon: Image.asset("assets/settings.png"),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [profile(), points()],
        ),
      ),
    );
  }

  Widget profile() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 80,
              child: Image.asset(
                "assets/profile.png",
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "김찬님의",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "닷쥐가뭐에요",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget points() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 244, 245, 249),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: [points_text(), points_token()]),
      ),
    );
  }

  Widget points_text() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "보유 포인트",
            style: TextStyle(color: Color.fromARGB(255, 128, 132, 152)),
          ),
          Expanded(child: Container()),
          TextButton.icon(
            onPressed: () {},
            label: Text(
              "캐릭터 꾸미기",
              style: TextStyle(color: Color.fromARGB(255, 0, 10, 62)),
            ),
            icon: Image.asset("assets/star.png"),
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.resolveWith(
                    (states) => Size.fromHeight(30))),
          )
        ],
      ),
    );
  }

  Widget points_token() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: customIconButton("     75", Color.fromARGB(255, 0, 10, 62),
                  Image.asset("assets/cube.png")),
            ),
            Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  "|",
                  style: TextStyle(color: Colors.grey),
                ))),
            Expanded(
              flex: 4,
              child: customIconButton(
                  "    1,049",
                  Color.fromARGB(255, 0, 10, 62),
                  Image.asset("assets/con.png")),
            )
          ],
        ),
      ),
    );
  }

  Widget customIconButton(String label, Color color, Widget icon) {
    return TextButton.icon(
      onPressed: () {},
      label: Text(
        label,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      icon: icon,
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.resolveWith(
              (states) => Size.fromHeight(30))),
    );
  }
}
