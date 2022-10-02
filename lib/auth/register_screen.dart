import 'package:eventapp/auth/login_screen.dart';
import 'package:eventapp/auth/services/verify_email.dart';
import 'package:eventapp/hosts/helper/helper_function.dart';
import 'package:eventapp/hosts/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../hosts/widget/widgets.dart';
import '../const.dart';
import './services/auth_services.dart';

enum SelectCategory {
  // ignore: constant_identifier_names
  Host,
  // ignore: constant_identifier_names
  ServiceProvider,
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isloading = false;
  final formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  String phone = '';
  SelectCategory? _category = SelectCategory.Host;
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
                        "Create an account now to manage your events",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset('assets/register.png'),
                      TextFormField(
                          decoration: textinputDecoration.copyWith(
                            labelText: "Full Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              fullName = val;
                            });
                          },
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be empty";
                            }
                          }),
                      const SizedBox(
                        height: 15.0,
                      ),
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
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: textinputDecoration.copyWith(
                          labelText: "Phone",
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Phone number is required";
                          } else if (val
                              .contains('@#!%^&*()abcbefghigklmnopqrst')) {
                            return "enter valid phone number";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            phone = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      ListTile(
                        title: const Text('Host'),
                        leading: Radio<SelectCategory>(
                          value: SelectCategory.Host,
                          groupValue: _category,
                          fillColor: MaterialStateProperty.all(
                            Constants().primaryColor,
                          ),
                          onChanged: (SelectCategory? value) {
                            setState(() {
                              _category = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('ServiceProvider'),
                        leading: Radio<SelectCategory>(
                          value: SelectCategory.ServiceProvider,
                          groupValue: _category,
                          fillColor: MaterialStateProperty.all(
                            Constants().primaryColor,
                          ),
                          onChanged: (SelectCategory? value) {
                            setState(() {
                              _category = value;
                            });
                          },
                        ),
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
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            register();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Login now",
                                style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => nextScreen(
                                        context,
                                        const LogInScreen(),
                                      ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
    }

    String category = _category.toString().split('.').last;
    await authServices
        .regiseterUser(fullName, email, password, category, phone)
        .then((value) async {
      if (value == true) {
        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserEmail(email);
        await HelperFunction.saveUserNameSp(fullName);
        // ignore: use_build_context_synchronously
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          // ignore: use_build_context_synchronously
          nextScreenReplace(context, const HomeScreen());
        } else {
          // ignore: use_build_context_synchronously
          nextScreen(
            context,
            const VerifyEmail(),
          );
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
