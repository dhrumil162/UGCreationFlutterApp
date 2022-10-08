// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ugbussinesscard/ui/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 4));
    const HomePage().launch(context, isNewTask: true);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        widthFactor: context.width(),
        child: Container(
          margin: EdgeInsets.only(top: const Size.fromHeight(20).height),
          width: context.width(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icon/icon.png",
                  width: const Size.fromWidth(400).width,
                  height: const Size.fromHeight(400).height,
                  fit: BoxFit.contain),
            ],
          )
              .paddingLeft(const Size.fromWidth(15).width)
              .paddingRight(const Size.fromWidth(15).width),
        ),
      ),
    );
  }
}
