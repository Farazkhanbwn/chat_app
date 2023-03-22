// ignore_for_file: use_build_context_synchronously
import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app/Signin_Screen.dart';
import 'package:chat_app/round_button.dart';
import 'package:chat_app/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obsecureText = false;
  var width, height;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  late String errorMessage;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future signUp() async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
    try {
      if (credential.user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Signin(),
            ));
        Flushbar(
          maxWidth: width * 0.9,
          backgroundColor: Colors.black,
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(3),
          message: 'SignUp Successfully',
          icon: const Icon(
            Icons.check_circle_outline,
            size: 28.0,
            color: Colors.black54,
          ),
          duration: Duration(seconds: 2),
          leftBarIndicatorColor: Colors.grey,
        ).show(context);

        postDataToFB();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "invalid-email";
          break;
        case "wrong-password":
          errorMessage = "weak-password";
          break;
        case "email-already-in-use":
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

  FirebaseFirestore instance = FirebaseFirestore.instance;
  postDataToFB() async {
    User? user = auth.currentUser;
    var id = user!.uid;
    UserModel model = UserModel(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        uid: id);
    await instance.collection('users').doc(id).set(model.toMap());
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Form(
      key: _formkey,
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 208, 204, 230),
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: const Text(
              'Signup',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  controller: nameController,
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
                      suffixIcon: const Icon(Icons.person),
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: 'Enter Your Name',
                      labelText: 'Name',
                      focusColor: Colors.green,
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        // color: Colors.green,
                        fontWeight: FontWeight.w400,
                      )),
                  validator: (username) {
                    if (username!.isEmpty) {
                      return 'Enter a Name';
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff1a2a3a), width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      // disabledBorder: OutlineInputBorder(
                      //   borderSide:
                      //       const BorderSide(color: Colors.blue, width: 2.0),
                      //   borderRadius: BorderRadius.circular(30.0),
                      // ),
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
                  obscureText: _obsecureText,
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                        child: Icon(_obsecureText
                            ? Icons.visibility
                            : Icons.visibility_off),
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
                  title: 'SignUp',
                  onTap: () {
                    signUp();
                    // if (_formkey.currentState!.validate()) {
                    //   auth.createUserWithEmailAndPassword(
                    //       email: emailController.text,
                    //       password: passwordController.text);
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const Signin()));
                    //   postDataToFB();
                    // }
                  }),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already Have Account?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signin()));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          )),
    );
  }
}
