import 'package:chat_app/friend_model.dart';
import 'package:chat_app/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AcceptFriend extends StatefulWidget {
  const AcceptFriend({super.key});

  @override
  State<AcceptFriend> createState() => _AcceptFriendState();
}

class _AcceptFriendState extends State<AcceptFriend> {
  // ignore: prefer_typing_uninitialized_variables
  var width, height;
  TextEditingController searchController = TextEditingController();
  String name = '';
  FirebaseFirestore instance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  // ignore: non_constant_identifier_names
  AcceptFriend(
    String receiverId,
    String senderID,
    String senderName,
    String receiverName,
    String a,
  ) async {
    FriendModel model1 =
        FriendModel(friendId: senderID, friendName: senderName);
// login User

    await FirebaseFirestore.instance
        .collection("Requests")
        .doc(a)
        .update({'status': 'accepted'});

    await FirebaseFirestore.instance
        .collection("friendlist")
        .doc(Staticdata.loginuser!.uid)
        .collection('friends')
        .doc()
        .set(model1.toMap());
    // updateStatus('${snapshot.data?.docs[index].get('requestId')}');
    // await FirebaseFirestore.instance
    //     .collection("Requests")
    //     .doc('requestId')
    //     .update({'status': 'accepted'});

    // Sender
    FriendModel model2 =
        FriendModel(friendId: receiverId, friendName: receiverName);
    await FirebaseFirestore.instance
        .collection("friendlist")
        .doc(senderID)
        .collection('friends')
        .doc()
        .set(model2.toMap());

    // await FirebaseFirestore.instance
    //     .collection("Requests")
    //     .doc('requestId')
    //     .update({'status': 'accepted'});
  }

  DeleteFriend(String status, String frienlistID, String senderID) async {
// login User
    await FirebaseFirestore.instance
        .collection("friendlist")
        .doc(Staticdata.loginuser!.uid)
        .collection('friends')
        .doc(frienlistID)
        .delete();
    // Sender
    await FirebaseFirestore.instance
        .collection("friendlist")
        .doc(senderID)
        .collection('friends')
        .doc(frienlistID)
        .delete();
  }

