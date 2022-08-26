import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<dynamic> crowlingdata = [];

// 정치
List<dynamic> politices = [];
// 경제
List<dynamic> business = [];
// 사회
List<dynamic> social = [];
// 세계
List<dynamic> world = [];
// IT/과학
List<dynamic> science = [];

class Custom_Utils {
  Color Colors_SKT_Blue() {
    return Color.fromARGB(255, 11, 13, 235);
  }

  Color Colors_SKT_Background() {
    return Color.fromARGB(255, 244, 245, 249);
  }

  List<String> dummydata = ["아침", "점심", "저녁", "새벽", "밥", "날씨"];
}

class Crowling_Datas {
  void callAPI() async {
    var url = Uri.parse(
      'http://20.249.210.78:8000/',
    );
    var response = await http.get(url);

    print('Response status: ${response.statusCode}');
    crowlingdata = json.decode(response.body);

    List<String> columns = ["발행일자", "분야", "타이틀", "링크", "요약문"]; // +"본문"
    List<String> need_columns = ["타이틀", "요약문", "링크"];

    for (int x = 0; x < crowlingdata.length; x++) {
      var buffer = [];
      for (var y in need_columns) {
        buffer.add(crowlingdata[x][y]);
        print(crowlingdata[x][y]);
      }
      if (x == 0 || x == 1) {
        politices.add(buffer);
      } else if (x == 2 || x == 3) {
        business.add(buffer);
      } else if (x == 4 || x == 5) {
        social.add(buffer);
      } else if (x == 6 || x == 7) {
        world.add(buffer);
      } else {
        science.add(buffer);
      }
    }
    var datas =
        "법무부가 지난 6월 한동훈 장관의 미국 출장경비 내용을 밝히라는 시민단체 대표의 정보공개 요청을 거부한 것에 대해 시민단체 대표는 법적 대응을 예고하고 있지만, 이전 정부에서도 관련 사항에 대해 정보공개를 한 적이 없음에도 마구잡이식으로 공개하라는 요구는 어떠한 정치적 의도가 담긴 게 아니냐는 비판이 나오고 있다.";
    print(datas.length);
  }
}
