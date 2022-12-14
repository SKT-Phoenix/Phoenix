import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phoenix/baner.dart';
import 'package:phoenix/custom_utils.dart';
import 'package:phoenix/menu/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../crowling_datas.dart';
import '../home/home.dart';
import 'quest.dart';
import 'package:http/http.dart' as http;

List<int> colorflag = [0, 0, 0, 0, 0];
List<bool> qnaflag = [false, false, false, false, false];
List<String> inputText = ["", "", "", "", ""];
List<dynamic> qnanumcolor = [
  Colors.black,
  Colors.black,
  Colors.black,
  Colors.black,
  Colors.black
];

class Issue extends StatefulWidget {
  const Issue({Key? key}) : super(key: key);

  @override
  State<Issue> createState() => _IssueState();
}

class _IssueState extends State<Issue> {
  void showSnackBar(BuildContext context, String text, String keyword_exp) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Color.fromARGB(255, 255, 241, 164),
      content: Wrap(
        children: [
          Container(
            width: layoutSize.size.width * 0.8,
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 30)),
          Text(
            keyword_exp,
            style: TextStyle(color: Colors.black45),
          ),
        ],
      ),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.blue,
        disabledTextColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<String> issuedotTitle = ["주요 뉴스를 알려드릴게요!", "퀴즈를 풀어보자!"];
  @override
  Widget build(BuildContext context) {
    Crowling_Datas().callAPI();
    Crowling_Datas().callQuizAPI();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                  height: layoutSize.size.height * 0.15,
                  child: Text(
                    (isSelected[0]) ? issuedotTitle[0] : issuedotTitle[1],
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                    child: Container(
                        width: layoutSize.size.width * 0.5,
                        child: (isSelected[0])
                            ? adot_issue(userName)
                            : Image.asset("assets/quiz.png"))),
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
                IssueExpanded((isSelected[0] == true) ? 0.32 : 0.3),
                IssueContent(10, resultData),
                IssueTitle(quizNum[quizVisible.indexOf(true)]),
                QuizContent(5, resultData)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget adot_issue(String name) {
    String image_path = "assets/adot/kc_adot.gif";
    String pet_image_path = "assets/pet/pet_9.gif";
    final abots = [
      "assets/adot/kc_adot.gif",
      "assets/adot/hh_adot.gif",
      "assets/adot/jk_adot.gif",
      "assets/adot/yj_adot.gif",
      "assets/adot/yo_adot.gif",
      "assets/adot/hu_adot.gif",
    ];
    final abot_pets = [
      "assets/pet/pet_0.gif",
      "assets/pet/pet_2.gif",
      "assets/pet/pet_4.gif",
      "assets/pet/pet_6.gif",
      "assets/pet/pet_8.gif",
      "assets/pet/pet_9.gif",
    ];
    if (name == "김찬") {
      image_path = abots[0];
      pet_image_path = abot_pets[0];
    } else if (name == "황현") {
      image_path = abots[1];
      pet_image_path = abot_pets[1];
    } else if (name == "서진경") {
      image_path = abots[2];
      pet_image_path = abot_pets[2];
    } else if (name == "김예지") {
      image_path = abots[3];
      pet_image_path = abot_pets[3];
    } else if (name == "박영원" || name == "박원영") {
      image_path = abots[4];
      pet_image_path = abot_pets[4];
    } else if (name == "이현우") {
      image_path = abots[5];
      pet_image_path = abot_pets[5];
    } else {
      image_path = abots[0];
    }
    return Stack(
      children: [
        Image.asset(image_path),
        Padding(
          padding: EdgeInsets.only(top: 10, right: 30),
          child: Container(
              alignment: Alignment.topRight,
              height: layoutSize.size.height * 0.07,
              child: Image.asset(pet_image_path)),
        ),
      ],
    );
  }

  final List<bool> isSelected = [true, false];
  Widget NavBar() {
    (isSelected[0]) ? print(crowlingdata) : print(quizData);
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

  Widget IssueExpanded(double size) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Container(
                height: layoutSize.size.height * size,
              ),
          childCount: 1),
    );
  }

  Widget IssueTitle(String quiz) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Visibility(
                visible: isSelected[1],
                child: Container(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Text(
                        quiz,
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

  Widget IssueContent(int count, List<dynamic> data) {
    int SmaxLength = 0;
    for (var i = 0; i < count; i++) {
      (SmaxLength < data[i][1].length)
          ? SmaxLength = data[i][1].length
          : SmaxLength = SmaxLength;
    }

    return SliverToBoxAdapter(
      child: Visibility(
        visible: isSelected[0],
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SizedBox(
            height: layoutSize.size.height * dynamic_BoxH(SmaxLength),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: count,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(220, 245, 245, 250),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: layoutSize.size.width * 0.8,
                    child: Wrap(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 7,
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      data[index][0], // Title
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ))),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                    child: Text(
                                      "원문 보기",
                                      style: (Platform.isAndroid)
                                          ? TextStyle(fontSize: 12)
                                          : TextStyle(fontSize: 14),
                                    ),
                                    onPressed: () {
                                      Get.toNamed("/webview",
                                          arguments: data[index][2]); // link
                                    },
                                    style: ButtonStyle(
                                        alignment: Alignment.topCenter),
                                  ),
                                ))
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          child: Wrap(
                            children: _createChildren(
                                split_summary[index], keywords, keywords_exp),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double dynamic_BoxH(int size) {
    if (size <= 50) {
      return 0.23;
    } else if (size <= 75) {
      return 0.26;
    } else if (size <= 150) {
      return 0.33;
    } else if (size <= 200) {
      return 0.38;
    } else if (size <= 250) {
      return 0.43;
    } else if (size <= 300) {
      return 0.5;
    }
    return 0.6;
  }

  List<String> quizNum = ["Quiz 1", "Quiz 2", "Quiz 3", "Quiz 4", "Quiz 5"];
  List<bool> quizVisible = [true, false, false, false, false];
  Widget QuizContent(int count, List<dynamic> data) {
    return SliverToBoxAdapter(
      child: Visibility(
        visible: isSelected[1],
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SizedBox(
            height: layoutSize.size.height * 0.35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: count,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Visibility(
                      visible: quizVisible[index],
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(220, 245, 245, 250),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: layoutSize.size.width * 0.9,
                        child: Column(
                          children: [
                            quizUI(2, Alignment.centerLeft, quizLists[index],
                                20, FontWeight.bold),
                            quizUI(4, Alignment.topLeft, quizQuestions[index],
                                16, FontWeight.normal),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.topRight,
                                    child: answerField(
                                        quizVisible.indexOf(true)))),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        quizMoveButton(
                                            "left",
                                            Icons.arrow_left,
                                            (quizVisible[0])
                                                ? Colors.grey
                                                : Colors.black),
                                        Expanded(
                                          flex: 8,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              quizCount("1", qnanumcolor[0]),
                                              quizCount("2", qnanumcolor[1]),
                                              quizCount("3", qnanumcolor[2]),
                                              quizCount("4", qnanumcolor[3]),
                                              quizCount("5", qnanumcolor[4])
                                            ],
                                          ),
                                        ),
                                        quizMoveButton(
                                            "right",
                                            Icons.arrow_right,
                                            (quizVisible[4])
                                                ? Colors.grey
                                                : Colors.black)
                                      ],
                                    ))),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget quizUI(int flex, dynamic alignment, String text, double fontsize,
      dynamic fontweight) {
    return Expanded(
        flex: flex,
        child: Container(
            alignment: alignment,
            child: Text(
              text, // Title
              style: TextStyle(fontSize: fontsize, fontWeight: fontweight),
            )));
  }

  Widget quizCount(String text, dynamic color) {
    return Expanded(
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: (quizVisible[int.parse(text) - 1])
                  ? FontWeight.bold
                  : FontWeight.normal)),
    );
  }

  Widget quizMoveButton(String direction, dynamic icon, dynamic color) {
    return Expanded(
      flex: 2,
      child: IconButton(
          onPressed: () {
            setState(() {
              if (direction == "left" && count != 0) {
                quizVisible[count] = false;
                count -= 1;
                quizVisible[count] = true;
                print(quizVisible);
              } else if (direction == "right" && count != 4) {
                quizVisible[count] = false;
                count += 1;
                quizVisible[count] = true;
                print(quizVisible);
              }
            });
          },
          icon: Icon(
            icon,
            size: 30,
            color: color,
          )),
    );
  }

  final quizColor = [Colors.redAccent, Colors.green];
  List<dynamic> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  int count = 0;
  Widget answerField(int index) {
    return Stack(
      children: [
        Visibility(
          visible: (qnaflag[index] == true) ? true : false,
          child: Container(
            width: layoutSize.size.width * 0.8,
            height: 50,
            child: Center(
              child: Text(
                (colorflag == 1) ? inputText[index] : quizAnswers[index],
                style: TextStyle(
                    fontSize: 18,
                    color: quizColor[colorflag[index]],
                    fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: quizColor[colorflag[index]],
              ),
            ),
          ),
        ),
        Visibility(
          visible: (qnaflag[index] == false) ? true : false,
          child: TextField(
            controller: _controllers[index],
            onChanged: (text) {
              inputText[index] = text;
            },
            decoration: InputDecoration(
              labelText: '정답',
              hintText: '정답을 입력해 주세요.',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    if (inputText[index] == quizAnswers[index]) {
                      print("정답!");
                      _postRequest('20');
                      colorflag[index] = 1;
                    } else {
                      print("오답!");
                      _postRequest('0');
                      colorflag[index] = 0;
                    }
                    qnanumcolor[index] = quizColor[colorflag[index]];
                    qnaflag[index] = true;
                  });
                },
                icon: Icon(
                  Icons.send_rounded,
                  color: Colors.grey,
                ),
              ),
              labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(width: 1, color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(width: 1, color: Colors.grey),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
      ],
    );
  }

  _postRequest(String point) async {
    Uri url = Uri.parse('http://20.249.210.78:8000/rank');

    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{'user': userName, 'point': point},
    );
  }

  List<Widget> _createChildren(
      List<String> summary, List<dynamic> keyword, List<dynamic> keyword_exp) {
    Crowling_Datas().callAPI();
    return List<Widget>.generate(summary.length, (int index) {
      var buf = summary[0];
      var key_buf = "";
      for (String s in summary) {
        for (String key in keyword) {
          if (s.contains(key)) {
            key_buf = key;
          }
        }
        if (key_buf != "") {
          summary.removeAt(0);
          return TextButton(
            onPressed: () {
              showSnackBar(
                  context, key_buf, keyword_exp[keyword.indexOf(key_buf)]);
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(50, 5),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft),
            child: Text("${buf.toString()} "),
          );
        } else {
          summary.removeAt(0);
          return Text("${buf.toString()} ");
        }
      }
      return Text("error");
    });
  }
}