  @override
  void initState() {
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
        title: const Text('Accept Friend'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: instance
                    .collection('Requests')
                    .where('receiverId', isEqualTo: Staticdata.loginuser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? SizedBox(
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
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(2, 110, 150, 0.8),
                                          width: 2),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(2, 110, 150, 0.8),
                                          width: 2),
                                    ),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.amber, width: 2),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    hintText: 'search',
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        204, 241, 238, 240),
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
                                    child: ListView.builder(
                                        itemCount: snapshot.data?.docs.length,
                                        // ignore: missing_return
                                        itemBuilder: (context, index) {
                                          // 1
                                          if (name.isEmpty) {
                                            return snapshot.data!.docs[index]
                                                        .get('status') ==
                                                    'pending'
                                                ? Column(
                                                    children: [
                                                      SizedBox(
                                                        width: width,
                                                        height: height * 0.08,
                                                        // color: Color(0xffF8F8F8),

                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.03),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Container(
                                                                  height:
                                                                      height *
                                                                          0.1,
                                                                  width: width *
                                                                      0.15,
                                                                  decoration: const BoxDecoration(
                                                                      color: Color.fromARGB(
                                                                          204,
                                                                          241,
                                                                          238,
                                                                          240),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child: const Icon(
                                                                      Icons
                                                                          .person)),
                                                              SizedBox(
                                                                width: width *
                                                                    0.25,
                                                                // color: Colors.green,
                                                                child: Text(
                                                                  '${snapshot.data?.docs[index].get('sendername')}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  AcceptFriend(
                                                                    snapshot
                                                                        .data
                                                                        ?.docs[
                                                                            index]
                                                                        .get(
                                                                            'receiverId'),
                                                                    snapshot
                                                                        .data
                                                                        ?.docs[
                                                                            index]
                                                                        .get(
                                                                            'senderid'),
                                                                    snapshot
                                                                        .data
                                                                        ?.docs[
                                                                            index]
                                                                        .get(
                                                                            'sendername'),
                                                                    snapshot
                                                                        .data
                                                                        ?.docs[
                                                                            index]
                                                                        .get(
                                                                            'receiverName'),
                                                                    snapshot
                                                                        .data
                                                                        ?.docs[
                                                                            index]
                                                                        .get(
                                                                            'requestId'),
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        height: height *
                                                                            0.05,
                                                                        width: width *
                                                                            0.25,
                                                                        color: const Color.fromRGBO(
                                                                            2,
                                                                            110,
                                                                            150,
                                                                            0.8),
                                                                        child:
                                                                            const Text(
                                                                          "Add Friend",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
                                                                        )),
                                                              ),
                                                              SizedBox(
                                                                width: width *
                                                                    0.01,
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    DeleteFriend(
                                                                        // snapshot
                                                                        //     .data!
                                                                        //     .docs[index]
                                                                        //     .get("friendlist")
                                                                        'deleted',
                                                                        snapshot
                                                                            .data
                                                                            ?.docs[
                                                                                index]
                                                                            .get(
                                                                                'friendcollectioid'),
                                                                        snapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                            .get('senderid'));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                          alignment: Alignment
                                                                              .center,
                                                                          height: height *
                                                                              0.05,
                                                                          width: width *
                                                                              0.25,
                                                                          color: const Color.fromRGBO(
                                                                              2,
                                                                              110,
                                                                              150,
                                                                              0.8),
                                                                          child:
                                                                              const Text(
                                                                            "Delete",
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                          ))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const Divider(
                                                        // height: 20,
                                                        thickness: 1,
                                                        indent: 80,
                                                        // endIndent: 140,
                                                        color: Color.fromRGBO(
                                                            203, 197, 201, 1),
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox();
                                          }

                                          //2

                                          else if (snapshot.data!.docs[index]
                                              .get('sendername')
                                              .toString()
                                              .toLowerCase()
                                              .contains(name.toLowerCase())) {
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
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                            height: height *
                                                                0.1,
                                                            width: width * 0.15,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            204,
                                                                            241,
                                                                            238,
                                                                            240),
                                                                    shape: BoxShape
                                                                        .circle),
                                                            child: const Icon(
                                                                Icons.person)),
                                                        SizedBox(
                                                          width: width * 0.25,
                                                          // color: Colors.green,
                                                          child: Text(
                                                            '${snapshot.data?.docs[index].get('sendername')}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            AcceptFriend(
                                                              snapshot.data
                                                                  ?.docs[index]
                                                                  .get(
                                                                      'receiverId'),
                                                              snapshot.data
                                                                  ?.docs[index]
                                                                  .get(
                                                                      'senderid'),
                                                              snapshot.data
                                                                  ?.docs[index]
                                                                  .get(
                                                                      'sendername'),
                                                              snapshot.data
                                                                  ?.docs[index]
                                                                  .get(
                                                                      'receiverName'),
                                                              snapshot.data
                                                                  ?.docs[index]
                                                                  .get(
                                                                      'requestId'),
                                                            );
                                                          },
                                                          child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height:
                                                                  height * 0.05,
                                                              width:
                                                                  width * 0.25,
                                                              color: const Color
                                                                      .fromRGBO(
                                                                  2,
                                                                  110,
                                                                  150,
                                                                  0.8),
                                                              child: const Text(
                                                                "Add Friend",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                          // child: Icon(
                                                          //     Icons.add)
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.01,
                                                        ),
                                                        InkWell(
                                                            onTap: () {
                                                              DeleteFriend(
                                                                  // snapshot
                                                                  //   .data!
                                                                  //   .docs[index]
                                                                  //   .get(
                                                                  //       "friendcollectioid")
                                                                  'deleted',
                                                                  snapshot
                                                                      .data
                                                                      ?.docs[
                                                                          index]
                                                                      .get(
                                                                          'friendcollectioid'),
                                                                  snapshot
                                                                      .data
                                                                      ?.docs[
                                                                          index]
                                                                      .get(
                                                                          'senderid'));
                                                            },
                                                            child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: height *
                                                                    0.05,
                                                                width: width *
                                                                    0.25,
                                                                color: const Color
                                                                        .fromRGBO(
                                                                    2,
                                                                    110,
                                                                    150,
                                                                    0.8),
                                                                child:
                                                                    const Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ))
                                                            // child: Icon(
                                                            //     Icons.clear)
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
                                                  color: Color.fromRGBO(
                                                      203, 197, 201, 1),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Center(child: CircularProgressIndicator());
                }),
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
      //               .collection('friendlist')
      //               .doc(Staticdata.loginuser!.uid)
      //               .collection('friends')
      //               .where('isclicked', isEqualTo: Staticdata.loginuser!.uid)
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
      //                                   if (name.isEmpty) {
      //                                     return snapshot.data!.docs[index]
      //                                                 .get('status') ==
      //                                             'pending'
      //                                         ? Card(
      //                                             color: const Color.fromARGB(
      //                                                 255, 187, 182, 221),
      //                                             // elevation: 5,
      //                                             child: Container(
      //                                               width: width,
      //                                               height: height * 0.08,
      //                                               decoration: BoxDecoration(
      //                                                   // color: Colors.brown,
      //                                                   borderRadius:
      //                                                       BorderRadius
      //                                                           .circular(20)),
      //                                               // color: Colors.red,
      //                                               child: Center(
      //                                                 child: Row(
      //                                                   mainAxisAlignment:
      //                                                       MainAxisAlignment
      //                                                           .spaceBetween,
      //                                                   children: [
      //                                                     const Icon(
      //                                                         Icons.person),
      //                                                     SizedBox(
      //                                                       child: Container(
      //                                                         width:
      //                                                             width * 0.3,
      //                                                         child: Text(
      //                                                           '${snapshot.data!.docs[index].get('sendername')}',
      //                                                           style: const TextStyle(
      //                                                               fontSize:
      //                                                                   20,
      //                                                               fontWeight:
      //                                                                   FontWeight
      //                                                                       .w500),
      //                                                         ),
      //                                                       ),
      //                                                     ),
      //                                                     SizedBox(
      //                                                       width: width * 0.35,
      //                                                     ),
      //                                                     InkWell(
      //                                                         onTap: () {
      //                                                           AcceptFriend(
      //                                                               'accepted',
      //                                                               snapshot
      //                                                                   .data
      //                                                                   ?.docs[
      //                                                                       index]
      //                                                                   .get(
      //                                                                       'friendcollectionid'),
      //                                                               snapshot
      //                                                                   .data
      //                                                                   ?.docs[
      //                                                                       index]
      //                                                                   .get(
      //                                                                       'senderid'));
      //                                                         },
      //                                                         child: Icon(
      //                                                           Icons
      //                                                               .person_add,
      //                                                           size: width *
      //                                                               0.07,
      //                                                           color: const Color
      //                                                                   .fromARGB(
      //                                                               255,
      //                                                               0,
      //                                                               128,
      //                                                               179),
      //                                                         )),
      //                                                     InkWell(
      //                                                         onTap: () {
      //                                                           deleteFriend(
      //                                                               snapshot
      //                                                                   .data
      //                                                                   ?.docs[
      //                                                                       index]
      //                                                                   .get(
      //                                                                       'friendcollectionid'),
      //                                                               snapshot
      //                                                                   .data
      //                                                                   ?.docs[
      //                                                                       index]
      //                                                                   .get(
      //                                                                       'senderid'));
      //                                                         },
      //                                                         child: const Icon(
      //                                                             Icons
      //                                                                 .remove_circle_sharp)),
      //                                                   ],
      //                                                 ),
      //                                               ),
      //                                             ),
      //                                           )
      //                                         : SizedBox();
      //                                   }
      //                                   // 2
      //                                   else if (snapshot.data!.docs[index]
      //                                       .get('sendername')
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
      //                                               mainAxisAlignment:
      //                                                   MainAxisAlignment
      //                                                       .spaceBetween,
      //                                               children: [
      //                                                 const Icon(Icons.person),
      //                                                 SizedBox(
      //                                                   child: Container(
      //                                                     width: width * 0.3,
      //                                                     child: Text(
      //                                                       '${snapshot.data!.docs[index].get('sendername')}',
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
      //                                                       AcceptFriend(
      //                                                           'accepted',
      //                                                           snapshot
      //                                                               .data
      //                                                               ?.docs[
      //                                                                   index]
      //                                                               .get(
      //                                                                   'friendcollectionid'),
      //                                                           snapshot
      //                                                               .data
      //                                                               ?.docs[
      //                                                                   index]
      //                                                               .get(
      //                                                                   'senderid'));
      //                                                     },
      //                                                     child: Icon(
      //                                                       Icons.person_add,
      //                                                       size: width * 0.07,
      //                                                       color: const Color
      //                                                               .fromARGB(
      //                                                           255,
      //                                                           0,
      //                                                           128,
      //                                                           179),
      //                                                     )),
      //                                                 InkWell(
      //                                                     onTap: () {
      //                                                       deleteFriend(
      //                                                           snapshot
      //                                                               .data
      //                                                               ?.docs[
      //                                                                   index]
      //                                                               .get(
      //                                                                   'friendcollectionid'),
      //                                                           snapshot
      //                                                               .data
      //                                                               ?.docs[
      //                                                                   index]
      //                                                               .get(
      //                                                                   'senderid'));
      //                                                     },
      //                                                     child: const Icon(Icons
      //                                                         .remove_circle_sharp)),
      //                                               ],
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ],
      //                                     );
      //                                   } else {
      //                                     return Container();
      //                                   }
      //                                   // 1
      //                                   // if (name.isEmpty) {
      //                                   // return snapshot.data!.docs[index]
      //                                   //             .get('status') ==
      //                                   //         'pending'
      //                                   //     ? Column(
      //                                   //         children: [
      //                                   //           Container(
      //                                   //             width: width,
      //                                   //             height: height * 0.08,
      //                                   //             decoration: BoxDecoration(
      //                                   //                 // color: Colors.cyan,
      //                                   //                 borderRadius:
      //                                   //                     BorderRadius
      //                                   //                         .circular(20)),
      //                                   //             // color: Colors.red,
      //                                   //             child: Center(
      //                                   //               child: Row(
      //                                   //                 mainAxisAlignment:
      //                                   //                     MainAxisAlignment
      //                                   //                         .spaceBetween,
      //                                   //                 children: [
      //                                   //                   const Icon(
      //                                   //                       Icons.person),
      //                                   //                   SizedBox(
      //                                   //                     child: Container(
      //                                   //                       width:
      //                                   //                           width * 0.3,
      //                                   //                       child: Text(
      //                                   //                         '${snapshot.data!.docs[index].get('sendername')}',
      //                                   //                         style: const TextStyle(
      //                                   //                             fontSize:
      //                                   //                                 20,
      //                                   //                             fontWeight:
      //                                   //                                 FontWeight
      //                                   //                                     .w500),
      //                                   //                       ),
      //                                   //                     ),
      //                                   //                   ),
      //                                   //                   SizedBox(
      //                                   //                     width: width * 0.35,
      //                                   //                   ),
      //                                   //                   InkWell(
      //                                   //                       onTap: () {
      //                                   //                         AcceptFriend(
      //                                   //                             'accepted',
      //                                   //                             snapshot
      //                                   //                                 .data
      //                                   //                                 ?.docs[
      //                                   //                                     index]
      //                                   //                                 .get(
      //                                   //                                     'friendcollectionid'),
      //                                   //                             snapshot
      //                                   //                                 .data
      //                                   //                                 ?.docs[
      //                                   //                                     index]
      //                                   //                                 .get(
      //                                   //                                     'senderid'));
      //                                   //                       },
      //                                   //                       child: Icon(
      //                                   //                         Icons
      //                                   //                             .person_add,
      //                                   //                         size: width *
      //                                   //                             0.07,
      //                                   //                         color: const Color
      //                                   //                                 .fromARGB(
      //                                   //                             255,
      //                                   //                             0,
      //                                   //                             128,
      //                                   //                             179),
      //                                   //                       )),
      //                                   //                   InkWell(
      //                                   //                       onTap: () {
      //                                   //                         deleteFriend(
      //                                   //                             snapshot
      //                                   //                                 .data
      //                                   //                                 ?.docs[
      //                                   //                                     index]
      //                                   //                                 .get(
      //                                   //                                     'friendcollectionid'),
      //                                   //                             snapshot
      //                                   //                                 .data
      //                                   //                                 ?.docs[
      //                                   //                                     index]
      //                                   //                                 .get(
      //                                   //                                     'senderid'));
      //                                   //                       },
      //                                   //                       child: const Icon(
      //                                   //                           Icons
      //                                   //                               .remove_circle_sharp)),
      //                                   //                 ],
      //                                   //               ),
      //                                   //             ),
      //                                   //           ),
      //                                   //         ],
      //                                   //       )
      //                                   //     : SizedBox();
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
