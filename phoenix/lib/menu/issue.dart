import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:phoenix/custom_utils.dart';

import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<dynamic> crowlingdata = [];

class Issue extends StatefulWidget {
  const Issue({Key? key}) : super(key: key);

  @override
  State<Issue> createState() => _IssueState();
}

class _IssueState extends State<Issue> {
  void _callAPI() async {
    var url = Uri.parse(
      'http://20.249.210.78:8000/',
    );
    var response = await http.get(url);

    print('Response status: ${response.statusCode}');
    crowlingdata = json.decode(response.body);
    print(crowlingdata[0]['링크'].runtimeType);

    List<String> columns = ["발행일자", "분야", "타이틀", "링크", "요약문"]; // +"본문"
    // print(testdatas.length);
    for (int x = 0; x < crowlingdata.length; x++) {
      for (var y in columns) {
        print('Response body: ${crowlingdata[x][y]}');
      }
    }
  }

  @override
  void initState() {
    _callAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white, //appbar 투명색
        centerTitle: true,
        elevation: 0.0, // 그림자 농도 0
        leading: IconButton(
          icon: Image.asset("assets/a_dot_menu.png"),
          onPressed: () {
            Get.offAndToNamed("menu");
          },
        ),
        title: Text(
          "이슈닷",
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
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Text(
                  "주요 뉴스를 알려드릴게요!",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Image.asset("assets/final_phoenix.gif"))),
            ],
          ),
          CustomScrollView(
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
              IssueExpanded(),
              IssueTitle("정치/시사"),
              IssueContent(2),
              IssueTitle("경제"),
              IssueContent(2),
              IssueTitle("사회"),
              IssueContent(2),
              IssueTitle("세계"),
              IssueContent(2),
              IssueTitle("IT/과학"),
              IssueContent(2),
              TestData("test")
            ],
          ),
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
        children: <Widget>[Nav_Content("뉴스 요약"), Nav_Content("오늘의 퀴즈")],
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
        width: MediaQuery.of(context).size.width * 0.5,
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
            width: MediaQuery.of(context).size.width * 0.5,
            height: 2.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget IssueExpanded() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Visibility(
                visible: isSelected[0],
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
              ),
          childCount: 1),
    );
  }

  Widget IssueTitle(String string) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Visibility(
                visible: isSelected[0],
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Text(
                        string,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
          childCount: 1),
    );
  }

  final List<String> titlecontents = ["남북관계 더 나빠져..", "국민의힘 이준석 또 울어?"];
  final List<String> summarycontents = [
    "남북관계가 더 나빠진 이유를 말씀드리자면, 먼저 제가 샌프란시스코에 있을 때 부터 얘기를 해야하는데요...",
    "이준석 머리만 좋지 정치쪽으론 재능 없어.. 하지만 영욱이형을 접견한 같은 사람으로써 마음이 아파와.."
  ];
  final List<String> newscontents = [
    "https://news.nate.com/view/20220824n20041?mid=n1006",
    "https://news.nate.com/view/20220824n07008?mid=n1006"
  ];
  final List<String> pointsubcontents = ["50", "75"];
  Widget IssueContent(int count) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Visibility(
                visible: isSelected[0],
                child: ListTile(
                  title: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(220, 245, 245, 250),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 7,
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        titlecontents[index],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ))),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                      child: Text("원문 보기"),
                                      onPressed: () {
                                        Get.defaultDialog(
                                            title: "이슈닷",
                                            content: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.7,
                                              child: WebviewScaffold(
                                                url: newscontents[index],
                                                withZoom: true,
                                                withLocalStorage: true,
                                              ),
                                            ));
                                      },
                                    ),
                                  ))
                            ],
                          ),
                          Container(
                            child: Text(
                              summarycontents[index],
                              style: TextStyle(color: Colors.black54),
                            ),
                          )
                        ],
                      )),
                ),
              ),
          childCount: count),
    );
  }

  Widget TestData(String data) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Visibility(
                visible: isSelected[1],
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(top: 20),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: TextButton(
                        onPressed: _callAPI,
                        child: testText(data),
                        // child: Text(
                        //   data,
                        //   style: TextStyle(
                        //       fontSize: 30, fontWeight: FontWeight.bold),
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
          childCount: 1),
    );
  }

  Widget testText(String text) {
    for (var checker in Custom_Utils().dummydata) {
      if (text == checker) {
        print(checker);
      }
    }
    print(text);
    return Text(text);
  }

  Widget testTextButton(String text) {
    return TextButton(onPressed: () {}, child: Text(text));
  }
}
