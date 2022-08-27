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
    return 1;
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
                                    // child: _buildTextComposer())),
                                    child: Text("test"))),
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

  Widget testetse() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        labelStyle: TextStyle(color: Colors.redAccent),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Colors.redAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Colors.redAccent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

// Widget _buildTextComposer() {
//     return IconTheme(
//       data: IconThemeData(color: Theme.of(context).accentColor),
//       child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Row(
//             children: <Widget>[
//               Flexible(
//                 child: TextField(
//                   controller: _textController,
//                   onSubmitted: _handleSubmitted,
//                   decoration: new InputDecoration.collapsed(
//                       hintText: "Send a message"),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: () => _handleSubmitted(_textController.text)),
//               ),
//             ],
//           )
//       ),
//     );
//   }
//
  List<Widget> _createChildren(
      List<String> summary, List<dynamic> keyword, List<dynamic> keyword_exp) {
    Crowling_Datas().callAPI();
    // print(summary);
    // print(keyword);
    // print(keyword_exp);
    return List<Widget>.generate(summary.length, (int index) {
      var buf = summary[0];
      for (var s in summary) {
        if (keyword.contains(s)) {
          // 여기서 특정 단어들을 어떻게 매칭시킬건지(~가, ~로)
          summary.removeAt(0);
          return TextButton(
            onPressed: () {
              showSnackBar(context, buf.toString(),
                  keyword_exp[keyword.indexOf(buf.toString())]);
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
