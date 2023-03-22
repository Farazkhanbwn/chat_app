import 'package:chat_app/Model/add_friend_model.dart';
import 'package:chat_app/friend_model.dart';
import 'package:chat_app/static_data.dart';
import 'package:chat_app/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  // ignore: prefer_typing_uninitialized_variables
  var width, height;
  TextEditingController searchController = TextEditingController();
  String name = '';
  FirebaseFirestore instance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  List<UserModel> totalUsersINTOList = [];
  bool loading = true;
  void addTotalUsersINTOList() async {
    await instance
        .collection('users')
        .where('uid', isNotEqualTo: Staticdata.id)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          totalUsersINTOList.add(UserModel.fromMap(element.data()));
        });
      });
    });
    // print('addTotalUserinList ${totalUsersINTOList}');
  }

  List<FriendModel> friendModellist = [];
  void addFriendModelINTOList() async {
    await instance
        .collection('friendlist')
        .doc(Staticdata.id)
        .collection('friends')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          friendModellist.add(FriendModel.fromMap(element.data()));
        });
      });
    });
  }

  List<String> statusList = [];
  void filterStatus() {
    statusList.clear();
    print('totalUsersINTOListlength ${totalUsersINTOList.length}');
    print('friendModellistlength ${friendModellist.length}');

    for (int i = 0; i < totalUsersINTOList.length; i++) {
      for (int j = 0; j < friendModellist.length; j++) {
        if (totalUsersINTOList[i].uid == friendModellist[j].friendId) {
          statusList.add('friends');
        } else {
          statusList.add('add Friends');
        }
      }
    }
    print('statusList $statusList');
    setState(() {
      loading = false;
    });
  }

  addFriend(String receiverId, String receiverName) async {
    String id = Uuid().v4();
    print(id);
    AddFriendModel requestModel = AddFriendModel(
        requestId: id,
        receiverId: receiverId,
        receiverName: receiverName,
        senderid: Staticdata.loginuser!.uid,
        sendername: Staticdata.loginuser!.name,
        status: 'pending',
        time: DateFormat.jm().format(DateTime.now()));
    // Sender
    await FirebaseFirestore.instance
        .collection("Requests")
        .doc(id)
        .set(requestModel.toMap());
    // checkUserStatus(receiverId);
    // Is Clicked
    // await FirebaseFirestore.instance
    //     .collection("friendlist")
    //     .doc(clickid)
    //     .collection("friends")
    //     .doc(id)
    //     .set(model.toMap());
  }

  // checkUserStatus(String reciverId) async {
  //   CheckUserModel model = CheckUserModel(
  //       receiverid: reciverId,
  //       status: "pending",
  //       checkid: Staticdata.loginuser!.uid);
  //   await FirebaseFirestore.instance
  //       // .collection("Checkstatus")
  //       .doc(Staticdata.loginuser!.uid)
  //       .collection("checklist")
  //       .doc()
  //       .set(model.toMap());

  //   CheckUserModel modell = CheckUserModel(
  //       receiverid: Staticdata.loginuser!.uid,
  //       status: "pending",
  //       checkid: reciverId);
  //   await FirebaseFirestore.instance
  //       .collection("Checkstatus")
  //       .doc(reciverId)
  //       .collection("checklist")
  //       .doc()
  //       .set(modell.toMap());
  // }

  // String? statuss;
  // int? index;
  // String? receiverID;
  // List<CheckUserModel> checkuserlist = [];
  // void getCheckUserStatus() async {
  //   await FirebaseFirestore.instance
  //       // .collection("Checkstatus")
  //       .doc(Staticdata.loginuser!.uid)
  //       .collection("checklist")
  //       .get()
  //       .then((value) {
  //     setState(() {});
  //     // value.docs.forEach((element) {
  //     //   checkuserlist.add(CheckUserModel.fromMap(element.data()));
  //     // });
  //     statuss = checkuserlist[index!].status;
  //     receiverID = checkuserlist[index!].receiverid;
  //     // senderID = checkuserlist[index!].;
  //     // receiverID = checkuserlist[index!].;
  //     print('checkuserlist    ${checkuserlist.toString()}');
  //   });
  // }

  @override
  void initState() {
    addTotalUsersINTOList();
    addFriendModelINTOList();
    Future.delayed(const Duration(seconds: 5), () {
      filterStatus();
    });
    // getCheckUserStatus();
    searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: ListView(
          children: [
            // StreamBuilder<QuerySnapshot>(
            //     stream: instance
            //         .collection('Checkstatus')
            //         .where('checkid', isEqualTo: Staticdata.id)
            //         .snapshots(),
            //     builder: (context, snapshot2) {
            //       return StreamBuilder<QuerySnapshot>(
            //           stream: instance
            //               .collection('users')
            //               .where('uid', isNotEqualTo: Staticdata.id)
            //               .snapshots(),
            //           builder: (context, snapshot1) {
            //             return snapshot1.data != null
            //                 ?
            SizedBox(
              width: width * 0.9,
              height: height * 0.9,
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  SizedBox(
                    width: width * 0.9,
                    height: height * 0.05,
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(2, 110, 150, 0.8),
                              width: 2),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(2, 110, 150, 0.8),
                              width: 2),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        hintText: 'search',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: const Color.fromARGB(204, 241, 238, 240),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();
                              // logout();
                            },
                            icon: searchController.text.isEmpty
                                ? const SizedBox()
                                : const Icon(Icons.clear)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.03),
                      child: SizedBox(
                        width: width,
                        height: height * 0.9,
                        child: loading == true
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: totalUsersINTOList.length,
                                // ignore: missing_return
                                itemBuilder: (context, index) {
                                  // 1
                                  // if (name.isEmpty) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width: width,
                                        height: height * 0.08,
                                        // color: Color(0xffF8F8F8),

                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.03),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  height: height * 0.1,
                                                  width: width * 0.15,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color:
                                                              Color.fromARGB(
                                                                  204,
                                                                  241,
                                                                  238,
                                                                  240),
                                                          shape:
                                                              BoxShape.circle),
                                                  child:
                                                      const Icon(Icons.person)),
                                              SizedBox(
                                                width: width * 0.3,
                                                // color: Colors.green,
                                                child: Text(
                                                  // '${snapshot1.data?.docs[index].get('name')}',
                                                  '${totalUsersINTOList[index].name}',
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.08,
                                              ),
                                              statusList[index] == 'add Friends'
                                                  ? InkWell(
                                                      onTap: () {
                                                        // addFriend(
                                                        //     snapshot1
                                                        //         .data!
                                                        //         .docs[
                                                        //             index]
                                                        //         .get(
                                                        //             "uid"),
                                                        //     snapshot1
                                                        //         .data!
                                                        //         .docs[
                                                        //             index]
                                                        //         .get(
                                                        //             "name"));
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: height * 0.05,
                                                        width: width * 0.3,
                                                        color: const Color
                                                                .fromRGBO(
                                                            2, 110, 150, 0.8),
                                                        child: const Text(
                                                          "Add Friend",
                                                          // receiverID == Staticdata.loginuser!.uid &&
                                                          //         snapshot1.data!.docs[index].get("status") ==
                                                          //             'accepted'
                                                          //     ? 'Added'
                                                          //     : "Add Friend",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: height * 0.05,
                                                      width: width * 0.3,
                                                      color: Colors.deepPurple,
                                                      child: const Text(
                                                        "Friend",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        // height: 20,
                                        thickness: 1,
                                        indent: 80,
                                        // endIndent: 140,
                                        color: Color.fromRGBO(203, 197, 201, 1),
                                      ),
                                    ],
                                  );
                                }

                                //2

                                // else if (snapshot1
                                //     .data!.docs[index]
                                //     .get('name')
                                //     .toString()
                                //     .toLowerCase()
                                //     .contains(
                                //         name.toLowerCase())) {
                                //   return Column(
                                //     children: [
                                //       SizedBox(
                                //         width: width,
                                //         height: height * 0.08,
                                //         // color: Color(0xffF8F8F8),

                                //         child: Padding(
                                //           padding:
                                //               EdgeInsets.only(
                                //                   left: width *
                                //                       0.03),
                                //           child: Row(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment
                                //                     .spaceEvenly,
                                //             children: [
                                //               Container(
                                //                   height:
                                //                       height *
                                //                           0.1,
                                //                   width: width *
                                //                       0.15,
                                //                   decoration: const BoxDecoration(
                                //                       color: Color.fromARGB(
                                //                           204,
                                //                           241,
                                //                           238,
                                //                           240),
                                //                       shape: BoxShape
                                //                           .circle),
                                //                   child: const Icon(
                                //                       Icons
                                //                           .person)),
                                //               SizedBox(
                                //                 width:
                                //                     width * 0.3,
                                //                 // color: Colors.green,
                                //                 child: Text(
                                //                   '${snapshot1.data?.docs[index].get('name')}',
                                //                   style: const TextStyle(
                                //                       fontSize:
                                //                           20),
                                //                 ),
                                //               ),
                                //               SizedBox(
                                //                 width: width *
                                //                     0.08,
                                //               ),
                                //               InkWell(
                                //                   onTap: () {
                                //                     addFriend(
                                //                         snapshot1
                                //                             .data!
                                //                             .docs[
                                //                                 index]
                                //                             .get(
                                //                                 "uid"),
                                //                         snapshot1
                                //                             .data!
                                //                             .docs[index]
                                //                             .get("name"));
                                //                   },
                                //                   child:
                                //                       Container(
                                //                           alignment: Alignment
                                //                               .center,
                                //                           height: height *
                                //                               0.05,
                                //                           width: width *
                                //                               0.3,
                                //                           color: const Color.fromRGBO(
                                //                               2,
                                //                               110,
                                //                               150,
                                //                               0.8),
                                //                           child:
                                //                               const Text(
                                //                             "Add Friend",
                                //                             // receiverID == Staticdata.loginuser!.uid && snapshot1.data!.docs[index].get("status") == 'accepted'
                                //                             //     ? 'cancel'
                                //                             //     : "Add Friend",
                                //                             style:
                                //                                 TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                //                           ))),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //       const Divider(
                                //         // height: 20,
                                //         thickness: 1,
                                //         indent: 80,
                                //         // endIndent: 140,
                                //         color: Color.fromRGBO(
                                //             203, 197, 201, 1),
                                //       ),
                                //     ],
                                //   );
                                // } else {
                                //   return Container();
                                // }
                                // }
                                ),
                      ),
                    ),
                  )
                ],
              ),
            )
            // : const Center(child: CircularProgressIndicator());
            // }
            //       );
            // }),
          ],
        ),
      ),
      // Container(
      //   width: width,
      //   height: height,
      //   color: const Color.fromARGB(255, 187, 182, 221),
      //   child: Column(
      //     children: [
      //       StreamBuilder<QuerySnapshot>(
      //           stream: instance
      //               .collection('users')
      //               .where('uid', isNotEqualTo: Staticdata.id)
      //               .snapshots(),
      //           builder: (context, snapshot) {
      //             return snapshot.data != null
      //                 ? SizedBox(
      //                     width: width * 0.9,
      //                     height: height * 0.9,
      //                     // color: Colors.brown,
      //                     child: Column(
      //                       children: [
      //                         SizedBox(
      //                           height: height * 0.05,
      //                           width: width * 0.9,
      //                         ),
      //                         SizedBox(
      //                           height: height * 0.08,
      //                           child: TextFormField(
      //                             controller: searchController,
      //                             // maxLength: 10,
      //                             decoration: InputDecoration(
      //                               border: InputBorder.none,
      //                               filled: true,
      //                               fillColor: const Color.fromARGB(
      //                                   255, 235, 235, 238),
      //                               hintText: 'search',
      //                               // labelText: 'Enter Email',
      //                               hintStyle: TextStyle(
      //                                   fontFamily: 'Montserrat',
      //                                   fontWeight: FontWeight.w400,
      //                                   fontSize: width * 0.04,
      //                                   color: const Color.fromRGBO(34, 34, 34,
      //                                       0.5)), /*labelText: 'Enter your email'*/
      //                             ),
      //                             onChanged: (value) {
      //                               setState(() {
      //                                 name = value;
      //                                 // ignore: avoid_print
      //                                 print(name);
      //                               });
      //                             },
      //                           ),
      //                         ),
      //                         Expanded(
      //                           child: SizedBox(
      //                             width: width * 0.9,
      //                             height: height * 0.9,
      //                             child: ListView.builder(
      //                                 itemCount: snapshot.data!.docs.length,
      //                                 // ignore: missing_return
      //                                 itemBuilder: (context, index) {
      //                                   // 1
      //                                   if (name.isEmpty) {
      //                                     return Column(
      //                                       children: [
      //                                         Container(
      //                                           width: width,
      //                                           height: height * 0.08,
      //                                           decoration: BoxDecoration(
      //                                               // color: Colors.cyan,
      //                                               borderRadius:
      //                                                   BorderRadius.circular(
      //                                                       20)),
      //                                           // color: Colors.red,
      //                                           child: Center(
      //                                             child: Row(
      //                                               mainAxisAlignment:
      //                                                   MainAxisAlignment
      //                                                       .spaceBetween,
      //                                               children: [
      //                                                 const Icon(Icons.person),
      //                                                 SizedBox(
      //                                                   child: Container(
      //                                                     width: width * 0.3,
      //                                                     child: Text(
      //                                                       '${snapshot.data!.docs[index].get('name')}',
      //                                                       style: const TextStyle(
      //                                                           fontSize: 20,
      //                                                           fontWeight:
      //                                                               FontWeight
      //                                                                   .w500),
      //                                                     ),
      //                                                   ),
      //                                                 ),
      //                                                 SizedBox(
      //                                                   width: width * 0.35,
      //                                                 ),
      //                                                 InkWell(
      //                                                     onTap: () {
      //                                                       addFriend(
      //                                                           snapshot.data!
      //                                                               .docs[index]
      //                                                               .get("uid"),
      //                                                           snapshot.data!
      //                                                               .docs[index]
      //                                                               .get(
      //                                                                   "name"));
      //                                                     },
      //                                                     child: const Icon(
      //                                                       Icons.person_add,
      //                                                       size: 30,
      //                                                     )),
      //                                                 SizedBox(
      //                                                   width: width * 0.01,
      //                                                 )
      //                                               ],
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ],
      //                                     );
      //                                   } else if (snapshot.data!.docs[index]
      //                                       .get('name')
      //                                       .toString()
      //                                       .toLowerCase()
      //                                       .contains(name.toLowerCase())) {
      //                                     return Column(
      //                                       children: [
      //                                         Container(
      //                                           width: width,
      //                                           height: height * 0.08,
      //                                           decoration: BoxDecoration(
      //                                               // color: Colors.cyan,
      //                                               borderRadius:
      //                                                   BorderRadius.circular(
      //                                                       20)),
      //                                           // color: Colors.red,
      //                                           child: Center(
      //                                             child: Row(
      //                                                 mainAxisAlignment:
      //                                                     MainAxisAlignment
      //                                                         .spaceBetween,
      //                                                 children: [
      //                                                   const Icon(
      //                                                       Icons.person),
      //                                                   SizedBox(
      //                                                     child: Container(
      //                                                       width: width * 0.3,
      //                                                       child: Text(
      //                                                         '${snapshot.data!.docs[index].get('name')}',
      //                                                         style: const TextStyle(
      //                                                             fontSize: 20,
      //                                                             fontWeight:
      //                                                                 FontWeight
      //                                                                     .w500),
      //                                                       ),
      //                                                     ),
      //                                                   ),
      //                                                   SizedBox(
      //                                                     width: width * 0.35,
      //                                                   ),
      //                                                   InkWell(
      //                                                       onTap: () {
      //                                                         addFriend(
      //                                                             snapshot
      //                                                                 .data!
      //                                                                 .docs[
      //                                                                     index]
      //                                                                 .get(
      //                                                                     "uid"),
      //                                                             snapshot
      //                                                                 .data!
      //                                                                 .docs[
      //                                                                     index]
      //                                                                 .get(
      //                                                                     "name"));
      //                                                       },
      //                                                       child: const Icon(
      //                                                           Icons
      //                                                               .person_add)),
      //                                                   SizedBox(
      //                                                     width: width * 0.01,
      //                                                   )
      //                                                 ]),
      //                                           ),
      //                                         ),
      //                                       ],
      //                                     );
      //                                   } else {
      //                                     return Container();
      //                                   }
      //                                 }),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   )
      //                 : const Center(child: CircularProgressIndicator());
      //           }),
      //     ],
      //   ),
      // ),
    );
  }
}
