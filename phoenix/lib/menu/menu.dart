import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:phoenix/baner.dart';
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
      backgroundColor: Custom_Utils().Colors_SKT_Background(),
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
                  children: [profile(userName), points()],
                ),
              ),
              Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    services(),
                    voice_change(),
                    ad_item(),
                    bottom_bar(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget profile(String name) {
    String image_path = "";
    final abot_profiles = [
      "assets/adot_profile/kc_profile.png",
      "assets/adot_profile/hh_profile.png",
      "assets/adot_profile/jk_profile.png",
      "assets/adot_profile/yj_profile.png",
      "assets/adot_profile/yo_profile.png",
      "assets/adot_profile/hu_profile.png",
      "assets/adot_profile/default_profile.png",
    ];
    if (name == "김찬") {
      image_path = abot_profiles[0];
    } else if (name == "황현") {
      image_path = abot_profiles[1];
    } else if (name == "서진경") {
      image_path = abot_profiles[2];
    } else if (name == "김예지") {
      image_path = abot_profiles[3];
    } else if (name == "박영원" || name == "박원영") {
      image_path = abot_profiles[4];
    } else if (name == "이현우") {
      image_path = abot_profiles[5];
    } else {
      image_path = abot_profiles[6];
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 80,
              child: Image.asset(
                image_path,
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
                    "${name}님의",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "에이닷",
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
              color: Custom_Utils().Colors_SKT_Background(),
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
              child: Container(
                alignment: Alignment.center,
                child: customIconButton("75", Color.fromARGB(255, 0, 10, 62)),
              ),
            ),
            Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  "|",
                  style: TextStyle(color: Color.fromARGB(30, 277, 277, 235)),
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
              child: Container(
                alignment: Alignment.center,
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
            service_item("assets/issuedot.png", "이슈닷"),
            service_item("assets/reword.png", "리워드"),
          ],
        ),
      ),
    );
  }

  Widget service_item(String image_path, String name) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton.icon(
            onPressed: () {
              if (name == "퀘스트") {
                Get.offAndToNamed("/quest");
              } else if (name == "이슈닷") {
                Get.offAndToNamed("/issue");
              }
            },
            icon: Image.asset(image_path, height: 38),
            label: Text(
              name,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Custom_Utils().Colors_SKT_Background()),
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

  Widget ad_item() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 230, 232, 254),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "A. 에서 T멤버십 쓰면?",
                            style: TextStyle(
                                color: Color.fromARGB(255, 76, 84, 113),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5.0),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "T포인트 5,000p 적립!",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/ad_img.png"),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottom_bar() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 80.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 4,
              child: Text(
                "이벤트",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              )),
          Expanded(
              flex: 1,
              child: Text(
                "|",
                style: TextStyle(color: Color.fromARGB(30, 277, 277, 235)),
                textAlign: TextAlign.center,
              )),
          Expanded(
              flex: 4,
              child: Text(
                "공지사항",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ))
        ],
      ),
    );
  }
}
