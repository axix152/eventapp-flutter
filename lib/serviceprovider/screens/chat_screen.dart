import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/hosts/helper/provider_model.dart';
import 'package:eventapp/serviceprovider/screens/chatroonScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../hosts/helper/FirebaseHelper.dart';
import '../../hosts/helper/chatRoom_model.dart';
import '../../hosts/helper/usermodel.dart';
import '../../hosts/widget/widgets.dart';

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
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
                              return ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                ),
                                title: Text(targetuser.fullName.toString()),
                                subtitle:
                                    Text(chatRoomModel.lastmessage.toString()),
                                onTap: () {
                                  nextScreen(
                                      context,
                                      ChatRoomScreen(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        targetuser.fullName,
                                        chatRoomModel,
                                      ));
                                },
                              );
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
