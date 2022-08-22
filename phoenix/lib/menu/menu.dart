import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../custom_utils.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _lights = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 245, 249),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 25),
                child: Column(
                  children: [profile(), points()],
                ),
              ),
              Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [services(), voice_change()],
                ),
              )
            ],
          ),
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
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 244, 245, 249),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [points_text(), points_token()]),
          ),
        ],
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
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                child: Image.asset("assets/cube.png"),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: customIconButton("75", Color.fromARGB(255, 0, 10, 62)),
              ),
            ),
            Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  "|",
                  style: TextStyle(color: Colors.grey),
                ))),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                child: Image.asset("assets/con.png"),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child:
                    customIconButton("1,049", Color.fromARGB(255, 0, 10, 62)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customIconButton(String label, Color color) {
    return Text(
      label,
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
      textAlign: TextAlign.end,
    );
  }

  Widget services() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Column(
          children: [
            service_item("assets/calendar.png", "캘린더"),
            service_item("assets/tmap.png", "TMAP"),
            service_item("assets/qpeed.png", "큐피드"),
            service_item("assets/quest.png", "퀘스트"),
            service_item("assets/reword.png", "리워드"),
          ],
        ),
      ),
    );
  }

  Widget service_item(String image_path, String name) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: TextButton.icon(
            onPressed: () {},
            icon: Image.asset(image_path, height: 38),
            label: Text(
              name,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, color: Colors.black),
            )),
      ),
    );
  }

  Widget voice_change() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "캐릭터 음성으로 응답듣기",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      Text(
                        "응답결과에 대해 음성으로 안내 받는 것에 대해켜거나 끌 수 있습니다.",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: CupertinoSwitch(
                  value: _lights,
                  activeColor: Custom_Utils().Colors_SKT_Blue(),
                  onChanged: (bool value) {
                    setState(() {
                      _lights = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
