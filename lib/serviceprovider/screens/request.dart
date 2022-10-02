import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/auth/services/database_Service.dart';
import 'package:eventapp/hosts/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Request extends StatefulWidget {
  const Request({Key? key}) : super(key: key);

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: 'Approved'),
    const Tab(
      text: "Pending",
    )
  ];
  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 2, initialIndex: 0, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final db = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("request");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Requests',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.pink,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          tabs: topTabs,
          controller: tabController,
          indicatorColor: Colors.black,
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          approved(db),
          pending(db),
        ],
      ),
    );
  }

  Widget approved(final db) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: db.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return data['isaccepted'] == true
                            ? ListTile(
                                title: Text(data['name']),
                                subtitle: Text(data['email']),
                                leading: const CircleAvatar(
                                  radius: 30,
                                  child: Icon(
                                    Icons.person,
                                    size: 35,
                                  ),
                                ),
                                trailing: const Text(
                                  "Approved",
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                                onLongPress: () {
                                  var currentuid =
                                      FirebaseAuth.instance.currentUser!.uid;
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(currentuid)
                                      .collection("request")
                                      .doc(data['id'])
                                      .delete()
                                      .then((value) {
                                    showSnakBar(context, Colors.red,
                                        "${data['email']} request is rejected");
                                  });
                                },
                              )
                            : Container();
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text("No request"),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                }
              })
        ],
      );

  Widget pending(final db) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: db.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return data['isaccepted'] == false
                            ? ListTile(
                                title: Text(data['name']),
                                subtitle: Text(data['email']),
                                leading: const CircleAvatar(
                                  radius: 30,
                                  child: Icon(
                                    Icons.person,
                                    size: 35,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        var currentuid = FirebaseAuth
                                            .instance.currentUser!.uid;
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(currentuid)
                                            .collection("request")
                                            .doc(data['id'])
                                            .delete()
                                            .then((value) {
                                          showSnakBar(context, Colors.red,
                                              "${data['email']} request is rejected");
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        var currentuid = FirebaseAuth
                                            .instance.currentUser!.uid;
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(currentuid)
                                            .collection("request")
                                            .doc(data['id'])
                                            .update({
                                          "isaccepted": true,
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container();
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text("No request"),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                }
              })
        ],
      );
}
