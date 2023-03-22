// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:chat_app/Signin_Screen.dart';
import 'package:chat_app/home_screen.dart';
import 'package:chat_app/static_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var width, height;
  void checkprefrence() async {
    SharedPreferences sharedprefrence = await SharedPreferences.getInstance();
    String? value = sharedprefrence.getString('UserID');

    if (value != null) {
      Staticdata.id = value;
      Timer(
          const Duration(seconds: 2),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home())));
    } else {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Signin())));
    }
  }

  @override
  void initState() {
    super.initState();
    checkprefrence();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return const Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
          child: Text(
        'We Chat',
        style: TextStyle(
            color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500),
      )),
    );
  }
}
