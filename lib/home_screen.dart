import 'package:chat_app/Signin_Screen.dart';
import 'package:chat_app/accept_friend.dart';
import 'package:chat_app/add_user.dart';
import 'package:chat_app/static_data.dart';
import 'package:chat_app/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var width, height;
  TextEditingController searchController = TextEditingController();
  String name = '';
  String? chatid;
  FirebaseFirestore instance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  void logout() async {
    await auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Signin(),
        ));
    clearprefrence();
  }

  void clearprefrence() async {
    SharedPreferences sharedprefrence = await SharedPreferences.getInstance();
    sharedprefrence.getKeys();
    sharedprefrence.clear();
  }

  getusermodel() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(Staticdata.id)
        .get()
        .then((value) {
      setState(() {
        Staticdata.loginuser = UserModel.fromMap(value.data()!);
        print("login user model ${Staticdata.loginuser.toString()}");
      });
    });
  }

  void deleteFriend(String frienlistID, String senderID) async {
    await FirebaseFirestore.instance
        .collection("friendlist")
        .doc(Staticdata.loginuser!.uid)
        .collection("friends")
        .doc(frienlistID)
        .delete();
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getusermodel();
    super.initState();
  }

  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('We Chat'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: width,
        height: height,
        color: Color.fromARGB(255, 187, 182, 221),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: instance
                    .collection('friendlist')
                    .doc(Staticdata.id)
                    .collection('friends')
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? SizedBox(
                          width: width * 0.9,
                          height: height * 0.9,
                          // color: Colors.brown,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.05,
                                width: width * 0.9,
                              ),
                              SizedBox(
                                height: height * 0.1,
                                width: width * 0.9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: width * 0.12,
                                      height: height * 0.05,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 126, 86, 196),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AcceptFriend(),
                                                ));
                                          },
                                          // child: Icon(Icons.add)),
                                          child: Text(
                                            'View',
                                            style: TextStyle(
                                                fontSize: width * 0.035,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white70),
                                          )),
                                    ),
                                    SizedBox(
                                      height: height * 0.05,
                                      width: width * 0.6,
                                      // color: Colors.red,
                                      child: TextFormField(
                                        controller: searchController,
                                        // maxLength: 10,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                logout();
                                              },
                                              icon: const Icon(
                                                  Icons.logout_outlined)),
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: const Color.fromARGB(
                                              255, 248, 248, 253),
                                          hintText: 'search',
                                          // labelText: 'Enter Email',
                                          hintStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w400,
                                              fontSize: width * 0.04,
                                              color: const Color.fromRGBO(
                                                  34,
                                                  34,
                                                  34,
                                                  0.5)), /*labelText: 'Enter your email'*/
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            name = value;
                                            // ignore: avoid_print
                                            print(name);
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.12,
                                      height: height * 0.05,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.deepPurple),
                                      child: InkWell(
                                        onTap: (() {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddUser()));
                                        }),
                                        child: SizedBox(
                                          height: height * 0.1,
                                          child: const Icon(
                                            Icons.person_add,
                                            size: 30,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Expanded(
                              //   // ignore: sized_box_for_whitespace
                              //   child: Container(
                              //     width: width * 0.9,
                              //     height: height * 0.9,
                              //     child: ListView.builder(
                              //         itemCount: snapshot.data?.docs.length,
                              //         // ignore: missing_return
                              //         itemBuilder: (context, index) {
                              //           // 1
                              //           // if (name.isEmpty) {
                              //           return snapshot.data?.docs[index]
                              //                       .get('senderid') ==
                              //                   Staticdata.loginuser!.uid
                              //               ? Card(
                              //                   elevation: 5,
                              //                   child: Container(
                              //                     width: width,
                              //                     height: height * 0.08,
                              //                     color: const Color.fromARGB(
                              //                         255, 241, 238, 236),
                              //                     child: Row(
                              //                       mainAxisAlignment:
                              //                           MainAxisAlignment
                              //                               .spaceEvenly,
                              //                       children: [
                              //                         const Icon(
                              //                           Icons.person,
                              //                           size: 40,
                              //                           color: Color.fromRGBO(
                              //                               234, 105, 30, 0.84),
                              //                         ),
                              //                         Container(
                              //                           width: width * 0.3,
                              //                           // color: Colors.amber,
                              //                           child: Text(
                              //                             '${snapshot.data?.docs[index].get('isclickname')}',
                              //                             style:
                              //                                 const TextStyle(
                              //                                     fontSize: 20),
                              //                           ),
                              //                         ),
                              //                         SizedBox(
                              //                             width: width * 0.3),
                              //                         const Icon(
                              //                           Icons.person_add,
                              //                           size: 30,
                              //                           color: Color.fromARGB(
                              //                               255, 0, 117, 185),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 )
                              //               : Card(
                              //                   elevation: 5,
                              //                   child: Container(
                              //                     width: width,
                              //                     height: height * 0.08,
                              //                     color: const Color.fromARGB(
                              //                         255, 241, 238, 236),
                              //                     child: Row(
                              //                       mainAxisAlignment:
                              //                           MainAxisAlignment
                              //                               .spaceEvenly,
                              //                       children: [
                              //                         const Icon(
                              //                           Icons.person,
                              //                           size: 40,
                              //                           color: Color.fromRGBO(
                              //                               234, 105, 30, 0.84),
                              //                         ),
                              //                         Container(
                              //                           width: width * 0.3,
                              //                           // color: Colors.amber,
                              //                           child: Text(
                              //                             '${snapshot.data?.docs[index].get('sendername')}',
                              //                             style:
                              //                                 const TextStyle(
                              //                                     fontSize: 20),
                              //                           ),
                              //                         ),
                              //                         SizedBox(
                              //                             width: width * 0.3),
                              //                         const Icon(
                              //                           Icons.person_add,
                              //                           size: 30,
                              //                           color: Color.fromARGB(
                              //                               255, 0, 117, 185),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 );
                              //         }),
                              //   ),
                              // ),
                              Expanded(
                                child: SizedBox(
                                  width: width * 0.9,
                                  height: height * 0.9,
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      // ignore: missing_return
                                      itemBuilder: (context, index) {
                                        // 1
                                        if (name.isEmpty) {
                                          return snapshot.data?.docs.length == 0
                                              ? const Text("No Friend Found")
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      height: height * 0.07,
                                                      width: width,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              height:
                                                                  height * 0.1,
                                                              width:
                                                                  width * 0.15,
                                                              decoration: const BoxDecoration(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          204,
                                                                          241,
                                                                          238,
                                                                          240),
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: const Icon(
                                                                  Icons
                                                                      .person)),
                                                          // SizedBox(
                                                          //   width:
                                                          //       width * 0.3,
                                                          //   // color: Colors.green,
                                                          //   child: Text(
                                                          //     '${snapshot1.data?.docs[index].get('name')}',
                                                          //     style: const TextStyle(
                                                          //         fontSize:
                                                          //             20),
                                                          //   ),
                                                          // ),
                                                          Text(
                                                            '${snapshot.data?.docs[index].get('friendName')}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.01,
                                                    )
                                                  ],
                                                );
                                          // ? Card(
                                          //     color: const Color.fromARGB(
                                          //         255, 187, 182, 221),
                                          //     // elevation: 5,
                                          //     child: Container(
                                          //       width: width,
                                          //       height: height * 0.08,
                                          //       decoration: BoxDecoration(
                                          //           // color: Colors.brown,
                                          //           borderRadius:
                                          //               BorderRadius
                                          //                   .circular(20)),
                                          //       // color: Colors.red,
                                          //       child: Center(
                                          //         child: Row(
                                          //           mainAxisAlignment:
                                          //               MainAxisAlignment
                                          //                   .spaceEvenly,
                                          //           children: [
                                          //             const Icon(
                                          //                 Icons.person),
                                          //             Padding(
                                          //               padding:
                                          //                   const EdgeInsets
                                          //                           .symmetric(
                                          //                       horizontal:
                                          //                           10),
                                          //               child: InkWell(
                                          //                 onTap: () {
                                          //                   if (snapshot
                                          //                           .data
                                          //                           ?.docs[
                                          //                               index]
                                          //                           .get(
                                          //                               'senderid') ==
                                          //                       Staticdata
                                          //                           .id) {
                                          //                     chatid = chatRoomId(
                                          //                         snapshot
                                          //                             .data
                                          //                             ?.docs[
                                          //                                 index]
                                          //                             .get(
                                          //                                 'senderid'),
                                          //                         snapshot
                                          //                             .data
                                          //                             ?.docs[
                                          //                                 index]
                                          //                             .get(
                                          //                                 'isclicked'));
                                          //                   } else {
                                          //                     chatid = chatRoomId(
                                          //                         snapshot
                                          //                             .data
                                          //                             ?.docs[
                                          //                                 index]
                                          //                             .get(
                                          //                                 'isclicked'),
                                          //                         snapshot
                                          //                             .data
                                          //                             ?.docs[
                                          //                                 index]
                                          //                             .get(
                                          //                                 'senderid'));
                                          //                   }

                                          //                   Navigator.push(
                                          //                       context,
                                          //                       MaterialPageRoute(
                                          //                         builder: (context) => Message(
                                          //                             chatid:
                                          //                                 chatid,
                                          //                             name: snapshot
                                          //                                 .data
                                          //                                 ?.docs[index]
                                          //                                 .get('isclickname')),
                                          //                       ));
                                          //                 },
                                          //                 child: SizedBox(
                                          //                   width:
                                          //                       width * 0.6,
                                          //                   child: Text(
                                          //                     '${snapshot.data?.docs[index].get('isclickname')}',
                                          //                     style: const TextStyle(
                                          //                         fontSize:
                                          //                             20),
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //             SizedBox(
                                          //               width: width * 0.1,
                                          //             ),
                                          //             InkWell(
                                          //                 onTap: () {
                                          //                   deleteFriend(
                                          //                       snapshot
                                          //                           .data
                                          //                           ?.docs[
                                          //                               index]
                                          //                           .get(
                                          //                               'friendcollectionid'),
                                          //                       snapshot
                                          //                           .data
                                          //                           ?.docs[
                                          //                               index]
                                          //                           .get(
                                          //                               'senderid'));
                                          //                 },
                                          //                 child: const Icon(
                                          //                     Icons
                                          //                         .remove_circle_sharp)),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   )
                                          // : Card(
                                          //     color: const Color.fromARGB(
                                          //         255, 187, 182, 221),
                                          //     // elevation: 5,
                                          //     child: Container(
                                          //       width: width,
                                          //       height: height * 0.08,
                                          //       decoration: BoxDecoration(
                                          //           // color: Colors.brown,
                                          //           borderRadius:
                                          //               BorderRadius
                                          //                   .circular(20)),
                                          //       // color: Colors.red,
                                          //       child: Center(
                                          //         child: Row(
                                          //           mainAxisAlignment:
                                          //               MainAxisAlignment
                                          //                   .spaceEvenly,
                                          //           children: [
                                          //             const Icon(
                                          //                 Icons.person),
                                          //             Padding(
                                          //               padding:
                                          //                   const EdgeInsets
                                          //                           .symmetric(
                                          //                       horizontal:
                                          //                           10),
                                          //               child: InkWell(
                                          //                 onTap: () {
                                          //                   if (snapshot
                                          //                           .data
                                          //                           ?.docs[
                                          //                               index]
                                          //                           .get(
                                          //                               'senderid') ==
                                          //                       Staticdata
                                          //                           .id) {
                                          //                     chatid = chatRoomId(
                                          //                         snapshot
                                          //                             .data
                                          //                             ?.docs[
                                          //                                 index]
                                          //                             .get(
                                          //                                 'senderid'),
                                          //                         snapshot
                                          //                             .data
                                          //                             ?.docs[
                                          //                                 index]
                                          //                             .get(
                                          //                                 'isclicked'));
                                          //                   } else {
                                          //                     chatid = chatRoomId(
                                          //                         snapshot
                                          //                             .data
                                          //                             ?.docs[
                                          //                                 index]
                                          //                             .get(
                                          //                                 'isclicked'),
                                          //                         snapshot
                                          //                             .data
                                          //                             ?.docs[
                                          //                                 index]
                                          //                             .get(
                                          //                                 'senderid'));
                                          //                   }
                                          //                   Navigator.push(
                                          //                       context,
                                          //                       MaterialPageRoute(
                                          //                           builder: (context) => Message(
                                          //                               chatid:
                                          //                                   chatid,
                                          //                               name:
                                          //                                   snapshot.data?.docs[index].get('sendername'))));
                                          //                 },
                                          //                 child: Text(
                                          //                   '${snapshot.data!.docs[index].get('sendername')}',
                                          //                   style: const TextStyle(
                                          //                       fontSize:
                                          //                           20,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w500),
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //             SizedBox(
                                          //               width: width * 0.55,
                                          //             ),
                                          //             InkWell(
                                          //                 onTap: () {
                                          //                   deleteFriend(
                                          //                       snapshot
                                          //                           .data
                                          //                           ?.docs[
                                          //                               index]
                                          //                           .get(
                                          //                               'friendcollectionid'),
                                          //                       snapshot
                                          //                           .data
                                          //                           ?.docs[
                                          //                               index]
                                          //                           .get(
                                          //                               'senderid'));
                                          //                 },
                                          //                 child: const Icon(
                                          //                     Icons
                                          //                         .remove_circle_sharp)),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   );
                                        }
                                        // 2
                                        else if (snapshot.data!.docs[index]
                                            .get('friendName')
                                            .toString()
                                            .toLowerCase()
                                            .contains(name.toLowerCase())) {
                                          return snapshot.data?.docs[index]
                                                      .get('friendName') ==
                                                  Staticdata.id
                                              ? Card(
                                                  // elevation: 5,
                                                  // // child: Container(
                                                  // //   width: width,
                                                  // //   height: height * 0.08,
                                                  // //   color: const Color(0xffF8F8F8),
                                                  // //   child: Center(
                                                  // //     child: Text(
                                                  // //       '${snapshot.data!.docs[index].get('name')}',
                                                  // //       style: const TextStyle(
                                                  // //           fontSize: 20),
                                                  // //     ),
                                                  // //   ),
                                                  // // ),
                                                  // color: const Color.fromARGB(
                                                  //     255, 187, 182, 221),
                                                  // // elevation: 5,
                                                  // child: Container(
                                                  //   width: width,
                                                  //   height: height * 0.08,
                                                  //   decoration: BoxDecoration(
                                                  //       // color: Colors.brown,
                                                  //       borderRadius:
                                                  //           BorderRadius
                                                  //               .circular(20)),
                                                  //   // color: Colors.red,
                                                  //   child: Center(
                                                  //     child: Row(
                                                  //       children: [
                                                  //         const Icon(
                                                  //             Icons.person),
                                                  //         Padding(
                                                  //           padding:
                                                  //               const EdgeInsets
                                                  //                       .symmetric(
                                                  //                   horizontal:
                                                  //                       10),
                                                  //           child: Text(
                                                  //             '${snapshot.data!.docs[index].get('friendName')}',
                                                  //             style: const TextStyle(
                                                  //                 fontSize: 20,
                                                  //                 fontWeight:
                                                  //                     FontWeight
                                                  //                         .w500),
                                                  //           ),
                                                  //         ),
                                                  //         // InkWell(
                                                  //         //     onTap: () {
                                                  //         //       deleteFriend(
                                                  //         //           snapshot
                                                  //         //               .data
                                                  //         //               ?.docs[
                                                  //         //                   index]
                                                  //         //               .get(
                                                  //         //                   'friendcollectionid'),
                                                  //         //           snapshot
                                                  //         //               .data
                                                  //         //               ?.docs[
                                                  //         //                   index]
                                                  //         //               .get(
                                                  //         //                   'senderid'));
                                                  //         //     },
                                                  //         //     child: const Icon(
                                                  //         //         Icons
                                                  //         //             .remove_circle_sharp)),
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  )
                                              : Card(
                                                  elevation: 5,
                                                  // child: Container(
                                                  //   width: width,
                                                  //   height: height * 0.08,
                                                  //   color: const Color(0xffF8F8F8),
                                                  //   child: Center(
                                                  //     child: Text(
                                                  //       '${snapshot.data!.docs[index].get('name')}',
                                                  //       style: const TextStyle(
                                                  //           fontSize: 20),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  color: const Color.fromARGB(
                                                      255, 187, 182, 221),
                                                  // elevation: 5,
                                                  child: Container(
                                                    width: width,
                                                    height: height * 0.08,
                                                    decoration: BoxDecoration(
                                                        // color: Colors.brown,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    // color: Colors.red,
                                                    child: Center(
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.person),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Text(
                                                              '${snapshot.data!.docs[index].get('friendName')}',
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.55,
                                                          ),
                                                          // InkWell(
                                                          //     onTap: () {
                                                          //       deleteFriend(
                                                          //           snapshot
                                                          //               .data
                                                          //               ?.docs[
                                                          //                   index]
                                                          //               .get(
                                                          //                   'friendcollectionid'),
                                                          //           snapshot
                                                          //               .data
                                                          //               ?.docs[
                                                          //                   index]
                                                          //               .get(
                                                          //                   'senderid'));
                                                          //     },
                                                          //     child: const Icon(
                                                          //         Icons
                                                          //             .remove_circle_sharp)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }
}
