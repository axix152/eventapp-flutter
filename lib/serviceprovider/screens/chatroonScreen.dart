import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../hosts/helper/chatRoom_model.dart';
import '../../hosts/helper/messagemodel.dart';
import '../../main.dart';

class ChatRoomScreen extends StatefulWidget {
  final String? userid;
  final String? name;
  final ChatRoomModel? chatroom;
  // ignore: use_key_in_widget_constructors
  const ChatRoomScreen([this.userid, this.name, this.chatroom]);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController msgcontroller = TextEditingController();
  void sendMessage() async {
    String msg = msgcontroller.text.trim();

    if (msg != "") {
      MessageModel newmessage = MessageModel(
        messageid: uid.v1(),
        sender: FirebaseAuth.instance.currentUser!.uid,
        text: msg,
        seen: false,
        createdAt: DateTime.now(),
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom!.chatRoomid)
          .collection("messages")
          .doc(newmessage.messageid)
          .set(newmessage.toMap())
          .whenComplete(() {
        debugPrint("Message have been added");
      });
      widget.chatroom!.lastmessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom!.chatRoomid)
          .set(widget.chatroom!.toMap());
      msgcontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(widget.chatroom!.chatRoomid)
                    .collection("messages")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot datasnapshot =
                          snapshot.data as QuerySnapshot;
                      return ListView.builder(
                          reverse: true,
                          itemCount: datasnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                datasnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            return Row(
                              mainAxisAlignment: currentMessage.sender ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: currentMessage.sender ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? Colors.grey
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          });
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An error occured! please check your internet connection"),
                      );
                    } else {
                      return const Center(
                        child: Text("say hi to your new friend"),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      // border: const Border(
                      //   top: BorderSide(color: Colors.black, width: 0.2),
                      // ),
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: msgcontroller,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: "Enter your Message..."),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
