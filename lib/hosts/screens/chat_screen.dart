import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/hosts/helper/chatRoom_model.dart';
import 'package:eventapp/hosts/helper/provider_model.dart';
import 'package:eventapp/hosts/screens/chat_main_screen.dart';
import 'package:eventapp/hosts/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helper/FirebaseHelper.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final currentuid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .where("participants.${currentuid}", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot =
                      snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);
                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;
                      List<String> participantkeys = participants.keys.toList();
                      participantkeys.remove(currentuid);
                      return FutureBuilder(
                          future: FireBaseHelper.getuserModelById(
                              participantkeys[0]),
                          builder: (context, userdata) {
                            if (userdata.connectionState ==
                                ConnectionState.done) {
                              ProvideModel targetuser =
                                  userdata.data as ProvideModel;
                              return FutureBuilder(
                                  future: FireBaseHelper.getuserModelById(
                                      participantkeys[0]),
                                  builder: (context, userdata) {
                                    if (userdata.connectionState ==
                                        ConnectionState.done) {
                                      ProvideModel targetuser =
                                          userdata.data as ProvideModel;
                                      return ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.black,
                                          ),
                                        ),
                                        title: Text(
                                            targetuser.fullName.toString()),
                                        subtitle: Text(chatRoomModel.lastmessage
                                            .toString()),
                                        onTap: () {
                                          nextScreen(
                                              context,
                                              ChatMainScreen(
                                                currentuid,
                                                targetuser.fullName,
                                                chatRoomModel,
                                              ));
                                        },
                                      );
                                    } else {
                                      return Container();
                                    }
                                  });
                            } else {
                              return Container();
                            }
                          });
                    },
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("No chats"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// ListView.builder(
//               itemCount: 4,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   onTap: () {
//                     nextScreen(context, ChatMainScreen());
//                   },
//                   title: const Text("Aziz"),
//                   subtitle: const Text("Hello how are you..."),
//                   leading: const CircleAvatar(
//                     radius: 30,
//                     backgroundImage: AssetImage('assets/register.png'),
//                     backgroundColor: Colors.black12,
//                   ),
//                   trailing: const Text("7:00 pm"),
//                 );
//               }),