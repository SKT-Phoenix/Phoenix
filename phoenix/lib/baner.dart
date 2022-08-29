import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

var userName = "";

class Baner extends StatefulWidget {
  const Baner({Key? key}) : super(key: key);

  @override
  State<Baner> createState() => _BanerState();
}

class _BanerState extends State<Baner> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      userAccount(context);
    });
    // Getbaner().onReady();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Image.asset('assets/baner.png')),
    );
  }

  TextEditingController _controller = TextEditingController();
  Future<dynamic> userAccount(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          '당신의 이름은?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _controller,
          onChanged: (text) {
            userName = text;
          },
          decoration: InputDecoration(
            labelText: '이름',
            hintText: '이름을 입력 해 주세요.',
            suffixIcon: IconButton(
              onPressed: () {
                Get.offAllNamed('/home');
              },
              icon: Icon(
                Icons.send_rounded,
                color: Colors.black,
              ),
            ),
            labelStyle: TextStyle(color: Colors.black),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ),
    );
  }
}
