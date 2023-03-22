// ignore: file_names
// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app/home_screen.dart';
import 'package:chat_app/round_button.dart';
import 'package:chat_app/signup_screen.dart';
import 'package:chat_app/static_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _obscureText = true;
  var width, height;
  late String errorMessage;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  final submited = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signIn() async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (credential.user != null) {
        Staticdata.id = credential.user!.uid;
        print('${credential.user!.uid}');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
        Flushbar(
          maxWidth: width * 0.9,
          backgroundColor: Colors.black,
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(3),
          message: 'Login Succesfull',
          icon: const Icon(
            Icons.check_circle_outline,
            size: 28.0,
            color: Colors.black54,
          ),
          duration: const Duration(seconds: 2),
          leftBarIndicatorColor: Colors.grey,
        ).show(context);
        postdatatoSP();
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "invalid-email";
          break;
        case "wrong-password":
          errorMessage = "wrong-password";
          break;
        case "user-not-found":
          errorMessage = "user-not-found";
          break;
        case "user-disabled":
          errorMessage = "user-disabled";
          break;
        case "too-many-requests":
          errorMessage = "too-many-requests";
          break;
        case "operation-not-allowed":
          errorMessage = "operation-not-alloweda";
          break;
        default:
          errorMessage = "An error occured";
      }
      Flushbar(
        maxWidth: width * 0.9,
        backgroundColor: Colors.black,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(3),
        message: errorMessage,
        icon: const Icon(
          Icons.check_circle_outline,
          size: 28.0,
          color: Colors.black54,
        ),
        duration: const Duration(seconds: 2),
        leftBarIndicatorColor: Colors.grey,
      ).show(context);
    }
  }

  Future postdatatoSP() async {
    SharedPreferences sharedprefrence = await SharedPreferences.getInstance();
    sharedprefrence.setString('UserID', Staticdata.id
        // key     value
        );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 201, 197, 228),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'Login',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: emailController,
                  autofocus: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // autovalidateMode: submited
                  //     ? AutovalidateMode.onUserInteraction
                  //     : AutovalidateMode.disabled,
                  decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      filled: true,
                      // fillColor: Colors.pink,
                      suffixIcon: const Icon(Icons.email),
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: 'Enter Your Email',
                      labelText: 'Email',
                      focusColor: Colors.green,
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        // color: Colors.green,
                        fontWeight: FontWeight.w400,
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Your Email";
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return "Invalid Format";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  autovalidateMode: submited
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  autofocus: true,
                  maxLength: 10,

                  decoration: InputDecoration(
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      // suffixIcon: const Icon(Icons.lock_open),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      hintText: 'Enter Your Password',
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Your Password";
                    } else if (value.length < 8) {
                      return 'Write Minimum 8 Character password';
                    }
                    return null;
                  },
                ),
              ),
              RoundButton(
                  title: 'Login',
                  onTap: () {
                    // if (_formkey.currentState!.validate()) {
                    //   auth.signInWithEmailAndPassword(
                    //       email: emailController.text,
                    //       password: passwordController.text);
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const Home()));
                    // }
                    signIn();
                  }),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Dont't Have Account?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ],
              )
            ],
          ),
        ));
  }
}
