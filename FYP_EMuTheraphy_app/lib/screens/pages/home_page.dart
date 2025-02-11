import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/colors.dart';
import '/screens/tabs/camera_tab_screen.dart';
import '/screens/tabs/home_tab_screen.dart';
import '../tabs/profile_tab_screen.dart';
import '/screens/tabs/music_tab.dart';
import '/screens/tabs/contact_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static _HomePageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomePageState>();

}

class _HomePageState extends State<HomePage> {

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeTab(),
    const CameraTab(),
    const MusicTab(),
    const ContactTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondBGColor,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: Image.asset('assets/icons/logo.png'),
        ),
        backgroundColor: secondBGColor,
        elevation: 0,
        title: const Text(
          "EMuTherapy",
          style: TextStyle(fontSize: 26, color: mainFontColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: mainFontColor),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // ✅ Sign out user
              Navigator.of(context).pushReplacementNamed('/login'); // ✅ Navigate to login screen
            },
          ),
        ],
      ),

      body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
                backgroundColor: mainBGColor
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera_front_sharp),
              label: 'Camera',
                backgroundColor: mainBGColor
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.audiotrack_rounded),
              label: 'Music',
                backgroundColor: mainBGColor
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone),
              label: 'Contact',
                backgroundColor: mainBGColor
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: 'Profile',
                backgroundColor: mainBGColor
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: mainFontColor,
          selectedItemColor: darkOrangeColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          onTap: _onItemTapped,
          backgroundColor: mainBGColor,
        ),
      );
  }
}
