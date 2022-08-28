import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phoenix/custom_utils.dart';
import 'package:phoenix/menu/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../crowling_datas.dart';
import '../home/home.dart';
import 'quest.dart';

class Issue extends StatefulWidget {
  const Issue({Key? key}) : super(key: key);

  @override
  State<Issue> createState() => _IssueState();
}

class _IssueState extends State<Issue> {
  var _controller = TextEditingController();
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
                            ? Image.asset("assets/final_phoenix.gif")
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
                IssueExpanded(),
                IssueContent(10, resultData),
                IssueTitle(quizNum[0]),
                QuizContent(5, resultData)
              ],
            ),
          ],
        ),
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

  Widget IssueExpanded() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Container(
                height: layoutSize.size.height * 0.3,
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
                    child: Column(
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
                                    child: Text("원문 보기"),
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
      return 0.2;
    } else if (size <= 75) {
      return 0.23;
    } else if (size <= 150) {
      return 0.26;
    } else if (size <= 200) {
      return 0.33;
    }
    return 0.6;
  }

  List<String> quizNum = ["Quiz 1", "Quiz 2", "Quiz 3", "Quiz 4", "Quiz 5"];
  List<String> quizProblem = [
    "김찬은 바보다?\n맞다,아니다로 정답을 기재해주세요.",
    "황현은 바보다?\n맞다,아니다로 정답을 기재해주세요.",
    "김예지는 바보다?\n맞다,아니다로 정답을 기재해주세요.",
    "이현우는 바보다?\n맞다,아니다로 정답을 기재해주세요.",
    "박영원은 바보다?\n맞다,아니다로 정답을 기재해주세요."
  ];
  List<String> quizAnswer = ["맞다", "아니다", "맞다", "아니다", "맞다"];
  List<bool> quizChecker = [false, false, false, false, false];
  List<bool> quizVisible = [true, false, false, false, false];
  Widget QuizContent(int count, List<dynamic> data) {
    int SmaxLength = 0;
    for (var i = 0; i < count; i++) {
      (SmaxLength < data[i][1].length)
          ? SmaxLength = data[i][1].length
          : SmaxLength = SmaxLength;
    }

    return SliverToBoxAdapter(
      child: Visibility(
        visible: isSelected[1],
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SizedBox(
            height: layoutSize.size.height * dynamic_BoxH(SmaxLength),
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
                            Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "경제", // Title
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ))),
                            Expanded(
                                flex: 4,
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "독점적 산업부문과 비독점적 산업부문 사이에 생산물의 가치실현력에 차이가 발생해 일정기간 양자의 생산물 가격지수에 격차가 생기는 현상은 무엇인가?", // Title
                                      style: TextStyle(fontSize: 16),
                                    ))),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.topRight,
                                    child: answerField())),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.arrow_left,
                                                size: 30,
                                                color: Colors.grey,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text("1",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Expanded(
                                                child: Text("2",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              Expanded(
                                                child: Text("3",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              Expanded(
                                                child: Text("4",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              Expanded(
                                                child: Text("5",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.arrow_right,
                                                size: 30,
                                              )),
                                        ),
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

  Widget answerField() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: '정답',
        hintText: '정답을 입력해 주세요.',
        suffixIcon: IconButton(
          onPressed: (() => AlertDialog(
              title: const Text('AlertDialog Title'),
              content: SingleChildScrollView(
                  child: ListBody(
                children: const <Widget>[
                  Text('This is a demo alert dialog.'),
                  Text('Would you like to approve of this message?'),
                ],
              ))))

          // print(_controller.toString());
          ,
          icon: Icon(
            Icons.send_rounded,
            color: Colors.green,
          ),
        ),
        labelStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Colors.green),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Colors.green),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
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
