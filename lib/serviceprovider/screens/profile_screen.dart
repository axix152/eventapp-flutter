import 'package:eventapp/auth/services/auth_services.dart';
import 'package:flutter/material.dart';

import '../../auth/login_screen.dart';
import '../../hosts/helper/helper_function.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthServices authServices = AuthServices();
  String userName = '';
  String userEmail = '';

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
    gettingUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.white,
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
                          onPressed: () {},
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              userEmail,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const ListTile(
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
            const ListTile(
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
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                authServices.singout();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LogInScreen()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
