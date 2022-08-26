import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phoenix/custom_utils.dart';
import 'package:phoenix/menu/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../home/home.dart';
import 'quest.dart';

class Issue extends StatefulWidget {
  const Issue({Key? key}) : super(key: key);

  @override
  State<Issue> createState() => _IssueState();
}

class _IssueState extends State<Issue> {
  @override
  void dispose() {
    Crowling_Datas().callAPI();
    super.dispose();
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
                height: layoutSize.size.height * 0.15,
                child: Text(
                  "주요 뉴스를 알려드릴게요!",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                  child: Container(
                      width: layoutSize.size.width * 0.5,
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
              IssueContentRow(2, politices),
              IssueTitle("경제"),
              IssueContentRow(2, business),
              IssueTitle("사회"),
              IssueContentRow(2, social),
              IssueTitle("세계"),
              IssueContentRow(2, world),
              IssueTitle("IT/과학"),
              IssueContentRow(2, science),
              // TestData(split_summary, keywords),
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
          (context, index) => Visibility(
                visible: isSelected[0],
                child: Container(
                  height: layoutSize.size.height * 0.25,
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

  Widget IssueContentRow(int count, List<dynamic> data) {
    int SmaxLength = 0;
    for (var i = 0; i < count; i++) {
      (SmaxLength < data[i][1].length)
          ? SmaxLength = data[i][1].length
          : SmaxLength = SmaxLength;
    }
    print(SmaxLength);
    print(split_summary);
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
                                        alignment: Alignment.topRight),
                                  ),
                                ))
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          child: Wrap(
                            children:
                                _createChildren(split_summary[index], keywords),
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
    } else if (size < 200) {
      return 0.33;
    }
    return 1;
  }

  Widget TestData(List<String> summary, List<String> split_data) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Visibility(
                visible: isSelected[1],
                child: Container(
                  height: layoutSize.size.height * 0.5,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(top: 20),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: TextButton(
                        onPressed: () {},
                        child: Text("test"),
                      ),
                    ),
                  ),
                ),
              ),
          childCount: 1),
    );
  }

  List<Widget> _createChildren(List<String> summary, List<String> keyword) {
    var summarybuf = summary;
    return List<Widget>.generate(summarybuf.length, (int index) {
      var buf = summarybuf[0];
      print(summarybuf);
      for (var s in summarybuf) {
        if (keyword.contains(s)) {
          summarybuf.removeAt(0);
          return TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(50, 5),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft),
            child: Text("${buf.toString()} "),
          );
        } else {
          summarybuf.removeAt(0);
          return Text("${buf.toString()} ");
        }
      }
      return Text("error");
    });
  }
}
