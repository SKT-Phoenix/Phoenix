import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent, //appbar 투명색
        centerTitle: true,
        elevation: 0.0, // 그림자 농도 0
        leading: IconButton(
          icon: Icon(Icons.bluetooth),
          onPressed: () {
            // print("메뉴진입");
            // Get.toNamed("/menu");
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu_sharp),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
