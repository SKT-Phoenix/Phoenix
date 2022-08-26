import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:phoenix/custom_utils.dart';

import '../home/home.dart';

class Quest extends StatefulWidget {
  const Quest({Key? key}) : super(key: key);

  @override
  State<Quest> createState() => _QuestState();
}

class _QuestState extends State<Quest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Custom_Utils().Colors_SKT_Background(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white, //appbar 투명색
        centerTitle: true,
        elevation: 0.0, // 그림자 농도 0
        leading: IconButton(
          icon: Image.asset("assets/attendance.png"),
          onPressed: () {},
        ),
        title: Text(
          "퀘스트",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Custom_Utils().Colors_SKT_Background(),
            pinned: true,
            flexibleSpace: Column(
              children: [NavBar(), Nav_Animation()],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(-6.0),
              child: SizedBox(),
            ),
          ),
          QuestTitle("매일매일 A.과 함께"),
          QuestDailyContents(dailycontents.length),
          QuestTitle("A. 더 잘 쓰기"),
          QuestSubContent(subcontents.length)
        ],
      ),
    );
  }

  final List<bool> isSelected = [true, false];
  Widget NavBar() {
    return Container(
      color: Colors.white,
      child: ToggleButtons(
        selectedColor: Colors.black,
        color: Colors.grey,
        fillColor: Colors.white,
        renderBorder: false,
        highlightColor: Colors.white,
        splashColor: Colors.white,
        children: <Widget>[Nav_Content("진행 퀘스트"), Nav_Content("배지")],
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < isSelected.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                isSelected[buttonIndex] = true;
              } else {
                isSelected[buttonIndex] = false;
              }
            }
          });
        },
        isSelected: isSelected,
      ),
    );
  }

  Widget Nav_Content(String name) {
    return Container(
        width: layoutSize.size.width * 0.5,
        // height: 30,
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ));
  }

  Widget Nav_Animation() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1.5),
          child: Container(
            width: double.infinity,
            height: 0.5,
            color: Color.fromARGB(255, 170, 170, 170),
          ),
        ),
        AnimatedAlign(
          alignment:
              isSelected[0] ? Alignment.centerLeft : Alignment.centerRight,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          child: Container(
            width: layoutSize.size.width * 0.5,
            height: 2.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget QuestTitle(String string) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Container(
                padding: EdgeInsets.only(top: 20),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Text(
                      string,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          childCount: 1),
    );
  }

  final List<String> subcontents = [
    "[동영상] '드라마 볼래'로 볼만한 드라마 찾기",
    "[음악] '인기 음악 틀어줘'로 핫한 음악 틀어보기",
    "[캘린더] '오늘 일정 등록해줘'라고 말해보기",
    "[큐피드], '근처 산책하기 좋은 곳 추천해줘'와 같이 질문하기",
    "[길안내] 'TMAP 켜줘'로 TMAP 실행하기",
    "[날씨] '날씨 알려줘'와 같이 날씨 확인하기",
  ];
  final List<String> pointsubcontents = ["50", "75", "65", "35", "80", "70"];
  Widget QuestSubContent(int count) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/con.png",
                              width: 20,
                            ),
                            Text(
                              pointsubcontents[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          subcontents[index],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: Image.asset("assets/move.png"),
                            onPressed: () {},
                          )),
                    ]),
                  ),
                ),
              ),
          childCount: count),
    );
  }

  final List<String> dailycontents = [
    "'끝말잇기 하자'와 같이 끝말잇기 대결 요청하기",
    "'인기있는 음악 틀어줘'와 같이 음악재생 요청하기",
    "'오늘 일정 등록해줘'같이 A. 캘린더 이용하기",
    "'오늘의 주요 뉴스 알려줘'와 같이 이슈닷 이용하기"
  ];
  final List<String> pointdailycontents = ["30", "35", "30", "90"];
  Widget QuestDailyContents(int count) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 2,
                      color: Custom_Utils().Colors_SKT_Blue(),
                    ),
                  ),
                  child: Column(
                    children: [
                      QuestDailyTitle(),
                      QuestDailyContent(0),
                      QuestDailyContent(1),
                      QuestDailyContent(2),
                      QuestDailyContent(3),
                    ],
                  ),
                ),
              ),
          childCount: 1),
    );
  }

  Widget QuestDailyTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: QuestText("데일리 미션", Colors.black, 18)),
                Row(
                  children: [
                    QuestText("2022. 8. 24. (수)까지", Colors.grey, 11),
                    Expanded(child: SizedBox()),
                    QuestText("0", Custom_Utils().Colors_SKT_Blue(), 11),
                    QuestText("/${dailycontents.length}", Colors.grey, 11)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Custom_Utils().Colors_SKT_Background(),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    Container(
                        height: 35, child: Image.asset("assets/cube2.png")),
                    QuestText("1", Colors.black, 12)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget QuestText(String name, Color color, double size) {
    return Text(
      name,
      style:
          TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold),
    );
  }

  Widget QuestDailyContent(int index) {
    return ListTile(
      title: Row(children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Image.asset(
                "assets/con.png",
                width: 20,
              ),
              Text(
                pointdailycontents[index],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dailycontents[index],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
            flex: 4,
            child: IconButton(
              icon: Image.asset("assets/move.png"),
              onPressed: () {
                if (index == 3) {
                  Get.offAndToNamed("/issue");
                }
              },
            )),
      ]),
    );
  }
}
