// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/auth/services/auth_services.dart';
import 'package:eventapp/auth/services/database_Service.dart';
import 'package:eventapp/auth/services/verify_email.dart';
import 'package:eventapp/hosts/helper/FirebaseHelper.dart';
import 'package:eventapp/hosts/helper/helper_function.dart';
import 'package:eventapp/hosts/helper/provider_model.dart';
import 'package:eventapp/hosts/helper/usermodel.dart';
import 'package:eventapp/hosts/screens/homescreen.dart';
import 'package:eventapp/main.dart';
import 'package:eventapp/serviceprovider/screens/home.dart';
import 'package:eventapp/serviceprovider/screens/homescreen.dart';
import 'package:eventapp/serviceprovider/screens/navbar_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../hosts/widget/widgets.dart';
import '../auth/register_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isloading = false;
  String role = '';
  String name = '';
  String accountcategory = '';
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Event Planner",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Login now and manage your events!",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset('assets/login.png'),
                      TextFormField(
                        decoration: textinputDecoration.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: textinputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            login();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Register here",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => nextScreen(
                                        context, const RegisterScreen())),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
    }
    await authServices.loginUser(email, password).then((value) async {
      if (value == true) {
        final firebaseuser = FirebaseAuth.instance.currentUser!.uid;

        if (firebaseuser != null) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(firebaseuser)
              .get()
              .then((value) {
            UserModel userModel =
                UserModel.fromMap(value.data() as Map<String, dynamic>);

            role = userModel.category.toString();
            name = userModel.fullName.toString();
          });
        }

        //saving the value to our shared preferences

        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserEmail(email);
        await HelperFunction.saveUserNameSp(name);
        if (role == 'Host') {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            nextScreenReplace(context, const HomeScreen());
          } else {
            nextScreen(context, const VerifyEmail());
          }
        } else {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            final firebaseuser = FirebaseAuth.instance.currentUser!.uid;
            await FirebaseFirestore.instance
                .collection("users")
                .doc(firebaseuser)
                .get()
                .then((value) {
              if (value['accountcategory'] == "Resturant" ||
                  value['accountcategory'] == "Venue" ||
                  value['accountcategory'] == "Photographer" ||
                  value['accountcategory'] == "Decorator" ||
                  value['accountcategory'] == "Transport" ||
                  value['accountcategory'] == "Catering" ||
                  value['accountcategory'] == "BeautySaloon" ||
                  value['accountcategory'] == "Bakeries") {
                nextScreenReplace(context, const NavBarScreen());
              } else {
                nextScreenReplace(context, const ProviderHomeScreen());
              }
            });
          } else {
            nextScreen(
              context,
              const VerifyEmail(),
            );
          }
        }
      } else {
        showSnakBar(context, Colors.red, value);
        setState(() {
          _isloading = false;
        });
      }
    });
  }
}
