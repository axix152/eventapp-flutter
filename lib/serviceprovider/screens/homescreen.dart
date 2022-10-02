import 'package:eventapp/auth/services/auth_services.dart';
import 'package:eventapp/hosts/helper/helper_function.dart';
import 'package:eventapp/hosts/widget/widgets.dart';
import 'package:eventapp/serviceprovider/screens/home.dart';
import 'package:eventapp/serviceprovider/screens/navbar_screen.dart';
import 'package:flutter/material.dart';

import '../../auth/login_screen.dart';
import '../../const.dart';
import '../screens/details_screen.dart';

enum SelectCategory {
  // ignore: constant_identifier_names
  Resturant,
  Venue,
  Photographer,
  Decorator,
  Transport,
  Catering,
  BeautySaloon,
  Bakeries,
}

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({Key? key}) : super(key: key);

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  AuthServices authServices = AuthServices();
  SelectCategory? _category = SelectCategory.Resturant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Category",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: const Text('Resturant'),
                leading: Radio<SelectCategory>(
                  value: SelectCategory.Resturant,
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
                title: const Text('Venue'),
                leading: Radio<SelectCategory>(
                  value: SelectCategory.Venue,
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
                title: const Text('Photographer'),
                leading: Radio<SelectCategory>(
                  value: SelectCategory.Photographer,
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
                title: const Text('Decorator'),
                leading: Radio<SelectCategory>(
                  value: SelectCategory.Decorator,
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
                title: const Text('Transport'),
                leading: Radio<SelectCategory>(
                  value: SelectCategory.Transport,
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
                title: const Text('Catering'),
                leading: Radio<SelectCategory>(
                  value: SelectCategory.Catering,
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
                title: const Text('BeautySaloon'),
                leading: Radio<SelectCategory>(
                  value: SelectCategory.BeautySaloon,
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
                title: const Text('Bakeries'),
                leading: Radio<SelectCategory>(
                  value: SelectCategory.Bakeries,
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
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: IconButton(
                  onPressed: () {
                    String category = _category.toString().split('.').last;
                    nextScreen(
                      context,
                      DetailScreen(categoryName: category),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_circle_right,
                    size: 45,
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await authServices.singout();
//             // ignore: use_build_context_synchronously
//             Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => LogInScreen()),
//                 (route) => false);
//           },
//           child: const Text("provider Logout"),
//         ),
//       ),