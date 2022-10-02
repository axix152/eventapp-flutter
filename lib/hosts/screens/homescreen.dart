import 'package:flutter/material.dart';

import '../../auth/services/auth_services.dart';
import './chat_screen.dart';
import './profile_screen.dart';
import './main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthServices authServices = AuthServices();
  int _selectedindex = 0;
  static const List<Widget> _pageOptions = <Widget>[
    MainScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedindex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
        elevation: 5,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
