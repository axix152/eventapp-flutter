// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/login_screen.dart';
import '../../auth/services/auth_services.dart';
import '../helper/helper_function.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthServices authServices = AuthServices();
  String userName = '';
  String userEmail = '';
  XFile? profilepic;
  final ImagePicker imagePicker = ImagePicker();
  Future pickProfile() async {
    try {
      final selectedimage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (selectedimage == null) {
        return;
      }
      setState(() {
        profilepic = selectedimage;
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to pick image:$e");
      return e;
    }
  }

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
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.pink,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 130,
              width: double.infinity,
              child: Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black12,
                      backgroundImage: AssetImage('assets/login.png'),
                    ),
                    Positioned(
                        top: 70,
                        left: 70,
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            pickProfile();
                          },
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              userName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              userEmail,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ListTile(
              leading: Icon(
                Icons.update,
                color: Colors.black,
              ),
              title: Text(
                "Update Profile",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.payment,
                color: Colors.black,
              ),
              title: Text(
                "Payment Info",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                authServices.singout();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LogInScreen()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
