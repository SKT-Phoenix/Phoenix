import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:phoenix/custom_utils.dart';

var layoutSize;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int flag = 0;

  @override
  void initState() {
    Crowling_Datas().callAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    layoutSize = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent, //appbar 투명색
        centerTitle: true,
        elevation: 0.0, // 그림자 농도 0
        leading: IconButton(
          icon: Image.asset("assets/a_dot_menu.png"),
          onPressed: () {
            print("메뉴진입");
            Get.toNamed("/menu");
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset("assets/a_dot_share.png"),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset("assets/a_dot_notification.png"),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainText("A.모르는 사람 없게 해주세요~\n 닷생살자 이벤트 🎁"),
            Adot("assets/a_dot_gif.gif"),
            SubMenu()
          ],
        ),
      ),
    );
  }

  Widget MainText(String text) {
    return Center(
        child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    ));
  }

  Widget Adot(String image_path) {
    return Center(
      child: Container(
        height: layoutSize.size.height * 0.5,
        child: Center(
          child: Image(
            image: AssetImage(image_path),
          ),
        ),
      ),
    );
  }

  Widget SubMenu() {
    return Center(
        child: Column(
      children: [SubMenuItem(), Mic_Key_Button()],
    ));
  }

  Widget SubMenuItem() {
    final List<String> text = ["지금 이벤트 참여하기", "이따 이벤트 참여하기", "내일 이벤트 참여하기"];
    final List<IconData> imogi = [
      Icons.card_giftcard_outlined,
      Icons.card_giftcard_outlined,
      Icons.card_giftcard_outlined
    ];
    return Container(
      height: layoutSize.size.height * 0.09,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imogi.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(left: 15, top: 18, bottom: 7),
              child: OutlinedButton.icon(
                style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(20, 0, 0, 0)),
                    foregroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 11, 13, 35)),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 245, 246, 250)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    )),
                onPressed: () {},
                label: Text(
                  text[i],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                icon: Icon(imogi[i]),
              ),
            );
          }),
    );
  }

  List<bool> _selections = [false, false];
  List<Icon> mic_key_Icon = [
    Icon(
      Icons.mic_outlined,
      color: Colors.white,
    ),
    Icon(
      Icons.keyboard_outlined,
      color: Colors.white,
    )
  ];
  List<Alignment> container_align = [
    Alignment.centerLeft,
    Alignment.centerRight
  ];
  List<double> container_size = [40, 70];

  Widget Mic_Key_Button() {
    return Container(
      // color: Color.fromARGB(255, 250, 250, 250),
      height: layoutSize.size.height * 0.09,
      child: Row(
        children: [
          Expanded(child: Container()),
          Container(
            child: Stack(
              children: [
                mic_key_btn_bg(container_size[0], container_size[1]),
                mic_key_btn(container_align[flag], mic_key_Icon[flag]),
              ],
            ),
          ),
          Expanded(
            child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 100.0,
                          spreadRadius: -20.0)
                    ]),
                child: IconButton(
                    iconSize: 50,
                    onPressed: () {},
                    icon: Image.asset("assets/a_dot_refresh.png"))),
          ),
        ],
      ),
    );
  }

  Widget mic_key_btn_bg(double mic_size, double keyboard_size) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(50), boxShadow: [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 100.0,
              spreadRadius: -20.0)
        ]),
        child: ToggleButtons(
          borderRadius: BorderRadius.circular(50),
          borderColor: Colors.white,
          children: <Widget>[
            Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Icon(
                  Icons.mic_outlined,
                  size: 30,
                  color: Custom_Utils().Colors_SKT_Blue(),
                ),
              ),
              width: mic_size,
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.keyboard_outlined,
                    size: 30, color: Custom_Utils().Colors_SKT_Blue()),
              ),
              width: keyboard_size,
            ),
          ],
          onPressed: (int index) {
            setState(() {
              double buffer = container_size[0];
              container_size[0] = container_size[1];
              container_size[1] = buffer;
              print(index);
              if (index == 0) {
                flag = 0;
              } else {
                flag = 1;
              }
              // _selections[index] = !_selections[index];
            });
          },
          isSelected: _selections,
        ),
      ),
    );
  }

  Widget mic_key_btn(Alignment align, Icon icon) {
    return Center(
      child: Container(
        alignment: align,
        width: 120,
        height: 60,
        child: Container(
            alignment: Alignment.center,
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Custom_Utils().Colors_SKT_Blue(),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 6.0)
                ]),
            child: IconButton(
              onPressed: () {},
              icon: icon,
              iconSize: 30,
            )),
      ),
    );
  }
}
