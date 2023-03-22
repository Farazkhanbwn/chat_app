import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  String? chatid;
  String? name;
  MessageScreen({super.key, this.chatid, this.name});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var width, height;
  String name = '';
  TextEditingController messageController = TextEditingController();
  onsendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendBy": Staticdata.loginuser?.name,
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

  @override
  void initState() {
    // TODO: implement initState
    print("chatid ${widget.chatid}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
        actions: const [Icon(Icons.handyman)],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: height,
            width: width * 0.93,
            color: Colors.white,
            child: Column(children: [
              Container(
                height: height * 0.08,
                width: width,
                // color: Colors.amber,
                // ignore: prefer_const_literals_to_create_immutables
                child: Row(children: [
                  Icon(Icons.arrow_back_ios),
                  Text(
                    "${widget.name}",
                    style: TextStyle(fontSize: 15),
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
          color: data['sendBy'] != widget.name ? Colors.blue : Colors.red[100],
        ),
        child: Text(
          data['message'],
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color:
                  data['sendBy'] != widget.name ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
