import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../hosts/widget/widgets.dart';
import './navbar_screen.dart';
import '../../auth/services/database_Service.dart';

class SelectLocation extends StatefulWidget {
  final String categoryName;
  final String title;
  final String desc;
  final double? price;
  List<XFile> images = [];

  SelectLocation({
    required this.categoryName,
    required this.title,
    required this.desc,
    required this.price,
    required this.images,
  });
  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newgoogleMapController;

  double searchLocationContainerheight = 150;
  Position? userCurrentPosition;
  var geolocator = Geolocator();
  bool _isloading = false;

  LocationPermission? _locationPermission;

  checkifLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  Future _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    userCurrentPosition = position;

    newgoogleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              userCurrentPosition!.latitude,
              userCurrentPosition!.longitude,
            ),
            zoom: 14),
      ),
    );
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkifLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.images.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Location",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controllerGoogleMap.complete(controller);
                    newgoogleMapController = controller;
                    _determinePosition();
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(25.0),
                        // decoration: BoxDecoration(),
                        child: ElevatedButton(
                          onPressed: () {
                            uploadData(
                              widget.categoryName,
                              widget.title,
                              widget.desc,
                              widget.price,
                              widget.images,
                              [
                                "${userCurrentPosition!.latitude}",
                                '${userCurrentPosition!.longitude}'
                              ],
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                          ),
                          child: const Text("Proceed"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<String> uploadImage(XFile image, String categoryName) async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    Reference db = FirebaseStorage.instance
        .ref('${id}/${categoryName}/${getImageName(image)}');

    await db.putFile(File(image.path));
    return await db.getDownloadURL();
  }

  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

  Future<List<String>> multiImageUpload(
      List<XFile> list, String categoryName) async {
    List<String> _path = [];

    for (XFile _image in list) {
      _path.add(await uploadImage(_image, categoryName));
    }
    return _path;
  }

  Future uploadData(String categoryName, String title, String desc,
      double? price, List<XFile> images, List<String> location) async {
    if (categoryName.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      List<String> imageUrl = await multiImageUpload(images, categoryName);

      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .updateProviderData(
        categoryName,
        title,
        desc,
        price,
        imageUrl,
        location,
      )
          .whenComplete(() {
        nextScreenReplace(context, const NavBarScreen());
      });
    } else {
      showSnakBar(context, Colors.red, "Failed to update Data");
      setState(() {
        _isloading = false;
      });
    }
  }
}
