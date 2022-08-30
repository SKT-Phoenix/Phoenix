import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:phoenix/baner.dart';
import 'package:phoenix/home/home.dart';

import '../crowling_datas.dart';
import '../custom_utils.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white, //appbar 투명색
        centerTitle: true,
        elevation: 3.0, // 그림자 농도 0
        leading: IconButton(
          icon: Image.asset("assets/a_dot_menu.png"),
          onPressed: () {
            Get.offAndToNamed("menu");
          },
        ),
        title: Text(
          "랭킹",
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
        children: [
          Stack(
            children: [
              Row(
                children: [
                  ranker(rankusers[1], rankpoints[1]),
                  ranker(rankusers[0], rankpoints[0]),
                  ranker(rankusers[2], rankpoints[2]),
                ],
              ),
              Center(
                child: Container(
                  width: layoutSize.size.width * 0.8,
                  height: layoutSize.size.height * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: ListTile(
                      //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                      leading: Image.asset(ranking_profile(rankusers[0])),
                      title: Text(
                        '현재 1등은 \n${rankusers[0]}님!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Image.asset(
                        'assets/first_prize.png',
                        width: 50,
                      )),
                ),
              )
            ],
          ),
          Container(
            height: layoutSize.size.height * 0.35,
            child: ListView.builder(
              itemCount: rankusers.length,
              itemBuilder: (context, index) {
                if (index < 3) {
                  return Container();
                }
                return Column(
                  children: [
                    Container(
                      width: layoutSize.size.width * 0.9,
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    ListTile(
                      //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                      leading: Image.asset(ranking_profile(rankusers[index])),
                      title: Text(
                        rankusers[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (index < 3)
                                ? leaderColor[index]
                                : Colors.black54),
                      ),
                      subtitle: Text(
                        "${rankpoints[index]}점",
                        style: TextStyle(
                            color: (index < 3)
                                ? leaderColor[index]
                                : Colors.black54),
                      ),
                      trailing: (index == 0)
                          ? Image.asset(
                              'assets/first_prize.png',
                              width: 50,
                            )
                          : Container(
                              width: 50,
                              child: Text(
                                '${index + 1}등',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ranker(String rankuser, int rankpoint) {
    int ranking = rankings[rankusers.indexOf(rankuser)];
    String image_path = rankingimage(rankuser);
    double rankheight = rankingpoint(ranking);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: layoutSize.size.width * 0.33,
      height: layoutSize.size.height * 0.5,
      child: Column(
        children: [
          Expanded(child: Container()),
          Container(
            child: Image.asset(image_path),
          ),
          leaderbar(ranking, rankuser, rankheight),
        ],
      ),
    );
  }

  Widget ranking_profiles() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: SizedBox(
          width: layoutSize.size.width,
          height: layoutSize.size.height,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                child: Text(index.toString()),
              );
            },
          ),
        ),
      ),
    );
  }

  String rankingimage(String rankuser) {
    if (rankuser == "김찬") {
      return "assets/adot/kc_adot.gif";
    } else if (rankuser == "황현") {
      return "assets/adot/hh_adot.gif";
    } else if (rankuser == "김예지") {
      return "assets/adot/yj_adot.gif";
    } else if (rankuser == "박영원" || "rankuser" == "박원영") {
      return "assets/adot/yo_adot.gif";
    } else if (rankuser == "서진경") {
      return "assets/adot/jk_adot.gif";
    } else if (rankuser == "이현우") {
      return "assets/adot/hu_adot.gif";
    } else {
      return "assets/adot/default_adot.gif";
    }
  }

  String ranking_profile(String rankuser) {
    if (rankuser == "김찬") {
      return "assets/adot_profile/kc_profile.png";
    } else if (rankuser == "황현") {
      return "assets/adot_profile/hh_profile.png";
    } else if (rankuser == "김예지") {
      return "assets/adot_profile/yj_profile.png";
    } else if (rankuser == "박영원" || "rankuser" == "박원영") {
      return "assets/adot_profile/yo_profile.png";
    } else if (rankuser == "서진경") {
      return "assets/adot_profile/jk_profile.png";
    } else if (rankuser == "이현우") {
      return "assets/adot_profile/hu_profile.png";
    } else {
      return "assets/adot_profile/default_profile.png";
    }
  }

  double rankingpoint(int ranking) {
    if (ranking == 2) {
      return layoutSize.size.height * 0.23;
    } else if (ranking == 1) {
      return layoutSize.size.height * 0.3;
    } else if (ranking == 3) {
      return layoutSize.size.height * 0.17;
    } else {
      return 50;
    }
  }

  Widget rankingMedal(int ranking) {
    if (ranking == 2) {
      return Container(
          width: layoutSize.size.width * 0.1,
          child: Image.asset("assets/2_medal.png"));
    } else if (ranking == 1) {
      return Container(
          width: layoutSize.size.width * 0.1,
          child: Image.asset("assets/1_medal.png"));
    } else if (ranking == 3) {
      return Container(
          width: layoutSize.size.width * 0.1,
          child: Image.asset("assets/3_medal.png"));
    } else {
      return Container(
          width: layoutSize.size.width * 0.1,
          child: Image.asset("assets/1_medal.png"));
    }
  }

  final leaderColor = [
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.amberAccent,
  ];
  Widget leaderbar(int ranking, String rankuser, double rankheight) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          width: layoutSize.size.width * 0.3,
          height: rankheight,
          decoration: BoxDecoration(
            color: leaderColor[rankusers.indexOf(rankuser)],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color:
                      leaderColor[rankusers.indexOf(rankuser)].withOpacity(0.5),
                  offset: Offset(15, -15),
                  blurRadius: 3,
                  spreadRadius: -5)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              rankingMedal(ranking),
              Expanded(
                child: Container(),
              ),
              Expanded(
                child: Text(
                  rankuser,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
              Text(
                "${rankpoints[ranking - 1].toString()}점",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10))
            ],
          ),
        ),
      ),
    );
  }
}
