import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:phoenix/custom_utils.dart';

class Issue extends StatefulWidget {
  const Issue({Key? key}) : super(key: key);

  @override
  State<Issue> createState() => _IssueState();
}

class _IssueState extends State<Issue> {
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
              IssueTitle("정치"),
              IssueSubContent(subcontents.length),
              IssueTitle("경제"),
              IssueSubContent(subcontents.length),
              IssueTitle("사회"),
              IssueSubContent(subcontents.length),
              IssueTitle("세계"),
              IssueSubContent(subcontents.length),
              IssueTitle("IT/과학"),
              IssueSubContent(subcontents.length),
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
          (context, index) => Container(
                height: MediaQuery.of(context).size.height * 0.4,
              ),
          childCount: 1),
    );
  }

  Widget IssueTitle(String string) {
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
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          childCount: 1),
    );
  }

  final List<String> subcontents = [
    "[동영상] '드라마 볼래'로 볼만한 드라마 찾기",
    "[음악] '인기 음악 틀어줘'로 핫한 음악 틀어보기"
  ];
  final List<String> pointsubcontents = ["50", "75"];
  Widget IssueSubContent(int count) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => ListTile(
                title: Container(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(220, 245, 245, 250),
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
          childCount: count),
    );
  }
}
