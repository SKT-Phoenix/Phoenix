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
List<List<String>> politices = [[], [], []];
// 경제
List<List<String>> business = [[], [], []];
// 사회
List<List<String>> social = [[], [], []];
// 세계
List<List<String>> world = [[], [], []];
// IT/과학
List<List<String>> science = [[], [], []];

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
    List<String> need_columns = ["타이틀", "링크", "요약문"];

    for (int x = 0; x < crowlingdata.length; x++) {
      for (var y in columns) {
        print(crowlingdata[x][y]);
      }
    }
  }
}
