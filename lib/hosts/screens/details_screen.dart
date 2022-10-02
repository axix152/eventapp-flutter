import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/auth/services/database_Service.dart';
import 'package:eventapp/hosts/helper/chatRoom_model.dart';
import 'package:eventapp/hosts/helper/provider_model.dart';
import 'package:eventapp/hosts/screens/chat_main_screen.dart';
import 'package:eventapp/hosts/widget/widgets.dart';
import 'package:eventapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../helper/helper_function.dart';

class DetailsScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final double price;
  final String desc;
  final String id;
  final String fullname;
  final double lat;
  final double lon;
  List<String>? images;
  DetailsScreen({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.desc,
    required this.id,
    required this.fullname,
    required this.lat,
    required this.lon,
    required this.images,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var rating = 3.0;
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.4312970),
    zoom: 11.5,
  );

  GoogleMapController? _googleMapController;
  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  Future<ChatRoomModel?> getChatRoomModel() async {
    ChatRoomModel? chatroom;

    String currentuserId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${currentuserId}", isEqualTo: true)
        .where("participants.${widget.id}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      //Fetch this existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatroom = existingChatroom;
    } else {
      // create a new one
      ChatRoomModel newchatroom = ChatRoomModel(
        chatRoomid: uid.v1(),
        participants: {
          currentuserId: true,
          widget.id: true,
        },
        lastmessage: "",
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newchatroom.chatRoomid)
          .set(newchatroom.toMap())
          .whenComplete(() {
        print("new chat room created");
      });
      chatroom = newchatroom;
    }
    return chatroom;
  }

  String userName = '';
  String userEmail = '';
  int activeindex = 0;

  gettingUserData() async {
    await HelperFunction.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunction.getUserEmailSF().then((value) {
      setState(() {
        userEmail = value!;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.pink,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                  height: 300.0,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeindex = index;
                    });
                  }),
              items: widget.images!.map((item) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      top: 5, left: 5, right: 5, bottom: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.network(
                    item,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: buildIndicator(),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${widget.price.toString()}Rs",
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Divider(
                thickness: 0.5,
                color: Colors.black26,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "About",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                widget.desc,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Divider(
                thickness: 0.5,
                color: Colors.black26,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Location",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.37,
              width: double.infinity,
              margin: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _initialCameraPosition,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _googleMapController = controller;
                      getlocation();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Divider(
                thickness: 0.5,
                color: Colors.black26,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListView.builder(
              itemCount: 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.13,
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/aziz.jpeg'),
                      ),
                      title: const Text(
                        'Ahmad Ibrar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        "A very great company providing exellent service recommented",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SmoothStarRating(
                            rating: rating,
                            isReadOnly: true,
                            size: 15,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            starCount: 5,
                            allowHalfRating: true,
                            spacing: 2.0,
                            onRated: (value) {
                              print("rating value -> $value");
                              // print("rating value dd -> ${value.truncate()}");
                            },
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text("just now")
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    child: const Text(
                      "Contact",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      ChatRoomModel? chatRoomModel = await getChatRoomModel();
                      if (chatRoomModel != null) {
                        Navigator.of(context).pop();
                        // ignore: use_build_context_synchronously
                        nextScreen(
                            context,
                            ChatMainScreen(
                                widget.id, widget.fullname, chatRoomModel));
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      "Resquest",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      DatabaseService(uid: widget.id)
                          .updateRequest(userName, userEmail,
                              FirebaseAuth.instance.currentUser!.uid, widget.id)
                          .whenComplete(() {
                        showSnakBar(context, Colors.green,
                            "Request has been sent sucessfully");
                      }).catchError((e) {
                        showSnakBar(
                            context, Colors.red, "Something went wrong");
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getlocation() async {
    _googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 12,
          target: LatLng(widget.lat, widget.lon),
        ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeindex,
        count: widget.images!.length,
        effect: SlideEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: Colors.red,
          dotColor: Colors.black12,
        ),
      );
}
