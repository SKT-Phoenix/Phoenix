import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:phoenix/custom_utils.dart';

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
      body: Column(
        children: [NavBar(), Nav_Animation(), QuestContent()],
      ),
    );
  }

  final List<bool> isSelected = [true, false];
  Widget NavBar() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
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
        width: MediaQuery.of(context).size.width * 0.5,
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

  Widget QuestContent() {
    return Column(
      children: [],
    );
  }
}
