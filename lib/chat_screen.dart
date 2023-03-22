// ignore_for_file: prefer_typing_uninitialized_variables, override_on_non_overriding_member, non_constant_identifier_names, annotate_overrides, prefer_const_constructors

import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app/home_screen.dart';
import 'package:chat_app/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  String? chatid;
  String? name;
  Message({super.key, this.chatid, this.name});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  var width, height;
  String name = '';
  TextEditingController messageController = TextEditingController();
  onsendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendBy": Staticdata.loginuser!.name,
        "message": messageController.text,
        "time": FieldValue.serverTimestamp()
      };
      await FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatid)
          .collection("chat")
          .add(messages);
      messageController.clear();
    } else {
      Flushbar(
        maxWidth: width * 0.9,
        backgroundColor: const Color.fromRGBO(2, 110, 150, 0.8),
        flushbarPosition: FlushbarPosition.BOTTOM,
        margin: const EdgeInsets.all(3),
        message: 'Please Input Some Text',
        icon: const Icon(
          Icons.check_circle_outline,
          size: 28.0,
          color: Colors.black,
        ),
        duration: const Duration(seconds: 2),
        leftBarIndicatorColor: Colors.grey,
      ).show(context);
    }
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   print("chatid ${widget.chatid}");
  //   super.initState();
  // }

  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            height: height,
            width: width * 0.93,
            color: Colors.white,
            child: Column(children: [
              SizedBox(
                height: height * 0.08,
                width: width,
                // color: Colors.amber,
                // ignore: prefer_const_literals_to_create_immutables
                child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          },
                          child: Icon(Icons.arrow_back_ios)),
                      SizedBox(
                        width: width * 0.25,
                      ),
                      Text(
                        "${widget.name}".toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      )
                    ]),
              ),
              Divider(
                thickness: 2,
                color: Color.fromRGBO(203, 197, 201, 1),
              ),
              Expanded(
                child: SizedBox(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatroom')
                        .doc(widget.chatid)
                        .collection('chat')
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            return messages(MediaQuery.of(context).size, data);
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.85,
                    height: height * 0.05,
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(2, 110, 150, 0.8),
                              width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(2, 110, 150, 0.8),
                              width: 2),
                        ),
                        hintText: 'Type here',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromARGB(204, 241, 238, 240),
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onsendMessage();
                    },
                    child: Icon(
                      Icons.send,
                      size: width * 0.08,
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> data) {
    return Container(
      width: size.width,
      alignment: data['sendBy'] != widget.name
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: data['sendBy'] != widget.name
              ? Color.fromARGB(255, 88, 15, 212)
              : Color.fromARGB(255, 21, 184, 175),
        ),
        child: Text(
          data['message'],
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color:
                  data['sendBy'] != widget.name ? Colors.white : Colors.white),
        ),
      ),
    );
  }
}
