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
List<dynamic> keywords = [];
List<dynamic> keywords_exp = [];
List<List<String>> split_summary = [];
List<dynamic> resultData = [];

List<dynamic> quizData = [];
List<dynamic> quizLists = [];
List<dynamic> quizAnswers = [];
List<dynamic> quizQuestions = [];

List<dynamic> rankData = [];
List<dynamic> rankings = [];
List<dynamic> rankusers = [];
List<dynamic> rankpoints = [];

class Crowling_Datas {
  void callAPI() async {
    var url = Uri.parse(
      'http://20.249.210.78:8000/',
    );
    var response = await http.get(url);

    print('Response status: ${response.statusCode}');
    final decodeData = utf8.decode(response.bodyBytes); // UTF8 변환
    crowlingdata = json.decode(decodeData);
    // List<String> columns = ["발행일자", "분야", "타이틀", "링크", "요약문"]; // +"본문"
    List<String> need_columns = ["타이틀", "요약문", "링크", "주요단어", "단어설명"];
    split_summary = [];
    keywords = [];
    keywords_exp = [];

    for (int x = 0; x < crowlingdata.length; x++) {
      var buffer = [];
      for (var y in need_columns) {
        if (y == "요약문") {
          split_summary.add(crowlingdata[x][y].split(' '));
        }
        if (y == '주요단어') {
          var split_buf = crowlingdata[x][y].split('§');
          if (split_buf[0] != "") {
            for (var sb in split_buf) {
              keywords.add(sb);
            }
          }
        }
        if (y == '단어설명') {
          var split_buf = crowlingdata[x][y].split('§');
          if (split_buf[0] != "") {
            for (var sb in split_buf) {
              keywords_exp.add(sb);
            }
          }
        }
        buffer.add(crowlingdata[x][y]);
      }
      resultData.add(buffer);
    }
  }

  void callQuizAPI() async {
    var url = Uri.parse(
      'http://20.249.210.78:8000/qna',
    );
    var response = await http.get(url);

    print('Response status: ${response.statusCode}');
    final decodeData = utf8.decode(response.bodyBytes); // UTF8 변환
    quizData = json.decode(decodeData);
    List<String> columns = ["발행일자", "분야", "정답", "질문", "타이틀"];
    quizLists = [];
    quizAnswers = [];
    quizQuestions = [];
    for (int x = 0; x < quizData.length; x++) {
      for (var y in columns) {
        if (y == "분야") {
          quizLists.add(quizData[x][y]);
        } else if (y == "정답") {
          quizAnswers.add(quizData[x][y]);
        } else if (y == "질문") {
          quizQuestions.add(quizData[x][y]);
        }
      }
    }
  }

  void callRankAPI() async {
    var url = Uri.parse(
      'http://20.249.210.78:8000/rank',
    );
    var response = await http.get(url);

    print('Response status: ${response.statusCode}');
    final decodeData = utf8.decode(response.bodyBytes); // UTF8 변환
    rankData = json.decode(decodeData);
    rankings = [];
    rankusers = [];
    rankpoints = [];
    List<String> columns = ["ranking", "유저", "포인트"];
    for (int x = 0; x < rankData.length; x++) {
      for (var y in columns) {
        if (y == "ranking") {
          rankings.add(rankData[x][y]);
        } else if (y == "유저") {
          rankusers.add(rankData[x][y]);
        } else if (y == "포인트") {
          rankpoints.add(rankData[x][y]);
        }
      }
    }
  }
}
