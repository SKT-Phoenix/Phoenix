import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'menu/quest.dart';

List<dynamic> crowlingdata = [];
List<String> keywords = ["법무부가", "시민단체", "정치적", "정보공개"];
List<List<String>> split_summary = [];
List<dynamic> resultData = [];

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
    split_summary = [];

    for (int x = 0; x < crowlingdata.length; x++) {
      var buffer = [];
      for (var y in need_columns) {
        if (y == "요약문") {
          split_summary.add(crowlingdata[x][y].split(' '));
        }
        buffer.add(crowlingdata[x][y]);
        // print(crowlingdata[x][y]);
      }
      resultData.add(buffer);
    }
    // print(split_summary);
  }
}
